import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/entities/point_response.dart';
import 'package:mobile/features/points.dart';
import 'package:mobile/shared/util.dart';
import 'package:mobile/state/configuration.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MapPointsLayer extends StatefulWidget {
  const MapPointsLayer({super.key});

  @override
  State<StatefulWidget> createState() => _MapPointsLayerState();
}

class _MapPointsLayerState extends State<MapPointsLayer> {
  final Map<int, Map<Pair<int, int>, List<Marker>>> cachedPoints = HashMap();
  bool loading = false;
  final List<Marker> visibleMarkers = [];
  int previousZoom = -1;

  _MapPointsLayerState();

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.maybeOf(context);
    final config = context.watch<ConfigurationState>();

    if (camera == null) {
      return const SizedBox.shrink();
    }

    _loadPoints(camera, config).then((markers) {
      bool updated = _updateVisibleMarkers(camera, markers);
      if (updated) {
        setState(() {
          // _logVisibleMarkers();
        });
      }
    });

    // _logVisibleMarkers();

    return MarkerLayer(markers: visibleMarkers);
  }

  _logVisibleMarkers() {
    GetIt.I<Talker>().debug(
        'MAP POINTS: updated markers, visible: ${visibleMarkers.length}');
  }

  Future<List<Marker>> _loadPoints(
      MapCamera camera, ConfigurationState config) async {
    final ((xLow, xHigh), (yLow, yHigh)) = _calculateTileRange(camera);
    final zoom = _calculateZoom(camera);

    // print(camera.center);
    cachedPoints.putIfAbsent(
        zoom, () => HashMap<Pair<int, int>, List<Marker>>());

    List<Marker> inserted = [];

    if (!loading) {
      loading = true;

      for (int x = xLow; x <= xHigh; ++x) {
        for (int y = yLow; y <= yHigh; ++y) {
          final key = Pair(first: x, second: y);
          if (!cachedPoints[zoom]!.containsKey(key)) {
            final result = await getPoints(
                config.configurationData?.networkApiURL, zoom, x, y);
            final points = result.map((e) => _pointToMarker(e)).toList();
            inserted.addAll(cachedPoints[zoom]!.putIfAbsent(key, () => points));
          }
        }
      }

      loading = false;
    }

    return inserted;
  }

  bool _updateVisibleMarkers(MapCamera camera, List<Marker> inserted) {
    bool updated = false;
    final zoom = _calculateZoom(camera);

    if (previousZoom != zoom) {
      visibleMarkers.clear();
      previousZoom = zoom;
      for (var lst in cachedPoints[zoom]!.values) {
        visibleMarkers.addAll(lst);
      }
      updated = true;
    } else if (inserted.isNotEmpty) {
      visibleMarkers.addAll(inserted);
      updated = true;
    }

    return updated;
  }

  Color _getMarkerColor(PointResponse point) {
    final p = point.prediction;
    final r = min(255, 510 - 510 * p).floor();
    final g = min(255, 510 * p).floor();
    const b = 0;
    return Color.fromRGBO(r, g, b, 1);
  }

  Marker _pointToMarker(PointResponse point) {
    final color = _getMarkerColor(point);
    return Marker(
        point: LatLng(point.latitude, point.longitude),
        // child: SvgPicture.asset("assets/svg/Point.svg",
        //     width: 9,
        //     colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SvgPicture.asset("assets/svg/Point.svg", width: 10),
            SvgPicture.asset("assets/svg/Point.svg",
                width: 9,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          ],
        ),
        height: 10,
        width: 10,
        rotate: false,
        alignment: Alignment.topCenter);
  }

  int _calculateZoom(MapCamera camera) {
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
    super.didUpdateWidget(oldWidget);
  }
}
