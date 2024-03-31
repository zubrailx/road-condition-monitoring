import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'package:mobile/gateway/abstract/sensors_local.dart';
import 'package:talker_flutter/talker_flutter.dart';

// TODO: rewrite to typeAdapter
class _SensorIndex {
  String location;
  int position;

  _SensorIndex({required this.location, required this.position});

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'position': position,
    };
  }

  factory _SensorIndex.fromJson(Map<String, dynamic> json) {
    return _SensorIndex(
      location: json['location'],
      position: json['position'],
    );
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

class SensorsLocalGatewayImpl implements SensorsLocalGateway {
  late final String _rootPath;
  late final String _currentDataFileName;

  late Future<File> _currentDataFile;
  late Future<_SensorIndexContext> _indexContext;
  late Future<File> _indexContextFile;

  SensorsLocalGatewayImpl({required String directoryPath}) {
    _rootPath = directoryPath;
    _currentDataFileName =
        '${DateFormat('yyyy-MM-dd-HH:mm:ss').format(DateTime.now())}.json';

    _createIndexContextFile();
    _createIndexContext();
    _createDataFile();
  }

  void _createIndexContextFile() {
    var path = p.join(_rootPath, 'index.json');
    _indexContextFile = File(path).create(recursive: true);
  }

  Future<bool> _storeIndexContext(_SensorIndexContext context) {
    return _indexContextFile.then((file) {
      file.writeAsStringSync(jsonEncode(context));
      return true;
    }).onError((e, s) {
      GetIt.I<Talker>().warning(e);
      return false;
    });
  }

  void _createIndexContext() {
    _indexContext = _indexContextFile.then((file) {
      late final _SensorIndexContext context;
      // if can't decode current context -> reset all files, create new context file,
      try {
        context =
            _SensorIndexContext.fromJson(jsonDecode(file.readAsStringSync()));
      } catch (e) {
        GetIt.I<Talker>().warning(e);
        Directory(_rootPath).deleteSync(recursive: true);
        _createIndexContextFile();
        context = _SensorIndexContext(indexes: []);
        _storeIndexContext(context);
      }
      return context;
    });
  }

  void _createDataFile() {
    _currentDataFile = File(p.join(_rootPath, _currentDataFileName))
        .create(recursive: true)
        .then((file) async {
      var context = await _indexContext;
      context.indexes
          .add(_SensorIndex(location: _currentDataFileName, position: 0));
      _storeIndexContext(context);
      return file;
    });
  }

  @override
  Future<bool> storeToEnd(SensorsLocalData data) {
    GetIt.I<Talker>().debug('Storing data locally: $data.');
    return _currentDataFile.then((file) {
      file.writeAsString('${jsonEncode(data)}\n', mode: FileMode.append);
      return true;
    });
  }

  @override // NOTE: while not equals
  Stream<SensorsLocalData> loadFromBegin({int? maxCount = -1}) async* {
    GetIt.I<Talker>().debug('Loading from local storage.');
  }

  @override
  Future<bool> ackFromBegin(int count) async {
    return true;
  }

  @override
  Future<bool> nackFromBegin(int count) async {
    return true;
  }
}
