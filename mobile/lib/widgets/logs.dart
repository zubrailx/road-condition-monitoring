import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/app/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LogsWidget extends StatelessWidget {
  const LogsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      theme: talkerScreenTheme,
      talker: GetIt.I<Talker>(),
      appBarTitle: 'Logs',
    );
  }
}
