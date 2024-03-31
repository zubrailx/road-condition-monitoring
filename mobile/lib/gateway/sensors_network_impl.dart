import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/gateway/abstract/sensors_network.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DefNetworkGateway implements SensorsNetworkGateway {
  @override
  Future<bool> send(
      String receiverURL,
      UserAccountData account,
      List<AccelerometerData> accelerometerData,
      List<GyroscopeData> gyroscopeData,
      List<GpsData> gpsData) {
    return Future.delayed(const Duration(milliseconds: 500), () {
      GetIt.I<Talker>().debug('Data send: '
          '$receiverURL,${account.accountId}:'
          '${accelerometerData.length},${gyroscopeData.length},${gpsData.length}');
      return true;
    });
  }
}
