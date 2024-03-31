import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/gateway/abstract/sensors_local.dart';
import 'package:mobile/gateway/sensors_local_impl.dart';

/*
 If network is enabled -> try send data to receiver. If error -> store records locally
 If network is disabled -> store records locally
 */
transmitSensorRecords(
  List<AccelerometerData> accelerometerRecords,
  List<GyroscopeData> gyroscopeRecords,
  List<GpsData> gpsRecords,
  bool networkEnabled,
  String networkReceiverUrl,
  UserAccountData accountData,
) {
  var data = SensorsLocalData(
      accelerometerData: accelerometerRecords,
      gyroscopeData: gyroscopeRecords,
      gpsData: gpsRecords);
  GetIt.I<SensorsLocalGatewayImpl>().storeToEnd(data);
}

transmitLocalSensorRecords(
    String networkReceiverUrl, UserAccountData accountData) {}
