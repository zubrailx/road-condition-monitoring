import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserAccelerometerModel with ChangeNotifier {
  final Duration _ignoreDuration = const Duration(milliseconds: 20);
  UserAccelerometerEvent? _userAccelerometerEvent;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;
  String? _error;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final Duration _sensorInterval = SensorInterval.uiInterval;

  UserAccelerometerModel() {
    _subscribeStream();
  }

  UserAccelerometerEvent? get event => _userAccelerometerEvent;
  int? get lastInterval => _userAccelerometerLastInterval;
  bool get hasError => error != null;
  String? get error => _error;

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void _subscribeStream() {
    _streamSubscriptions.add(
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
          notifyListeners();
        },
        onError: (e) {
          _error = "It seems that your device doesn't support User Accelerometer Sensor";
          GetIt.I<Talker>().error(_error);
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
  }
}
