import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerWidget extends StatefulWidget {
  const AccelerometerWidget({super.key});

  @override
  State createState() {
    return _AccelerometerWidgetState();
  }
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  UserAccelerometerEvent? _userAccelerometerEvent;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;

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
          child: Text("Accelerometer", style: theme.textTheme.titleMedium),
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
            Text(_userAccelerometerEvent?.x.toStringAsFixed(2) ?? '?'),
          ]),
          Row(children: [
            const Text("Y:"),
            const SizedBox(width: 10),
            Text(_userAccelerometerEvent?.y.toStringAsFixed(2) ?? '?'),
          ]),
          Row(children: [
            const Text("Y:"),
            const SizedBox(width: 10),
            Text(_userAccelerometerEvent?.z.toStringAsFixed(2) ?? '?'),
          ]),
          Row(children: [
            const Text("Interval:"),
            const SizedBox(width: 10),
            Text('${_userAccelerometerLastInterval?.toString() ?? '?'} ms'),
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
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }
}
