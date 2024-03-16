import 'dart:convert';

import 'package:mobile/entities/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys {
  userAccount('user_account');

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

  Future<UserAccount?> getUserAccount() async {
    final data = _prefs.getString(SharedPrefKeys.userAccount.k);
    return data != null ? UserAccount.fromJson(jsonDecode(data)) : null;
  }

  Future<bool> setUserAccount(UserAccount account) async {
    final data = jsonEncode(account);
    return _prefs.setString(SharedPrefKeys.userAccount.k, data);
  }
}

