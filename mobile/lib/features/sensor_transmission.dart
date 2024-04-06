import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/features/notifications.dart';
import 'package:mobile/gateway/abstract/sensors_local.dart';
import 'package:mobile/gateway/sensors_local_impl.dart';
import 'package:mobile/gateway/sensors_network_impl.dart';
import 'package:talker_flutter/talker_flutter.dart';

const _maxCount = 50;
/*
 If network is enabled -> try send data to receiver. If error -> store records locally
 If network is disabled -> store records locally
 */
Future<bool> transmitSensorRecords(
  List<AccelerometerData> accelerometerRecords,
  List<GyroscopeData> gyroscopeRecords,
  List<GpsData> gpsRecords,
  bool networkEnabled,
  String networkReceiverUrl,
  UserAccountData accountData,
) {
  if (networkEnabled) {
    return GetIt.I<SensorsNetworkGatewayImpl>()
        .send(networkReceiverUrl, accountData, accelerometerRecords,
            gyroscopeRecords, gpsRecords)
        .then((res) {
      if (!res) {
        throw 'Network error, returned false.';
      }
      return res;
    }).onError((e, s) {
      GetIt.I<Talker>().warning(e);
      return _storeDataLocally(
          accelerometerRecords, gyroscopeRecords, gpsRecords);
    });
  } else {
    return _storeDataLocally(
        accelerometerRecords, gyroscopeRecords, gpsRecords);
  }
}

transmitLocalSensorRecords(
    String networkReceiverUrl, UserAccountData accountData) async {

  if (networkReceiverUrl == "") {
    return;
  }

  bool doContinue = true;
  bool hasError = false;

  while (doContinue) {
    int counter = 0;

    await for (final data in GetIt.I<SensorsLocalGatewayImpl>()
        .loadFromBegin(maxCount: _maxCount)) {
      final res = await GetIt.I<SensorsNetworkGatewayImpl>().send(
          networkReceiverUrl, accountData,
          data.accelerometerData, data.gyroscopeData, data.gpsData);
      if (!res) {
        hasError = true;
        break;
      }
      counter++;
    }
    if (hasError) {
      GetIt.I<SensorsLocalGatewayImpl>().nAckFromBegin(counter);
      showNotification(title: "Network", body: "Error while sending data to server. Double click network button to retry.");
    } else {
      GetIt.I<SensorsLocalGatewayImpl>().ackFromBegin(counter);
    }
    doContinue = (counter != 0 && !hasError);
  }
}

Future<bool> _storeDataLocally(
  List<AccelerometerData> accelerometerRecords,
  List<GyroscopeData> gyroscopeRecords,
  List<GpsData> gpsRecords,
) {
  var data = SensorsLocalData(
      accelerometerData: accelerometerRecords,
      gyroscopeData: gyroscopeRecords,
      gpsData: gpsRecords);

  return GetIt.I<SensorsLocalGatewayImpl>().storeToEnd(data);
}
