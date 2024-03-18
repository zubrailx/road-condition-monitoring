import 'dart:async';

import 'package:flutter/foundation.dart';

class ChartState with ChangeNotifier {
  late final Timer? _timer;
  int _counter = 0;
  final int _tickDuration = 1000;

  ChartState() {
    _timer = Timer.periodic(Duration(milliseconds: _tickDuration), (Timer t) => (_signal()));
  }

  int get counter => _counter;

  _signal() {
    ++_counter;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
