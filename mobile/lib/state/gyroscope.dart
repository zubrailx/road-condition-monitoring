import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GyroscopeModel with ChangeNotifier {
  final Duration _ignoreDuration = const Duration(milliseconds: 20);
  GyroscopeEvent? _gyroscopeEvent;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;
  String? _error;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final Duration _sensorInterval = SensorInterval.uiInterval;

  GyroscopeModel() {
    _subscribeStream();
  }

  GyroscopeEvent? get event => _gyroscopeEvent;

  int? get lastInterval => _gyroscopeLastInterval;

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
          _error =
          "It seems that your device doesn't support Gyroscope Sensor";
          GetIt.I<Talker>().error(_error);
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
  }
}
