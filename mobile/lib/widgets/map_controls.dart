import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/state/configuration.dart';
import 'package:mobile/state/gps.dart';
import 'package:provider/provider.dart';

const String _dateFormatString = "yyyy-MM-dd HH:mm:ss";
DateFormat _dateFormat = DateFormat(_dateFormatString);

class MapControlsWidget extends StatefulWidget {
  final int initialIndex;
  final void Function(String?) onSelected;
  final List<String> sourcesTypes;
  final List<Widget> sourcesValues;

  const MapControlsWidget(
      {super.key,
      required this.initialIndex,
      required this.onSelected,
      required this.sourcesTypes,
      required this.sourcesValues});

  @override
  State<StatefulWidget> createState() {
    return _MapControlsWidgetState();
  }
}

class _MapControlsWidgetState extends State<MapControlsWidget> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigurationState>();
    final gpsState = context.watch<GpsState>();
    final theme = Theme.of(context);

    final isLocationEnabled =
        config.configurationData?.mapLocationEnabled ?? true;

    return Container(
      color: UsedColors.black.value,
      padding: const EdgeInsetsDirectional.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.sourcesValues.elementAt(index),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              DropdownMenu(
                  inputDecorationTheme: theme.inputDecorationTheme,
                  trailingIcon: null,
                  onSelected: (value) {
                    widget.onSelected(value);
                    if (value != null) {
                      setState(() {
                        index = widget.sourcesTypes.indexOf(value);
                      });
                    }
                  },
                  initialSelection: widget.sourcesTypes.elementAt(index),
                  dropdownMenuEntries: widget.sourcesTypes
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry(value: value, label: value);
                  }).toList()),
              const SizedBox(width: 30),
              (isLocationEnabled
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Latitude: ${gpsState.position?.latitude}"),
                          Text("Longitude: ${gpsState.position?.longitude}"),
                        ],
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ],
      ),
    );
  }
}

class MapControlRawWidget extends StatefulWidget {
  final double predictionMin;
  final double predictionMax;
  final void Function(double, double)? predictionOnChangeEnd;
  final DateTime begin;
  final DateTime end;
  final void Function(DateTime?) onBeginChange;
  final void Function(DateTime?) onEndChange;

  const MapControlRawWidget({
    super.key,
    this.predictionMin = 0,
    this.predictionMax = 1,
    this.predictionOnChangeEnd,
    required this.begin,
    required this.end,
    required this.onBeginChange,
    required this.onEndChange,
  });

  @override
  State<StatefulWidget> createState() {
    return _MapControlRawState();
  }
}

class _MapControlRawState extends State<MapControlRawWidget> {
  late double minPrediction = widget.predictionMin;
  late double maxPrediction = widget.predictionMax;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(minPrediction.toStringAsFixed(2)),
                    Expanded(
                      child: Slider(
                        value: minPrediction,
                        secondaryTrackValue: maxPrediction,
                        min: 0,
                        max: 1,
                        label: minPrediction.toStringAsFixed(2),
                        onChanged: (double value) {
                          setState(() {
                            if (value <= maxPrediction) {
                              minPrediction = value;
                            }
                          });
                        },
                        onChangeEnd: (double value) {
                          if (widget.predictionOnChangeEnd != null) {
                            widget.predictionOnChangeEnd!(
                                minPrediction, maxPrediction);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(maxPrediction.toStringAsFixed(2)),
                    Expanded(
                      child: Slider(
                        value: maxPrediction,
                        label: maxPrediction.toStringAsFixed(2),
                        min: 0,
                        max: 1,
                        onChanged: (double value) {
                          setState(() {
                            maxPrediction = value;
                            if (minPrediction > value) {
                              minPrediction = value;
                            }
                          });
                        },
                        onChangeEnd: (double value) {
                          if (widget.predictionOnChangeEnd != null) {
                            widget.predictionOnChangeEnd!(
                                minPrediction, maxPrediction);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Begin'),
                  controller: TextEditingController()
                    ..text = _dateFormat.format(widget.begin),
                  onSubmitted: (value) {
                    widget.onBeginChange(_dateFormat.parse(value));
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'End'),
                  controller: TextEditingController()
                    ..text = _dateFormat.format(widget.end),
                  onSubmitted: (value) {
                    widget.onEndChange(_dateFormat.parse(value));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MapControlAggregatedWidget extends StatelessWidget {
  const MapControlAggregatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("NOT IMPLEMENTED");
  }
}
