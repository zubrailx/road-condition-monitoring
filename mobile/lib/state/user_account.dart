import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/user_account.dart';
import 'package:mobile/features/user_account.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserAccountState with ChangeNotifier {
  UserAccountData _userAccount = const UserAccountData(accountId: "", name: "");
  bool _saved = false;

  UserAccountState() {
    _init();
  }

  void _init() async {
    _userAccount = await getUserAccount() ?? _userAccount;
    GetIt.I<Talker>().info("User account loaded.");
    notifyListeners();
  }

  UserAccountData get userAccount => _userAccount;
  bool get saved => _saved;

  set userAccount(UserAccountData userAccount) {
    _userAccount = userAccount;
    _saved = false;
    notifyListeners();
    (() async {
      _saved = await saveUserAccount(_userAccount);
      if (_saved) {
        GetIt.I<Talker>().info("User account saved.");
      } else {
        GetIt.I<Talker>().error("User account is not saved.");
      }
      notifyListeners();
    })();
  }
}
