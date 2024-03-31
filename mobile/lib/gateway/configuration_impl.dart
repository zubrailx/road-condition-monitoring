import 'dart:convert';

import 'package:mobile/entities/configuration.dart';
import 'package:mobile/gateway/abstract/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys {
  configuration('configuration');

  const SharedPrefKeys(this.k);

  final String k;
}

class ConfigurationGatewayImpl implements ConfigurationGateway {
  ConfigurationGatewayImpl(this._prefs);

  static Future<ConfigurationGatewayImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ConfigurationGatewayImpl(prefs);
  }

  final SharedPreferences _prefs;

  @override
  Future<ConfigurationData?> getConfiguration() async {
    final data = _prefs.getString(SharedPrefKeys.configuration.k);
    return data != null ? ConfigurationData.fromJson(jsonDecode(data)) : null;
  }

  @override
  Future<bool> setConfiguration(ConfigurationData configuration) async {
    final data = jsonEncode(configuration);
    return _prefs.setString(SharedPrefKeys.configuration.k, data);
  }
}
