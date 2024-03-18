import 'package:flutter/foundation.dart';
import 'package:mobile/entities/accelerometer.dart';

class AccelerometerHistoryState with ChangeNotifier {
  late final int maxLength;
  late final List<AccelerometerData> _records;

  AccelerometerHistoryState() {
    maxLength = 250;
    _records = <AccelerometerData>[];
  }

  List<AccelerometerData> get records => _records;

  void append(AccelerometerData record) {
    if (_records.length == maxLength) {
      _records.removeAt(0);
    }
    _records.add(record);
  }
}
