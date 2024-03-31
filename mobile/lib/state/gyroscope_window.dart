import 'package:flutter/foundation.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gyroscope.dart';

class GyroscopeWindowState with ChangeNotifier {
  late Duration _duration;
  late final List<GyroscopeData> _records;

  GyroscopeWindowState() {
    _duration =
        Duration(seconds: ConfigurationData.create().chartWindowTimeSeconds);
    _records = <GyroscopeData>[];
  }

  List<GyroscopeData> get records => _records;

  updateConfiguration(ConfigurationData? data) {
    if (data != null && _duration.inSeconds != data.chartWindowTimeSeconds) {
      _duration = Duration(seconds: data.chartWindowTimeSeconds);
    }
  }

  void append(GyroscopeData record) {
    var now = DateTime.timestamp();
    int i;
    for (i = 0; i < _records.length; ++i) {
      final elem = _records[i];
      if (elem.time != null && now.difference(elem.time!) <= _duration) {
        break;
      }
    }
    _records.removeRange(0, i);
    _records.add(record);
  }
}
