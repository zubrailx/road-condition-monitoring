import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/features/stream.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AccelerometerState with ChangeNotifier {
  final Duration _ignoreDuration = const Duration(milliseconds: 20);
  UserAccelerometerEvent? _userAccelerometerEvent;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;
  String? _error;
  late AccelerometerData _record;

  StreamSubscription<UserAccelerometerEvent>? _streamSubscription;
  final Duration _sensorInterval = SensorInterval.uiInterval;

  AccelerometerState() {
    _record = _buildRecord();
    _subscribeStream();
  }

  int? get lastInterval => _userAccelerometerLastInterval;

  UserAccelerometerEvent? get event => _userAccelerometerEvent;

  DateTime? get lastTime => _userAccelerometerUpdateTime;

  bool get hasError => error != null;

  String? get error => _error;

  bool? get isPaused => _streamSubscription?.isPaused;

  AccelerometerData get record => _record;

  AccelerometerData _buildRecord() {
    return AccelerometerData(
      time: _userAccelerometerUpdateTime,
      x: _userAccelerometerEvent?.x,
      y: _userAccelerometerEvent?.y,
      z: _userAccelerometerEvent?.z,
      ms: _userAccelerometerLastInterval,
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
        userAccelerometerEventStream(samplingPeriod: _sensorInterval).listen(
      (UserAccelerometerEvent event) {
        final now = DateTime.now();
        _userAccelerometerEvent = event;
        if (_userAccelerometerUpdateTime != null) {
          final interval = now.difference(_userAccelerometerUpdateTime!);
          if (interval > _ignoreDuration) {
            _userAccelerometerLastInterval = interval.inMilliseconds;
          }
        }
        _userAccelerometerUpdateTime = now;
        _record = _buildRecord();
        notifyListeners();
      },
      onError: (e) {
        _error =
            "It seems that your device doesn't support User Accelerometer Sensor";
        GetIt.I<Talker>().error(_error);
        notifyListeners();
      },
      cancelOnError: true,
    );
  }
}
