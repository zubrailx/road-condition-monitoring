import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPSWidget extends StatefulWidget {
  const GPSWidget({super.key});

  @override
  State createState() {
    return _GPSWidgetState();
  }
}

class _GPSWidgetState extends State<GPSWidget> {
  late bool _serviceEnabled;
  late LocationPermission _permission;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  late final StreamSubscription<Position> _positionStream;
  Position? _position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("GPS", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(children: [
            const Text("latitude:"),
            const SizedBox(width: 10),
            Text(_position?.latitude.toStringAsFixed(4) ?? '?'),
          ]),
          Row(children: [
            const Text("longitude:"),
            const SizedBox(width: 10),
            Text(_position?.longitude.toStringAsFixed(4) ?? '?'),
          ]),
        ])
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  _trySubscribeGeolocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
          setState(() {
            _position = position;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    _trySubscribeGeolocation();
  }
}
