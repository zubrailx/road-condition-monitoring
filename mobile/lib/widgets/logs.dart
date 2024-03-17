import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> {
  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      theme: talkerScreenTheme,
      talker: GetIt.I<Talker>(),
      appBarTitle: 'Logs',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
