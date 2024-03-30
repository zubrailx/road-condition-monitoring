import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/gateway/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<bool> saveConfiguration(ConfigurationData configuration) async {
  return GetIt.I<SharedPrefGateway>().setConfiguration(configuration);
}

Future<ConfigurationData> getConfiguration() async {
  var data =
      await GetIt.I<SharedPrefGateway>().getConfiguration().catchError((e) {
    GetIt.I<Talker>().warning(e.toString());
    var configuration = ConfigurationData.create();
    saveConfiguration(configuration);
    return configuration;
  });
  return data ?? ConfigurationData.create();
}
