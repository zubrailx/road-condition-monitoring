import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SensorTransmitter extends ChangeNotifier {
  late final Duration _duration;
  late List<AccelerometerData> _accelerometerRecords;
  late List<GyroscopeData> _gyroscopeRecords;
  late List<GpsData> _gpsRecords;

  DateTime? _lastUpdate;

  SensorTransmitter() {
    _duration = const Duration(seconds: 30);
    _reset();
  }

  _reset() {
    _accelerometerRecords = [];
    _gyroscopeRecords = [];
    _gpsRecords = [];
  }

  void appendAccelerometer(AccelerometerData record) {
    if (_accelerometerRecords.isNotEmpty &&
        record == _accelerometerRecords.last) {
      return;
    }
    _accelerometerRecords.add(record);
    GetIt.I<Talker>().info(
        '${_accelerometerRecords.length},${_gyroscopeRecords.length},${_gpsRecords.length}');
  }

  void appendGyroscope(GyroscopeData record) {
    if (_gyroscopeRecords.isNotEmpty && record == _gyroscopeRecords.last) {
      return;
    }
    _gyroscopeRecords.add(record);
  }

  // trigger send by gps update
  // if not enabled -> no data input -> no translation
  void appendGps(GpsData record) {
    if (_gpsRecords.isNotEmpty && record == _gpsRecords.last) {
      return;
    }
    _gpsRecords.add(record);
    if (_lastUpdate != null && record.time != null) {
      if (record.time!.difference(_lastUpdate!) > _duration) {
        // send data
        GetIt.I<Talker>().info('translate', _gpsRecords);
        _reset();
      }
    }
  }
}
