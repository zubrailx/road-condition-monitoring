import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/features/points.dart';
import 'package:mobile/state/gps.dart';
import 'package:mobile/widgets/map_controls.dart';
import 'package:mobile/widgets/map_points.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController _mapController;
  late final List<String> sourcesTypes;
  late String selectedType;
  late LoadFunctionT loadFunction;

  DateTime rawBegin = DateTime.now().subtract(const Duration(days: 1));
  DateTime rawEnd = DateTime.now();
  double rawPredictionMin = 0;
  double rawPredictionMax = 1;

  @override
  void initState() {
    _mapController = MapController();
    sourcesTypes = ["Raw", "Aggregated"];
    selectedType = "Raw";
    loadFunction = _getLoadFunction();
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

    final children = <Widget>[];

    if (hasRecord) {
      children.add(FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(record.latitude!, record.longitude!),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_map_example',
          ),
          CurrentLocationLayer(),
          MapPointsLayer(loadFunction: loadFunction),
          // const MarkerLayer(markers: []),
        ],
      ));
    } else {
      children.add(Container(
          decoration: BoxDecoration(
        color: UsedColors.gray.value,
      )));
    }

    final List<Widget> sourcesValues = <Widget>[
      MapControlRawWidget(
        predictionMin: rawPredictionMin,
        predictionMax: rawPredictionMax,
        predictionOnChangeEnd: _predictionOnChangeEnd,
        begin: rawBegin,
        end: rawEnd,
        onBeginChange: _onRawBeginChange,
        onEndChange: _onRawEndChange,
      ),
      const MapControlAggregatedWidget()
    ];

    children.add(Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: MapControlsWidget(
            initialIndex: sourcesTypes.indexOf(selectedType),
            onSelected: _onTypeSelected,
            sourcesTypes: sourcesTypes,
            sourcesValues: sourcesValues)));

    return Stack(
      children: children,
    );
  }

  LoadFunctionT _getLoadFunction() {
    switch (selectedType) {
      case "Raw":
        // TODO: change filtering in loadFunction to separate function for MapPoints layer
        return (apiUrl, z, x, y) async {
          final res =
              await getPointsBeginEnd(apiUrl, z, x, y, rawBegin, rawEnd);
          return res
              .where((e) =>
                  e.prediction >= rawPredictionMin &&
                  e.prediction <= rawPredictionMax)
              .toList();
        };
      case "Aggregated":
      default:
        return (apiUrl, z, x, y) => Future.value([]);
    }
  }

  void _onTypeSelected(String? value) {
    if (value != null) {
      setState(() {
        selectedType = value;
        loadFunction = _getLoadFunction();
      });
    }
  }

  void _onRawBeginChange(DateTime? begin) {
    if (begin != null) {
      setState(() {
        rawBegin = begin;
        loadFunction = _getLoadFunction();
      });
    }
  }

  void _onRawEndChange(DateTime? end) {
    if (end != null) {
      setState(() {
        rawEnd = end;
        loadFunction = _getLoadFunction();
      });
    }
  }

  void _predictionOnChangeEnd(double min, double max) {
    setState(() {
      rawPredictionMin = min;
      rawPredictionMax = max;
      loadFunction = _getLoadFunction();
    });
  }
}
