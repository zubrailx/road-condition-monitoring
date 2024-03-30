import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/gateway/shared_preferences.dart';

Future<bool> saveConfiguration(ConfigurationData configuration) async {
  return GetIt.I<SharedPrefGateway>().setConfiguration(configuration);
}

Future<ConfigurationData> getConfiguration() async {
  var data = await GetIt.I<SharedPrefGateway>().getConfiguration();
  return data ?? ConfigurationData.create();
}
