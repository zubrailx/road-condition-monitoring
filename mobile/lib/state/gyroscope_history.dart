import 'package:flutter/foundation.dart';
import 'package:mobile/entities/gyroscope.dart';

class GyroscopeHistoryState with ChangeNotifier {
  late final int maxLength;
  late final List<GyroscopeData> _records;

  GyroscopeHistoryState() {
    maxLength = 100;
    _records = <GyroscopeData>[];
  }

  List<GyroscopeData> get records => _records;

  void append(GyroscopeData record) {
    if (_records.length == maxLength) {
      _records.removeAt(0);
    }
    _records.add(record);
  }
}
