import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/state/user_accelerometer.dart';
import 'package:provider/provider.dart';

class AccelerometerWidget extends StatelessWidget {
  const AccelerometerWidget({super.key});

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
        const AccelerometerChartWidget(),
        const SizedBox(height: 5),
        const AccelerometerValuesWidget()
      ],
    );
  }
}

class AccelerometerChartWidget extends StatelessWidget {
  const AccelerometerChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(
          color: UsedColors.gray.value,
        ),
      );
  }
}

class AccelerometerValuesWidget extends StatelessWidget {
  const AccelerometerValuesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserAccelerometerState>();

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(children: [
        const Text("X:"),
        const SizedBox(width: 10),
        Text(model.event?.x.toStringAsFixed(2) ?? '?'),
      ]),
      Row(children: [
        const Text("Y:"),
        const SizedBox(width: 10),
        Text(model.event?.y.toStringAsFixed(2) ?? '?'),
      ]),
      Row(children: [
        const Text("Z:"),
        const SizedBox(width: 10),
        Text(model.event?.z.toStringAsFixed(2) ?? '?'),
      ]),
      Row(children: [
        const Text("Interval:"),
        const SizedBox(width: 10),
        Text('${model.lastInterval?.toString() ?? '?'} ms'),
      ]),
    ]);
  }
}
