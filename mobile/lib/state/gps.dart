import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GpsModel with ChangeNotifier {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  late bool _serviceEnabled;
  late LocationPermission _permission;
  late final StreamSubscription<Position> _streamSubscription;
  String? _error;
  Position? _position;

  GpsModel() {
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
  bool get isPaused => _streamSubscription.isPaused;

  void pause() {
    _streamSubscription.pause();
  }

  void resume() {
    _streamSubscription.resume();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
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
      _position = position;
      notifyListeners();
    });
  }
}
