import 'package:flutter/material.dart';

class DebugWidget extends StatefulWidget {
  const DebugWidget({super.key});

  @override
  State<StatefulWidget> createState() => _DebugWidgetState();

}

class _DebugWidgetState extends State<DebugWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("Debug Widget");
  }

}
