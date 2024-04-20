import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

class PredictionPoint {
  final double latitude;
  final double longitude;
  final double prediction;

  PredictionPoint(
      {required this.latitude,
      required this.longitude,
      required this.prediction});

  LatLng get latLng => LatLng(latitude, longitude);

  @override
  String toString() => 'LocationMarkerPosition('
      'latitude: $latitude, '
      'longitude: $longitude, '
      'prediction: $prediction)';
}

class MapPointsLayer extends StatefulWidget {
  const MapPointsLayer({super.key});

  @override
  State<StatefulWidget> createState() => _MapPointsLayerState();
}

class _MapPointsLayerState extends State<MapPointsLayer> {
  Map<int, Map<(int, int), List<PredictionPoint>>> cachedPoints = {};

  _MapPointsLayerState();

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.maybeOf(context);

    if (camera == null) {
      return const SizedBox.shrink();
    }

    final ((xLow, xHigh), (yLow, yHigh)) = _calculateTileRange(camera);
    final zoom = _calculateZoom(camera);

    // print(camera.center);
    print("z: $zoom, $xLow - $xHigh, $yLow - $yHigh");
    print(camera.center);

    List<Marker> markers = [
      _predictionToMarker(PredictionPoint(latitude: 60.004, longitude: 30.364, prediction: 0.5)),
      _predictionToMarker(PredictionPoint(latitude: 60.004, longitude: 30.365, prediction: 0.3)),
      _predictionToMarker(PredictionPoint(latitude: 60.004, longitude: 30.366, prediction: 1)),
      _predictionToMarker(PredictionPoint(latitude: 60.004, longitude: 30.367, prediction: 0)),
    ];

    return MarkerLayer(markers: markers);
  }

  Color _getMarkerColor(PredictionPoint point) {
    final p = point.prediction;
    final r = min(255, 510 - 510 * p).floor();
    final g = min(255, 510 * p).floor();
    const b = 0;
    return Color.fromRGBO(r, g, b, 1);
  }

  _predictionToMarker(PredictionPoint point) {
    final color = _getMarkerColor(point);
    return Marker(
        point: LatLng(point.latitude, point.longitude),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SvgPicture.asset("assets/svg/Point.svg", width: 10),
            SvgPicture.asset("assets/svg/Point.svg",
                width: 9,
                colorFilter:
                    ColorFilter.mode(color, BlendMode.srcIn)),
          ],
        ),
        height: 10,
        width: 10,
        rotate: false,
        alignment: Alignment.topCenter);
  }

  _calculateZoom(MapCamera camera) {
    return camera.zoom.floor();
  }

  // https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames
  ((int, int), (int, int)) _calculateTileRange(MapCamera camera) {
    final bounds = camera.visibleBounds;

    final topLeft = bounds.southWest;
    final bottomRight = bounds.northEast;

    final zoom = _calculateZoom(camera);

    final (topXTile, topYTile) =
        _calculateTile(topLeft.longitude, topLeft.latitude, zoom);
    final (bottomXTile, bottomYTile) =
        _calculateTile(bottomRight.longitude, bottomRight.latitude, zoom);

    final topXInt = topXTile.floor();
    final topYInt = topYTile.ceil();
    final bottomXInt = bottomXTile.ceil();
    final bottomYInt = bottomYTile.floor();

    return ((topXInt, bottomXInt), (bottomYInt, topYInt));
  }

  (double, double) _calculateTile(double longitude, double latitude, int zoom) {
    final tiles = pow(2, zoom.floor());

    final xTile = (((longitude + 180) / 360) * tiles);
    final latRad = latitude * (pi / 180);
    final yTile = ((1 - (log(tan(latRad) + 1 / cos(latRad)) / pi)) * tiles / 2);
    return (xTile, yTile);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MapPointsLayer oldWidget) {
    // print('updated');
    super.didUpdateWidget(oldWidget);
  }
}
