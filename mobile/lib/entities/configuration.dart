class ConfigurationData {
  bool gyroscopeChartEnabled;
  bool accelerometerChartEnabled;
  bool networkEnabled;
  bool sensorsEnabled;
  String apiURL;
  String receiverURL; // receiver of sensor data
  UserAccountData userAccountData;

  ConfigurationData(
      {required this.gyroscopeChartEnabled,
      required this.accelerometerChartEnabled,
      required this.networkEnabled,
      required this.sensorsEnabled,
      required this.apiURL,
      required this.receiverURL,
      required this.userAccountData});

  Map<String, dynamic> toJson() {
    return {
      'gyroscope_enabled': gyroscopeChartEnabled,
      'accelerometer_enabled': accelerometerChartEnabled,
      'network_enabled': networkEnabled,
      'sensors_enabled': sensorsEnabled,
      'api_url': apiURL,
      'receiver_url': receiverURL,
      'user_account': userAccountData.toJson()
    };
  }

  factory ConfigurationData.fromJson(Map<String, dynamic> json) {
    return ConfigurationData(
        gyroscopeChartEnabled: json['gyroscope_enabled'],
        accelerometerChartEnabled: json['accelerometer_enabled'],
        networkEnabled: json['network_enabled'],
        sensorsEnabled: json['sensors_enabled'],
        apiURL: json['api_url'],
        receiverURL: json['receiver_url'],
        userAccountData: UserAccountData.fromJson(json['user_account']));
  }

  factory ConfigurationData.create() {
    return ConfigurationData(
        gyroscopeChartEnabled: true,
        accelerometerChartEnabled: true,
        networkEnabled: true,
        sensorsEnabled: true,
        apiURL: 'localhost:9000',
        receiverURL: 'localhost:9100',
        userAccountData: UserAccountData.create());
  }
}

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
