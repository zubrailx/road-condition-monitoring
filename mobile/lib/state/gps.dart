import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class GpsModel with ChangeNotifier {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  late bool _serviceEnabled;
  late LocationPermission _permission;
  late final StreamSubscription<Position> _positionStream;
  String? _error;

  Position? _position;

  GpsModel() {
    _trySubscribeGeolocation();
  }

  bool get serviceEnabled => _serviceEnabled;
  LocationPermission get permission => _permission;
  Position? get position => _position;
  bool get hasError => error != null;
  String? get error => _error;

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  _trySubscribeGeolocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      _error = 'Location services are disabled.';
      notifyListeners();
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        _error = 'Location permissions are denied';
        notifyListeners();
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      _error = 'Location permissions are permanently denied, we cannot request permissions.';
      notifyListeners();
    }

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      _position = position;
      notifyListeners();
    });
  }
}
