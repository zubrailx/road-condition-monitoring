import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/route.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/gateway/shared_preferences.dart';
import 'package:mobile/pages/logs_page.dart';
import 'package:mobile/pages/root_page.dart';
import 'package:mobile/state/accelerometer_window.dart';
import 'package:mobile/state/chart.dart';
import 'package:mobile/state/gps.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:mobile/state/accelerometer.dart';
import 'package:mobile/state/sensor_transmitter.dart';
import 'package:mobile/state/gyroscope_window.dart';
import 'package:mobile/state/configuration.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      title: 'RoadCondition',
      theme: darkTheme,
      routes: {
        AppRoutes.root.v: (context) => const RootPage(),
        AppRoutes.logs.v: (context) => const LogsPage(),
      },
    );

    return MultiProvider(providers: [
      // Configuration
      ChangeNotifierProvider(create: (_) => ConfigurationState()),
      // Sensors
      ChangeNotifierProxyProvider<ConfigurationState, GpsState>(
        create: (_) => GpsState(),
        update: (_, ConfigurationState value, GpsState? previous) {
          previous ??= GpsState();
          previous.updateConfiguration(value.configurationData);
          return previous;
        },
      ),
      ChangeNotifierProxyProvider<ConfigurationState, AccelerometerState>(
        create: (_) => AccelerometerState(),
        update: (_, value, AccelerometerState? previous) {
          previous ??= AccelerometerState();
          previous.updateConfiguration(value.configurationData);
          return previous;
        },
      ),
      ChangeNotifierProxyProvider<ConfigurationState, GyroscopeState>(
        create: (_) => GyroscopeState(),
        update: (_, value, GyroscopeState? previous) {
          previous ??= GyroscopeState();
          previous.updateConfiguration(value.configurationData);
          return previous;
        },
      ),
      // Chart
      ChangeNotifierProxyProvider2<ConfigurationState, AccelerometerState, AccelerometerWindowState>(
          create: (_) => AccelerometerWindowState(),
          update: (_, config, state, windowState) {
            windowState ??= AccelerometerWindowState();
            windowState.append(state.record);
            windowState.updateConfiguration(config.configurationData);
            return windowState;
          }),
      ChangeNotifierProxyProvider2<ConfigurationState, GyroscopeState, GyroscopeWindowState>(
          create: (_) => GyroscopeWindowState(),
          update: (_, config, state, windowState) {
            windowState ??= GyroscopeWindowState();
            windowState.append(state.record);
            windowState.updateConfiguration(config.configurationData);
            return windowState;
          }),
      ChangeNotifierProvider(create: (_) => ChartState()),
      // Sensor Translation
      ChangeNotifierProxyProvider3<AccelerometerState, GyroscopeState, GpsState,
          SensorTransmitter>(
        create: (_) => SensorTransmitter(),
        update: (_, accelerometerState, gyroscopeState, gpsState, transmitter) {
          transmitter ??= SensorTransmitter();
          transmitter.appendAccelerometer(accelerometerState.record);
          transmitter.appendGyroscope(gyroscopeState.record);
          transmitter.appendGps(gpsState.record);
          return transmitter;
        },
        lazy: false,
      ),
    ], child: app);
  }
}

void run() async {
  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);

    final sharedPrefGateway = await SharedPrefGateway.create();
    GetIt.I.registerSingleton(sharedPrefGateway);

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    runApp(const App());
  }, (e, st) {
    GetIt.I<Talker>().handle(e, st);
  });
}
