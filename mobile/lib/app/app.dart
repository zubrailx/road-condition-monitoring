import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/route.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/gateway/shared_preferences.dart';
import 'package:mobile/pages/logs_page.dart';
import 'package:mobile/pages/root_page.dart';
import 'package:mobile/state/chart.dart';
import 'package:mobile/state/gps.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:mobile/state/gyroscope_buffer.dart';
import 'package:mobile/state/accelerometer.dart';
import 'package:mobile/state/accelerometer_buffer.dart';
import 'package:mobile/state/user_account.dart';
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
      ChangeNotifierProvider(create: (_) => UserAccountState()),
      ChangeNotifierProvider(create: (_) => GpsState()),
      ChangeNotifierProvider(create: (_) => UserAccelerometerState()),
      ChangeNotifierProvider(create: (_) => GyroscopeState()),
      ChangeNotifierProxyProvider<UserAccelerometerState,
              AccelerometerBufferState>(
          create: (_) => AccelerometerBufferState(),
          update: (_, model, historyModel) {
            historyModel ??= AccelerometerBufferState();
            historyModel.append(model.record);
            return historyModel;
          },
          lazy: false),
      ChangeNotifierProxyProvider<GyroscopeState, GyroscopeBufferState>(
          create: (_) => GyroscopeBufferState(),
          update: (_, model, historyModel) {
            historyModel ??= GyroscopeBufferState();
            historyModel.append(model.record);
            return historyModel;
          },
          lazy: false),
      ChangeNotifierProvider(create: (_) => ChartState()),
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

    WidgetsFlutterBinding.ensureInitialized();
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
