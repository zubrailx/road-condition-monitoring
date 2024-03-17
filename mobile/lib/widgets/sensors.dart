import 'package:flutter/material.dart';
import 'package:mobile/widgets/accelerometer.dart';
import 'package:mobile/widgets/gps.dart';
import 'package:mobile/widgets/gyroscope.dart';

class SensorsWidget extends StatelessWidget {
  const SensorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccelerometerWidget(),
            SizedBox(height: 16),
            GyroscopeWidget(),
            SizedBox(height: 16),
            GPSWidget()
          ],
        ));
  }
}
