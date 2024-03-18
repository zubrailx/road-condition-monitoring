import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mobile/entities/gyroscope.dart';

class GyroscopeHistoryState with ChangeNotifier {
  late final int maxLength;
  late final ListQueue<GyroscopeRecord> _records;

  GyroscopeHistoryState() {
   maxLength = 10000;
   _records = ListQueue(maxLength);
  }

  get records => _records;

  void append(GyroscopeRecord record) {
    if (_records.length == maxLength) {
      _records.removeFirst();
    }
    _records.add(record);
  }
}
