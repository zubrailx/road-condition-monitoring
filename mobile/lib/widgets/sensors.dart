import 'package:flutter/material.dart';
import 'package:mobile/state/configuration.dart';
import 'package:mobile/widgets/accelerometer.dart';
import 'package:mobile/widgets/gps.dart';
import 'package:mobile/widgets/gyroscope.dart';
import 'package:provider/provider.dart';

class SensorsWidget extends StatelessWidget {
  const SensorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ConfigurationState>().configurationData;

    final children = <Widget>[];

    if (data == null || data.chartAccelerometerEnabled) {
      children.add(const AccelerometerWidget());
      children.add(const SizedBox(height: 16));
    }

    if (data == null || data.chartGyroscopeEnabled) {
      children.add(const GyroscopeWidget());
      children.add(const SizedBox(height: 16));
    }

    if (data == null || data.chartGpsEnabled) {
      children.add(const GPSWidget());
    }

    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ));
  }
}
