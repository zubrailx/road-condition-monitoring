import 'package:flutter/foundation.dart';
import 'package:mobile/entities/user_account.dart';
import 'package:mobile/features/user_account.dart';

class UserAccountModel with ChangeNotifier {
  UserAccount _userAccount;
  bool _saved;

  UserAccountModel() :
        _userAccount = const UserAccount(accountId: "", name: ""),
        _saved = false
  {
    init();
  }

  void init() async {
    _userAccount = await getUserAccount() ?? _userAccount;
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
      notifyListeners();
    })();
  }
}
