import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/state/gyroscope_record.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GyroscopeModel with ChangeNotifier {
  final Duration _ignoreDuration = const Duration(milliseconds: 20);
  GyroscopeEvent? _gyroscopeEvent;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;
  String? _error;

  StreamSubscription<GyroscopeEvent>? _streamSubscription;
  final Duration _sensorInterval = SensorInterval.uiInterval;

  GyroscopeModel() {
    _subscribeStream();
  }

  GyroscopeEvent? get event => _gyroscopeEvent;
  int? get lastInterval => _gyroscopeLastInterval;
  bool get hasError => error != null;
  String? get error => _error;
  bool? get isPaused => _streamSubscription?.isPaused;
  DateTime? get lastTime => _gyroscopeUpdateTime;
  GyroscopeRecord get record => GyroscopeRecord(
        time: _gyroscopeUpdateTime,
        x: _gyroscopeEvent?.x,
        y: _gyroscopeEvent?.y,
        z: _gyroscopeEvent?.z,
        ms: _gyroscopeLastInterval,
      );

  void pause() {
    _streamSubscription?.pause();
  }

  void resume() {
    _streamSubscription?.resume();
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
          if (interval > _ignoreDuration) {
            _gyroscopeLastInterval = interval.inMilliseconds;
          }
        }
        _gyroscopeUpdateTime = now;
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
