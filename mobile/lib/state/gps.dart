import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/features/notifications.dart';
import 'package:mobile/features/stream.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GpsState with ChangeNotifier {
  int _distanceFilter = ConfigurationData.create().gpsDistanceFilter;
  StreamSubscription<Position>? _streamSubscription;
  String? _error;
  Position? _position;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;

  late bool _serviceEnabled;
  late GpsData _record;

  GpsState() {
    _record = _buildRecord();
    () async {
      await _trySubscribeGeolocation(true);
      if (hasError) {
        GetIt.I<Talker>().error(_error);
      }
    }();
  }

  bool get serviceEnabled => _serviceEnabled;

  Position? get position => _position;

  bool get hasError => error != null;

  String? get error => _error;

  bool? get isPaused => _streamSubscription?.isPaused;

  int? get lastInterval => _gyroscopeLastInterval;

  GpsData get record => _record;

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

  _buildRecord() {
    return GpsData(
        time: _gyroscopeUpdateTime,
        latitude: position?.latitude,
        longitude: position?.longitude,
        accuracy: position?.accuracy,
        ms: _gyroscopeLastInterval);
  }

  updateConfiguration(ConfigurationData? configurationData) {
    if (configurationData == null || configurationData.sensorsEnabled) {
      resume(_streamSubscription);
    } else {
      pause(_streamSubscription);
    }
    if (configurationData != null &&
        configurationData.gpsDistanceFilter != _distanceFilter) {
      _distanceFilter = configurationData.gpsDistanceFilter;
      _repeatSubscribe(true);
    }
  }

  void _repeatSubscribe(bool doNotify) async {
    await _streamSubscription?.cancel();
    await _trySubscribeGeolocation(doNotify);
    GetIt.I<Talker>().debug("GPS: resubscribed");
  }

  _trySubscribeGeolocation(bool doNotify) async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      _error = 'Location services are disabled.';
      if (doNotify) {
        showNotification(title: "Geolocation", body: _error ?? "");
      }
      // try resubscribe after 3 seconds, don't show notification
      Future.delayed(const Duration(seconds: 3), () => _repeatSubscribe(false));
      return;
    }

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: _distanceFilter,
    );

    _streamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
      final now = DateTime.now();
      _position = position;
      if (_gyroscopeUpdateTime != null) {
        final interval = now.difference(_gyroscopeUpdateTime!);
        _gyroscopeLastInterval = interval.inMilliseconds;
      }
      _gyroscopeUpdateTime = now;
      _record = _buildRecord();
      notifyListeners();
    }, onError: (Object o) {
      showNotification(title: "Geolocation", body: o.toString());
      _repeatSubscribe(false);
    });
  }
}
