import 'package:flutter/material.dart';
import 'package:mobile/state/configuration.dart';
import 'package:mobile/widgets/loading.dart';
import 'package:provider/provider.dart';

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configuration = context.watch<ConfigurationState>();

    if (configuration.configurationData == null) {
      return const LoadingWidget();
    }

    final data = configuration.configurationData!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("CHARTS", style: theme.textTheme.titleLarge),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white24,
                  child: Text('Reminder: disable for more accurate sensor data',
                      style: theme.textTheme.bodyLarge),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Enable accelerometer chart",
                        style: theme.textTheme.bodyLarge),
                    Switch(
                        value: data.chartAccelerometerEnabled,
                        onChanged: (_) {
                          configuration.setChartAccelerometerEnabled(
                              !data.chartAccelerometerEnabled);
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Enable gyroscope chart",
                        style: theme.textTheme.bodyLarge),
                    Switch(
                        value: data.chartGyroscopeEnabled,
                        onChanged: (_) {
                          configuration.setChartGyroscopeEnabled(
                              !data.chartGyroscopeEnabled);
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Enable GPS chart", style: theme.textTheme.bodyLarge),
                    Switch(
                        value: data.chartGpsEnabled,
                        onChanged: (_) {
                          configuration
                              .setChartGpsEnabled(!data.chartGpsEnabled);
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Window time seconds'),
                  controller: TextEditingController()
                    ..text = data.chartWindowTimeSeconds.toString(),
                  onSubmitted: (value) {
                    configuration.setChartWindowTimeSeconds(int.parse(value));
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Refresh time milliseconds'),
                  controller: TextEditingController()
                    ..text = data.chartRefreshTimeMillis.toString(),
                  onSubmitted: (value) {
                    configuration.setChartRefreshTimeMillis(int.parse(value));
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("MAP", style: theme.textTheme.titleLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Display latest location",
                        style: theme.textTheme.bodyLarge),
                    Switch(
                        value: data.mapLocationEnabled,
                        onChanged: (_) {
                          configuration
                              .setMapLocationEnabled(!data.mapLocationEnabled);
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Enable points border",
                        style: theme.textTheme.bodyLarge),
                    Switch(
                        value: data.mapPointsBorderEnabled,
                        onChanged: (_) {
                          configuration.setMapPointsBorderEnabled(
                              !data.mapPointsBorderEnabled);
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Points radius'),
                  controller: TextEditingController()
                    ..text = data.mapPointsSize.toString(),
                  onSubmitted: (value) {
                    configuration.setMapPointsSize(double.parse(value));
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
            const Divider(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("SENSORS", style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'GPS Distance filter (0 to disable)'),
                controller: TextEditingController()
                  ..text = data.gpsDistanceFilter.toString(),
                onSubmitted: (value) {
                  configuration.setGpsDistanceFilter(int.parse(value));
                },
              ),
              const SizedBox(height: 10),
            ]),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("NETWORK", style: theme.textTheme.titleLarge),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'API URL'),
                  controller: TextEditingController()
                    ..text = data.networkApiURL,
                  onSubmitted: (value) {
                    configuration.setNetworkApiURL(value);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Receiver URL'),
                  controller: TextEditingController()
                    ..text = data.networkReceiverURL,
                  onSubmitted: (value) {
                    configuration.setNetworkReceiverURL(value);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Buffer time seconds'),
                  controller: TextEditingController()
                    ..text = data.networkBufferTimeSeconds.toString(),
                  onSubmitted: (value) {
                    configuration.setNetworkBufferTimeSeconds(int.parse(value));
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
