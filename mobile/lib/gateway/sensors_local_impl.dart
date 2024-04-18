import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'package:mobile/gateway/abstract/sensors_local.dart';
import 'package:synchronized/synchronized.dart';
import 'package:talker_flutter/talker_flutter.dart';

// TODO: rewrite to typeAdapter
class _SensorIndex {
  String location;
  int position;
  int pending;
  bool isEnd;

  _SensorIndex(
      {required this.location,
      required this.position,
      required this.pending,
      required this.isEnd});

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'position': position,
      'pending': pending,
      'is_end': isEnd,
    };
  }

  factory _SensorIndex.fromJson(Map<String, dynamic> json) {
    return _SensorIndex(
        location: json['location'],
        position: json['position'],
        pending: json['pending'],
        isEnd: json['is_end']);
  }
}

class _SensorIndexContext {
  List<_SensorIndex> indexes;

  _SensorIndexContext({required this.indexes});

  Map<String, dynamic> toJson() {
    return {
      'indexes': indexes.map((index) => index.toJson()).toList(),
    };
  }

  factory _SensorIndexContext.fromJson(Map<String, dynamic> json) {
    return _SensorIndexContext(
      indexes: (json['indexes'] as List<dynamic>)
          .map((indexJson) => _SensorIndex.fromJson(indexJson))
          .toList(),
    );
  }
}

// WARN: need locks for context access
class SensorsLocalGatewayImpl implements SensorsLocalGateway {
  late final String _rootPath;
  late final String _currentDataFileName;

  late final File _currentDataFile;
  late final _SensorIndexContext _indexContext;
  late final File _indexContextFile;
  final Lock _indexLock = Lock();

  SensorsLocalGatewayImpl({required String directoryPath}) {
    _rootPath = directoryPath;
    _currentDataFileName =
        '${DateFormat('yyyy-MM-dd-HH:mm:ss').format(DateTime.now())}.json';

    GetIt.I<Talker>()
        .debug('Current data file: ${p.join(_rootPath, _currentDataFileName)}');

    _init();
  }

  void _init() {
    var contextFile = _createIndexContextFile();

    _SensorIndexContext context;
    try {
      context = _SensorIndexContext.fromJson(
          jsonDecode(contextFile.readAsStringSync()));
    } catch (e) {
      GetIt.I<Talker>().warning(e);
      Directory(_rootPath).deleteSync(recursive: true);
      contextFile = _createIndexContextFile();
      context = _SensorIndexContext(indexes: []);
      _storeIndexContext(contextFile, context); // NOTE: check validity
    }

    var dataFile = File(p.join(_rootPath, _currentDataFileName));
    dataFile.openSync(mode: FileMode.append);

    context.indexes.add(_SensorIndex(
        location: _currentDataFileName, position: 0, pending: 0, isEnd: false));
    _storeIndexContext(contextFile, context);

    _indexContext = context;
    _indexContextFile = contextFile;
    _currentDataFile = dataFile;
  }

  File _createIndexContextFile() {
    var path = p.join(_rootPath, 'index.json');
    GetIt.I<Talker>().debug('Current index file: $path');
    final file = File(path);
    file.createSync(recursive: true);
    return file;
  }

  bool _storeIndexContext(File contextFile, _SensorIndexContext context) {
    contextFile.writeAsStringSync(jsonEncode(context));
    GetIt.I<Talker>().debug('Stored context: $context');
    return true;
  }

  @override
  Future<bool> storeToEnd(SensorsLocalData data) async {
    _currentDataFile.writeAsStringSync('${jsonEncode(data)}\n',
        mode: FileMode.append);
    GetIt.I<Talker>().debug('Stored data: $data.');
    return true;
  }

  @override
  Stream<SensorsLocalData> loadFromBegin({int? maxCount = -1}) async* {
    var controller = StreamController<SensorsLocalData>();

    _indexLock.synchronized(() async {
      var totalLinesRead = 0;

      for (final index in _indexContext.indexes) {
        final file = File(p.join(_rootPath, index.location));
        var terminated = false;
        var linesRead = 0;

        await controller.addStream(file
            .openRead()
            .map(utf8.decode)
            .transform(const LineSplitter())
            .skip(index.position)
            .takeWhile((_) {
          terminated = totalLinesRead == maxCount;
          if (!terminated) {
            ++totalLinesRead;
            ++linesRead;
          }
          return !terminated;
        }).map((l) => SensorsLocalData.fromJson(jsonDecode(l))));

        index.pending += linesRead;
        if (!terminated && index != _indexContext.indexes.last) {
          index.isEnd = true;
        }
        GetIt.I<Talker>().debug(
            'LOAD: count: $totalLinesRead, position: ${index.position}, pending: ${index.pending}, ended: ${index.isEnd}, location: ${index.location}');
      }
      controller.close();
    });

    yield* controller.stream;
  }

  _deleteAckedDataFiles() {
    var index = _indexContext.indexes.first;
    while (index.isEnd && index.position == index.pending) {
      _indexContext.indexes.removeAt(0);
      _storeIndexContext(
          _indexContextFile, _indexContext); // delete index before file
      final path = p.join(_rootPath, index.location);
      File(path).deleteSync();
      GetIt.I<Talker>().debug('DELETE: data file $path');
      index = _indexContext.indexes.first;
    }
    _storeIndexContext(_indexContextFile, _indexContext); // final sync
  }

  _ackFromBegin(int count) {
    for (final index in _indexContext.indexes) {
      var inc = min(index.pending - index.position, count);
      index.position += inc;
      count -= inc;
      if (count == 0) {
        break;
      }
    }
  }

  @override
  Future<bool> ackFromBegin(int count) async {
    GetIt.I<Talker>().debug('ACK: count: $count');
    await _indexLock.synchronized(() {
      _ackFromBegin(count);
      _deleteAckedDataFiles();
    });
    return true;
  }

  @override
  Future<bool> nAckFromBegin(int count) async {
    GetIt.I<Talker>().debug('NACK: count: $count');
    _ackFromBegin(count);

    await _indexLock.synchronized(() {
      for (final index in _indexContext.indexes) {
        if (index.position != index.pending) {
          index.pending = index.position;
          index.isEnd = false;
        }
      }
      _deleteAckedDataFiles();
    });

    return true;
  }
}
