import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';

class SensorsLocalData {
  final List<AccelerometerData> accelerometerData;
  final List<GyroscopeData> gyroscopeData;
  final List<GpsData> gpsData;

  const SensorsLocalData(
      {required this.accelerometerData,
      required this.gyroscopeData,
      required this.gpsData});

  Map<String, dynamic> toJson() {
    return {
      'accelerometerData':
          accelerometerData.map((data) => data.toJson()).toList(),
      'gyroscopeData': gyroscopeData.map((data) => data.toJson()).toList(),
      'gpsData': gpsData.map((data) => data.toJson()).toList(),
    };
  }

  factory SensorsLocalData.fromJson(Map<String, dynamic> json) {
    return SensorsLocalData(
      accelerometerData: (json['accelerometerData'] as List<dynamic>)
          .map((dataJson) => AccelerometerData.fromJson(dataJson))
          .toList(),
      gyroscopeData: (json['gyroscopeData'] as List<dynamic>)
          .map((dataJson) => GyroscopeData.fromJson(dataJson))
          .toList(),
      gpsData: (json['gpsData'] as List<dynamic>)
          .map((dataJson) => GpsData.fromJson(dataJson))
          .toList(),
    );
  }
}

abstract class SensorsLocalGateway {
  Future<bool> storeToEnd(SensorsLocalData data);

  Stream<SensorsLocalData> loadFromBegin({int? maxCount = -1});

  Future<bool> ackFromBegin(int count);

  Future<bool> nAckFromBegin(int count); // first nack
}
