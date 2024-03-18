class UserAccountData {
  const UserAccountData({required this.accountId, required this.name});

  final String accountId;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'name': name,
    };
  }

  factory UserAccountData.fromJson(Map<String, dynamic> json) {
    return UserAccountData(accountId: json['account_id'], name: json['name']);
  }
}
