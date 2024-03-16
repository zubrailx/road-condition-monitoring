import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeWidget extends StatefulWidget {
  const GyroscopeWidget({super.key});

  @override
  State createState() {
    return _GyroscopeWidgetState();
  }
}

class _GyroscopeWidgetState extends State<GyroscopeWidget> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  GyroscopeEvent? _gyroscopeEvent;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.uiInterval;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Gyroscope", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: UsedColors.gray.value,
          ),
        ),
        const SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(children: [
            const Text("X:"),
            const SizedBox(width: 10),
            Text(_gyroscopeEvent?.x.toStringAsFixed(2) ?? '?'),
          ]),
          Row(children: [
            const Text("Y:"),
            const SizedBox(width: 10),
            Text(_gyroscopeEvent?.y.toStringAsFixed(2) ?? '?'),
          ]),
          Row(children: [
            const Text("Y:"),
            const SizedBox(width: 10),
            Text(_gyroscopeEvent?.z.toStringAsFixed(2) ?? '?'),
          ]),
          Row(children: [
            const Text("Interval:"),
            const SizedBox(width: 10),
            Text('${_gyroscopeLastInterval?.toString() ?? '?'} ms'),
          ]),
        ])
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }
}
