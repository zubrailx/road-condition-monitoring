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

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CHARTS", style: theme.textTheme.titleLarge),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Enable accelerometer chart",
                      style: theme.textTheme.bodyLarge),
                  Switch(
                      value: data.accelerometerChartEnabled,
                      onChanged: (_) {
                        configuration.setAccelerometerChartEnabled(
                            !data.accelerometerChartEnabled);
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Enable gyroscope chart", style: theme.textTheme.bodyLarge),
                  Switch(
                      value: data.gyroscopeChartEnabled,
                      onChanged: (_) {
                        configuration
                            .setGyroscopeChartEnabled(!data.gyroscopeChartEnabled);
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Enable GPS chart", style: theme.textTheme.bodyLarge),
                  Switch(
                      value: data.gpsChartEnabled,
                      onChanged: (_) {
                        configuration
                            .setGpsChartEnabled(!data.gpsChartEnabled);
                      }),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Window time seconds'),
                controller: TextEditingController()..text = data.windowTimeSeconds.toString(),
                onSubmitted: (value) {
                  configuration.setWindowTimeSeconds(int.parse(value));
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("NETWORK", style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'API URL'),
                controller: TextEditingController()..text = data.apiURL,
                onSubmitted: (value) {
                  configuration.setApiURL(value);
                },
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Receiver URL'),
                controller: TextEditingController()..text = data.receiverURL,
                onSubmitted: (value) {
                  configuration.setReceiverURL(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
