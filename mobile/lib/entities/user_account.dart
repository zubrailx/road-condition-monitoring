class UserAccount {
  const UserAccount({required this.accountId});

  final String accountId;

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(accountId: json['account_id']);
  }
}
