import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/gateway/configuration_impl.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<bool> saveConfiguration(ConfigurationData configuration) async {
  return GetIt.I<ConfigurationGatewayImpl>().setConfiguration(configuration);
}

Future<ConfigurationData> getConfiguration() async {
  var data = await GetIt.I<ConfigurationGatewayImpl>()
      .getConfiguration()
      .catchError((e) {
    GetIt.I<Talker>().warning(e.toString());
    var configuration = ConfigurationData.create();
    saveConfiguration(configuration);
    return configuration;
  });
  return data ?? ConfigurationData.create();
}
