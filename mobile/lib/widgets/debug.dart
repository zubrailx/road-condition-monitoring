import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DebugWidget extends StatefulWidget {
  const DebugWidget({super.key});

  @override
  State<StatefulWidget> createState() => _DebugWidgetState();

}

class _DebugWidgetState extends State<DebugWidget> {
  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      talker: GetIt.I<Talker>(),
      appBarTitle: 'Logs',
    );
  }

}
