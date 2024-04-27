import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/app/theme.dart';
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
    final gpsState = context.watch<GpsState>();
    final theme = Theme.of(context);

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Latitude: ${gpsState.position?.latitude}"),
                    Text("Longitude: ${gpsState.position?.longitude}"),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MapControlRawWidget extends StatelessWidget {
  final DateTime begin;
  final DateTime end;
  final void Function(DateTime?) onBeginChange;
  final void Function(DateTime?) onEndChange;
  const MapControlRawWidget({
    super.key,
    required this.begin,
    required this.end,
    required this.onBeginChange,
    required this.onEndChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Begin'),
              controller: TextEditingController()
                ..text = _dateFormat.format(begin),
              onSubmitted: (value) {
                onBeginChange(_dateFormat.parse(value));
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
                ..text = _dateFormat.format(end),
              onSubmitted: (value) {
                onEndChange(_dateFormat.parse(value));
              },
            ),
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
