import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/gateway/abstract/sensors_network.dart';
import 'package:mobile/shared/model/gen/monitoring/monitoring.pb.dart';
import 'package:mobile/shared/model/gen/util.pb.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:typed_data/typed_data.dart';

class SensorsNetworkGatewayImpl implements SensorsNetworkGateway {
  MqttClient? _client;
  String? _clientURL;
  final String _monitoringTopic = "monitoring";

  void _onSubscribed(String topic) {
    GetIt.I<Talker>().debug('NETWORK: Subscription confirmed for topic $topic');
  }

  void _onDisconnected() {
    GetIt.I<Talker>().debug('NETWORK: OnDisconnected - Client disconnection');
    if (_client?.connectionStatus?.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      GetIt.I<Talker>()
          .debug('NETWORK: OnDisconnected is solicited, this is correct');
    } else {
      GetIt.I<Talker>().debug('NETWORK: OnDisconnected is unsolicited or none');
    }
  }

  void _onConnected() {
    GetIt.I<Talker>().debug(
        'NETWORK: OnConnected client - Client connection was successful');
  }

  void _pongCallback() {
    GetIt.I<Talker>().debug('NETWORK: Ping response client callback invoked');
  }

  MqttClient _buildClient(String receiverURL, UserAccountData account) {
    String host = receiverURL.split(":")[0];
    int port = int.parse(receiverURL.split(":")[1]);
    MqttClient client = MqttServerClient(host, account.accountId);
    client.port = port;
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.connectTimeoutPeriod = 5000;
    client.onSubscribed = _onSubscribed;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.pongCallback = _pongCallback;
    return client;
  }

  _disconnect() {
    if (_client != null) {
      _client!.disconnect();
    }
    _client = null;
    _clientURL = null;
  }

  Future<MqttClient?> _getConnectedClient(
      String receiverURL, UserAccountData account) async {
    if (_client != null &&
        (_client?.clientIdentifier != account.accountId ||
            _clientURL != receiverURL)) {
      _disconnect();
    }

    if (_client == null) {
      _client = _buildClient(receiverURL, account);
      _clientURL = receiverURL;
      try {
        await _client!.connect();
      } on NoConnectionException catch (e) {
        GetIt.I<Talker>().warning('NETWORK: client exception - $e');
        _disconnect();
        return null;
      } on SocketException catch (e) {
        GetIt.I<Talker>().warning('NETWORK: socket exception - $e');
        _disconnect();
        return null;
      }
    }

    if (_client!.connectionStatus!.state != MqttConnectionState.connected) {
      GetIt.I<Talker>().warning(
          'NETWORK: Mosquitto client connection failed - disconnecting, status is ${_client!.connectionStatus}');
      _disconnect();
      return null;
    }

    return _client;
  }

  @override
  Future<bool> send(
      String receiverURL,
      UserAccountData account,
      List<AccelerometerData> accelerometerData,
      List<GyroscopeData> gyroscopeData,
      List<GpsData> gpsData) async {
    final client = await _getConnectedClient(receiverURL, account);
    if (client == null) {
      return false;
    }

    if (client.getSubscriptionsStatus(_monitoringTopic) ==
        MqttSubscriptionStatus.doesNotExist) {
      client.subscribe(_monitoringTopic, MqttQos.atMostOnce);
    }

    final payload =
        _toMonitoring(account, accelerometerData, gyroscopeData, gpsData);

    final builder = MqttClientPayloadBuilder();
    Uint8Buffer dataBuffer = Uint8Buffer();
    dataBuffer.addAll(payload.writeToBuffer());
    builder.addBuffer(dataBuffer);

    client.publishMessage(
        _monitoringTopic, MqttQos.atMostOnce, builder.payload!);
    GetIt.I<Talker>()
        .debug('NETWORK: sent payload (${dataBuffer.length} bytes)');
    return true;
  }

  Monitoring _toMonitoring(
    UserAccountData accountData,
    List<AccelerometerData> accelerometerData,
    List<GyroscopeData> gyroscopeData,
    List<GpsData> gpsData,
  ) {
    final res = Monitoring(
      account:
          UserAccount(accoundId: accountData.accountId, name: accountData.name),
    );

    res.accelerometerRecords.addAll(accelerometerData.map((data) =>
        AccelerometerRecord(
            time: data.time == null ? null : _dateTimeToTimestamp(data.time!),
            x: data.x,
            y: data.y,
            z: data.z,
            ms: data.ms)));

    res.gyroscopeRecords.addAll(gyroscopeData.map((data) => GyroscopeRecord(
        time: data.time == null ? null : _dateTimeToTimestamp(data.time!),
        x: data.x,
        y: data.y,
        z: data.z,
        ms: data.ms)));

    res.gpsRecords.addAll(gpsData.map((data) => GpsRecord(
        time: data.time == null ? null : _dateTimeToTimestamp(data.time!),
        latitude: data.latitude,
        longitude: data.longitude,
        accuracy: data.accuracy,
        ms: data.ms)));

    return res;
  }

  Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp()
      ..seconds = Int64(dateTime.millisecondsSinceEpoch) ~/ 1000
      ..nanos = (dateTime.microsecond % 1000000) * 1000;
  }
}
