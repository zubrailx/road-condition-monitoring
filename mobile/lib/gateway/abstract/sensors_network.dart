import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';

abstract class SensorsNetworkGateway {
  Future<bool> send(
    String receiverURL,
    UserAccountData account,
    List<AccelerometerData> accelerometerData,
    List<GyroscopeData> gyroscopeData,
    List<GpsData> gpsData,
  );
}
