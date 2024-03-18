import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mobile/entities/accelerometer.dart';

class AccelerometerHistoryState with ChangeNotifier {
  late final int maxLength;
  late final ListQueue<AccelerometerData> _records;

  AccelerometerHistoryState() {
    maxLength = 10000;
    _records = ListQueue(maxLength);
  }

  get records => _records;

  void append(AccelerometerData record) {
    if (_records.length == maxLength) {
      _records.removeFirst();
    }
    _records.add(record);
  }
}
