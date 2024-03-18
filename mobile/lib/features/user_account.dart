import 'package:get_it/get_it.dart';
import 'package:mobile/entities/user_account.dart';
import 'package:mobile/gateway/shared_preferences.dart';

Future<bool> saveUserAccount(UserAccountData account) {
  return GetIt.I<SharedPrefGateway>().setUserAccount(account);
}

Future<UserAccountData?> getUserAccount() {
  return GetIt.I<SharedPrefGateway>().getUserAccount();
}
