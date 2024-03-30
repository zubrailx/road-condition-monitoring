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

  factory UserAccountData.create() {
    return const UserAccountData(accountId: '', name: '');
  }
}

class ConfigurationData {
  final bool gyroscopeEnabled;
  final bool accelerometerEnabled;
  final String apiURL;
  final String receiverURL; // receiver of sensor data
  UserAccountData userAccountData;

  ConfigurationData(
      {required this.gyroscopeEnabled,
      required this.accelerometerEnabled,
      required this.apiURL,
      required this.receiverURL,
      required this.userAccountData});

  Map<String, dynamic> toJson() {
    return {
      'gyroscope_enabled': gyroscopeEnabled,
      'accelerometer_enabled': accelerometerEnabled,
      'api_url': apiURL,
      'receiver_url': receiverURL,
      'user_account': userAccountData.toJson()
    };
  }

  factory ConfigurationData.fromJson(Map<String, dynamic> json) {
    return ConfigurationData(
        gyroscopeEnabled: json['gyroscope_enabled'],
        accelerometerEnabled: json['accelerometer_enabled'],
        apiURL: json['api_url'],
        receiverURL: json['receiver_url'],
        userAccountData: UserAccountData.fromJson(json['user_account']));
  }

  factory ConfigurationData.create() {
    return ConfigurationData(
        gyroscopeEnabled: true,
        accelerometerEnabled: true,
        apiURL: 'localhost:9000',
        receiverURL: 'localhost:9100',
        userAccountData: UserAccountData.create());
  }
}
