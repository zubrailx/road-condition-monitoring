import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/features/stream.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GyroscopeState with ChangeNotifier {
  GyroscopeEvent? _gyroscopeEvent;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;
  String? _error;
  late GyroscopeData _record;

  StreamSubscription<GyroscopeEvent>? _streamSubscription;
  final Duration _sensorInterval = const Duration(milliseconds: 50);

  GyroscopeState() {
    _record = _buildRecord();
    _subscribeStream();
  }

  GyroscopeEvent? get event => _gyroscopeEvent;

  int? get lastInterval => _gyroscopeLastInterval;

  bool get hasError => error != null;

  String? get error => _error;

  bool? get isPaused => _streamSubscription?.isPaused;

  DateTime? get lastTime => _gyroscopeUpdateTime;

  GyroscopeData get record => _record;

  GyroscopeData _buildRecord() {
    return GyroscopeData(
      time: _gyroscopeUpdateTime,
      x: _gyroscopeEvent?.x,
      y: _gyroscopeEvent?.y,
      z: _gyroscopeEvent?.z,
      ms: _gyroscopeLastInterval,
    );
  }

  updateConfiguration(ConfigurationData? configurationData) {
    if (configurationData == null || configurationData.sensorsEnabled) {
      resume(_streamSubscription);
    } else {
      pause(_streamSubscription);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

  void _subscribeStream() {
    _streamSubscription =
        gyroscopeEventStream(samplingPeriod: _sensorInterval).listen(
      (GyroscopeEvent event) {
        final now = DateTime.now();
        _gyroscopeEvent = event;
        if (_gyroscopeUpdateTime != null) {
          final interval = now.difference(_gyroscopeUpdateTime!);
          _gyroscopeLastInterval = interval.inMilliseconds;
        }
        _gyroscopeUpdateTime = now;
        _record = _buildRecord();
        notifyListeners();
      },
      onError: (e) {
        _error = "It seems that your device doesn't support Gyroscope Sensor";
        GetIt.I<Talker>().error(_error);
        notifyListeners();
      },
      cancelOnError: true,
    );
  }
}
