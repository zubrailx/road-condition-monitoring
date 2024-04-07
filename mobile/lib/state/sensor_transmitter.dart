import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/features/sensor_transmission.dart';

class SensorTransmitter extends ChangeNotifier {
  late Duration _duration;
  late bool _networkEnabled;
  late String _networkReceiverURL;
  late UserAccountData _accountData;

  late List<AccelerometerData> _accelerometerRecords;
  late List<GyroscopeData> _gyroscopeRecords;
  late List<GpsData> _gpsRecords;

  DateTime? _lastUpdate;

  SensorTransmitter() {
    var config = ConfigurationData.create();
    _duration = Duration(seconds: config.networkBufferTimeSeconds);
    _networkEnabled = config.networkEnabled;
    _networkReceiverURL = config.networkReceiverURL;
    _accountData = config.userAccountData;
    _reset();
  }

  _reset() {
    _accelerometerRecords = [];
    _gyroscopeRecords = [];
    _gpsRecords = [];
  }

  _transmit() {
    transmitSensorRecords(_accelerometerRecords, _gyroscopeRecords, _gpsRecords,
        _networkEnabled, _networkReceiverURL, _accountData);
  }

  void appendAccelerometer(AccelerometerData record) {
    if (_accelerometerRecords.isNotEmpty &&
        record == _accelerometerRecords.last) {
      return;
    }
    _accelerometerRecords.add(record);
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
    if (record.time != null) {
      if (_lastUpdate == null ||
          record.time!.difference(_lastUpdate!) > _duration) {
        _transmit();
        _reset();
        _lastUpdate = record.time;
        _gpsRecords.add(record); // append last record as a first entry to new list
      }
    }
  }

  void updateConfiguration(ConfigurationData? data) {
    if (data != null) {
      if (_duration.inSeconds != data.networkBufferTimeSeconds) {
        _duration = Duration(seconds: data.networkBufferTimeSeconds);
      }
      if (_networkReceiverURL != data.networkReceiverURL) {
        _networkReceiverURL = data.networkReceiverURL;
      }
      if (_accountData != data.userAccountData) {
        _accountData = data.userAccountData;
      }
      if (_networkEnabled != data.networkEnabled) {
        _networkEnabled = data.networkEnabled;
        if (_networkEnabled) {
          transmitLocalSensorRecords(_networkReceiverURL, _accountData);
        }
      }
    }
  }
}
