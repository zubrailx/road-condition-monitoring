import 'dart:convert';

import 'package:mobile/entities/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys {
  configuration('configuration');

  const SharedPrefKeys(this.k);

  final String k;
}

class SharedPrefGateway {
  SharedPrefGateway(this._prefs);

  static Future<SharedPrefGateway> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefGateway(prefs);
  }

  final SharedPreferences _prefs;

  Future<ConfigurationData?> getConfiguration() async {
    final data = _prefs.getString(SharedPrefKeys.configuration.k);
    return data != null ? ConfigurationData.fromJson(jsonDecode(data)) : null;
  }

  Future<bool> setConfiguration(ConfigurationData configuration) async {
    final data = jsonEncode(configuration);
    return _prefs.setString(SharedPrefKeys.configuration.k, data);
  }
}
