import 'package:flutter/foundation.dart';
import 'package:mobile/entities/accelerometer.dart';

class AccelerometerWindowState with ChangeNotifier {
  late final Duration _duration;
  late final List<AccelerometerData> _records;

  AccelerometerWindowState() {
    _duration = const Duration(seconds: 30);
    _records = <AccelerometerData>[];
  }

  List<AccelerometerData> get records => _records;

  void append(AccelerometerData record) {
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
