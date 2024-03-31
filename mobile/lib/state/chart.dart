import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile/entities/configuration.dart';

class ChartState with ChangeNotifier {
  late Timer _timer;
  int _counter = 0;
  int _refreshTimeMillis = ConfigurationData.create().chartRefreshTimeMillis;

  ChartState() {
    _subscribe();
  }

  int get counter => _counter;

  _subscribe() {
    _timer = Timer.periodic(Duration(milliseconds: _refreshTimeMillis), (Timer t) => (_signal()));
  }

  updateConfiguration(ConfigurationData? data) {
    if (data != null && _refreshTimeMillis != data.chartRefreshTimeMillis) {
      _refreshTimeMillis = data.chartRefreshTimeMillis;
      _timer.cancel();
      _subscribe();
    }
  }

  _signal() {
    ++_counter;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
