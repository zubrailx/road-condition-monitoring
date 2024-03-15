import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/pages/root_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoadCondition',
      theme: darkTheme,
      routes: {
        '/': (context) => RootPage(),
      },
    );
  }

}
