import 'package:get_it/get_it.dart';
import 'package:mobile/entities/user_account.dart';
import 'package:mobile/gateway/shared_preferences.dart';

Future<bool> saveUserAccount(UserAccount account) {
  return GetIt.I<SharedPrefGateway>().setUserAccount(account);
}
Future<UserAccount?> getUserAccount() {
  return GetIt.I<SharedPrefGateway>().getUserAccount();
}
