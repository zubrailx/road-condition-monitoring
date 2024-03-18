import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:provider/provider.dart';

class GyroscopeWidget extends StatelessWidget {
  const GyroscopeWidget({super.key});

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
        const GyroscopeChartWidget(),
        const SizedBox(height: 5),
        const GyroscopeValuesWidget(),
      ],
    );
  }
}

class GyroscopeChartWidget extends StatelessWidget {
  const GyroscopeChartWidget({super.key});

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

class GyroscopeValuesWidget extends StatelessWidget {
  const GyroscopeValuesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<GyroscopeState>();

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
