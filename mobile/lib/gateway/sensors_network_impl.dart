import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/entities/gps.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/gateway/abstract/sensors_network.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SensorsNetworkGatewayImpl implements SensorsNetworkGateway {
  MqttClient? _client;
  String _monitoringTopic = "monitoring";

  void _onSubscribed(String topic) {
    GetIt.I<Talker>().debug('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void _onDisconnected() {
    GetIt.I<Talker>().debug('EXAMPLE::OnDisconnected - Client disconnection');
    if (_client?.connectionStatus?.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      GetIt.I<Talker>()
          .debug('EXAMPLE::OnDisconnected is solicited, this is correct');
    } else {
      GetIt.I<Talker>().debug('EXAMPLE::OnDisconnected is unsolicited or none');
    }
  }

  void _onConnected() {
    GetIt.I<Talker>().debug(
        'EXAMPLE::OnConnected client - Client connection was successful');
  }

  void _pongCallback() {
    GetIt.I<Talker>().debug('EXAMPLE::Ping response client callback invoked');
  }

  MqttClient _buildClient(String receiverURL, UserAccountData account) {
    MqttClient client = MqttClient(receiverURL, account.accountId);
    client.logging(on: true);
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
    _client!.disconnect();
    _client = null;
  }

  Future<MqttClient?> _getConnectedClient(
      String receiverURL, UserAccountData account) async {
    if (_client != null && (_client?.clientIdentifier != account.accountId || _client?.server != receiverURL)) {
      _disconnect();
    }

    if (_client == null) {
      _client = _buildClient(receiverURL, account);
      try {
        await _client!.connect();
      } on NoConnectionException catch (e) {
        GetIt.I<Talker>().warning('EXAMPLE::client exception - $e');
        _disconnect();
        return null;
      } on SocketException catch (e) {
        GetIt.I<Talker>().warning('EXAMPLE::socket exception - $e');
        _disconnect();
        return null;
      }
    }

    if (_client!.connectionStatus!.state != MqttConnectionState.connected) {
      GetIt.I<Talker>().warning(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client!.connectionStatus}');
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

    if  (client.getSubscriptionsStatus(_monitoringTopic) == MqttSubscriptionStatus.doesNotExist) {
      client.subscribe(_monitoringTopic, MqttQos.atMostOnce);
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(account));
    client.publishMessage(_monitoringTopic, MqttQos.atMostOnce, builder.payload!);
    return true;
  }
}
