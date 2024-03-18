import 'package:flutter/material.dart';
import 'package:mobile/state/gps.dart';
import 'package:provider/provider.dart';

class GPSWidget extends StatelessWidget {
  const GPSWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<GpsState>();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("GPS", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(children: [
            const Text("latitude:"),
            const SizedBox(width: 10),
            Text(model.position?.latitude.toStringAsFixed(4) ?? '?'),
          ]),
          Row(children: [
            const Text("longitude:"),
            const SizedBox(width: 10),
            Text(model.position?.longitude.toStringAsFixed(4) ?? '?'),
          ]),
        ])
      ],
    );
  }
}
