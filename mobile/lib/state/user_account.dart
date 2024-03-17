import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/user_account.dart';
import 'package:mobile/features/user_account.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserAccountModel with ChangeNotifier {
  UserAccount _userAccount = const UserAccount(accountId: "", name: "");
  bool _saved = false;

  UserAccountModel() {
    _init();
  }

  void _init() async {
    _userAccount = await getUserAccount() ?? _userAccount;
    GetIt.I<Talker>().info("User account loaded.");
    notifyListeners();
  }

  UserAccount get userAccount => _userAccount;
  bool get saved => _saved;

  set userAccount(UserAccount userAccount) {
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
