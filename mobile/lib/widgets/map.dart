import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/state/gps.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController _mapController;

  Marker _getUserMarker(LatLng mapPoint) {
    return Marker(
        point: mapPoint,
        child: Image.asset("assets/svg/UserMap.png", width: 32),
        height: 50,
        width: 50,
        rotate: true,
        alignment: Alignment.topCenter);
  }

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gpsState = context.watch<GpsState>();

    final record = gpsState.record;
    final hasRecord = record.latitude != null;

    if (hasRecord) {
      return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(record.latitude!, record.longitude!),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_map_example',
              ),
              MarkerLayer(
                markers: [
                 _getUserMarker(LatLng(record.latitude!, record.longitude!)),
                ]
              ),
              const MarkerLayer(
                  markers: []
              ),
            ],
          );
    }

    return Container(
      decoration: BoxDecoration(
      color: UsedColors.gray.value,
    ));
  }
}
