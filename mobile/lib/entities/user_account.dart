class UserAccount {
  const UserAccount({required this.accountId, required this.name});

  final String accountId;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'name': name,
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(accountId: json['account_id'], name: json['name']);
  }
}
