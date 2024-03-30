import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/features/stream.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GpsState with ChangeNotifier {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  late bool _serviceEnabled;
  late LocationPermission _permission;
  StreamSubscription<Position>? _streamSubscription;
  String? _error;
  Position? _position;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;
  late GpsData _record;

  GpsState() {
    _record = _buildRecord();
    () async {
      await _trySubscribeGeolocation();
      if (hasError) {
        GetIt.I<Talker>().error(_error);
      }
    }();
  }

  bool get serviceEnabled => _serviceEnabled;

  LocationPermission get permission => _permission;

  Position? get position => _position;

  bool get hasError => error != null;

  String? get error => _error;

  bool? get isPaused => _streamSubscription?.isPaused;

  int? get lastInterval => _gyroscopeLastInterval;

  GpsData get record => _record;

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
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

  _trySubscribeGeolocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      _error = 'Location services are disabled.';
      notifyListeners();
      return;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        _error = 'Location permissions are denied';
        notifyListeners();
        return;
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      _error =
          'Location permissions are permanently denied, we cannot request permissions.';
      notifyListeners();
      return;
    }

    _streamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      final now = DateTime.now();
      _position = position;
      if (_gyroscopeUpdateTime != null) {
        final interval = now.difference(_gyroscopeUpdateTime!);
        _gyroscopeLastInterval = interval.inMilliseconds;
      }
      _gyroscopeUpdateTime = now;
      notifyListeners();
    });
  }
}
