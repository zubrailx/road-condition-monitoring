import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/route.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/features/notifications.dart';
import 'package:mobile/gateway/configuration_impl.dart';
import 'package:mobile/gateway/notifications.dart';
import 'package:mobile/gateway/sensors_local_impl.dart';
import 'package:mobile/gateway/sensors_network_impl.dart';
import 'package:mobile/pages/logs_page.dart';
import 'package:mobile/pages/root_page.dart';
import 'package:mobile/shared/files.dart';
import 'package:mobile/state/accelerometer_window.dart';
import 'package:mobile/state/chart.dart';
import 'package:mobile/state/gps.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:mobile/state/accelerometer.dart';
import 'package:mobile/state/sensor_transmitter.dart';
import 'package:mobile/state/gyroscope_window.dart';
import 'package:mobile/state/configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      ChangeNotifierProxyProvider2<ConfigurationState, AccelerometerState,
              AccelerometerWindowState>(
          create: (_) => AccelerometerWindowState(),
          update: (_, config, state, windowState) {
            windowState ??= AccelerometerWindowState();
            windowState.updateConfiguration(config.configurationData);
            windowState.append(state.record);
            return windowState;
          }),
      ChangeNotifierProxyProvider2<ConfigurationState, GyroscopeState,
              GyroscopeWindowState>(
          create: (_) => GyroscopeWindowState(),
          update: (_, config, state, windowState) {
            windowState ??= GyroscopeWindowState();
            windowState.updateConfiguration(config.configurationData);
            windowState.append(state.record);
            return windowState;
          }),
      ChangeNotifierProxyProvider<ConfigurationState, ChartState>(
        create: (_) => ChartState(),
        update: (_, ConfigurationState value, ChartState? previous) {
          previous ??= ChartState();
          previous.updateConfiguration(value.configurationData);
          return previous;
        },
      ),
      // Sensor Translation
      ChangeNotifierProxyProvider4<ConfigurationState, AccelerometerState,
          GyroscopeState, GpsState, SensorTransmitter>(
        create: (_) => SensorTransmitter(),
        update: (_, config, accelerometerState, gyroscopeState, gpsState,
            transmitter) {
          transmitter ??= SensorTransmitter();
          transmitter.updateConfiguration(config.configurationData);
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

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initializeNotifications(flutterLocalNotificationsPlugin);
    GetIt.I.registerSingleton(flutterLocalNotificationsPlugin);

    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);

    final sharedPreferences = await SharedPreferences.getInstance();
    GetIt.I.registerSingleton(sharedPreferences);

    final configurationGateway = ConfigurationGatewayImpl(sharedPreferences);
    GetIt.I.registerSingleton(configurationGateway);

    final dataDirectory = await createDirectory('data');

    final sensorsLocalGateway =
        SensorsLocalGatewayImpl(directoryPath: dataDirectory.path);
    GetIt.I.registerSingleton(sensorsLocalGateway);

    final sensorsNetworkGateway = SensorsNetworkGatewayImpl();
    GetIt.I.registerSingleton(sensorsNetworkGateway);

    final notificationsGateway =
        NotificationsGatewayImpl(plugin: flutterLocalNotificationsPlugin);
    GetIt.I.registerSingleton(notificationsGateway);

    // permissions
    await grantNotificationPermissions(flutterLocalNotificationsPlugin);
    await grantGeolocationPermission();

    runApp(const App());
  }, (e, st) {
    GetIt.I<Talker>().handle(e, st);
  });
}

Future<bool?> initializeNotifications(
    FlutterLocalNotificationsPlugin notificationsPlugin) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iOSInitialize =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iOSInitialize);
  return notificationsPlugin.initialize(initializationSettings);
}

Future<void> grantNotificationPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  bool granted = false;

  if (Platform.isAndroid) {
    granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  if (!granted) {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }
}

Future<void> grantGeolocationPermission() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      const error = 'Location permissions are denied';
      showNotification(title: 'Geolocation', body: error);
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    const error =
        'Location permissions are permanently denied, we cannot request permissions.';
    showNotification(title: 'Geolocation', body: error);
    return;
  }
}
