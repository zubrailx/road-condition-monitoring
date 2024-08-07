class ConfigurationData {
  bool chartGyroscopeEnabled;
  bool chartAccelerometerEnabled;
  bool chartGpsEnabled;
  int chartWindowTimeSeconds;
  int chartRefreshTimeMillis;
  bool networkEnabled;
  String networkApiURL;
  String networkReceiverURL; // receiver of sensor data
  int networkBufferTimeSeconds;
  bool sensorsEnabled;
  int gpsDistanceFilter;
  UserAccountData userAccountData;
  bool mapPointsBorderEnabled;
  double mapPointsSize;
  bool mapLocationEnabled;

  ConfigurationData({
    required this.chartGyroscopeEnabled,
    required this.chartAccelerometerEnabled,
    required this.chartGpsEnabled,
    required this.chartWindowTimeSeconds,
    required this.chartRefreshTimeMillis,
    required this.networkEnabled,
    required this.networkApiURL,
    required this.networkReceiverURL,
    required this.networkBufferTimeSeconds,
    required this.sensorsEnabled,
    required this.gpsDistanceFilter,
    required this.userAccountData,
    required this.mapPointsBorderEnabled,
    required this.mapPointsSize,
    required this.mapLocationEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'chart_gyroscope_enabled': chartGyroscopeEnabled,
      'chart_accelerometer_enabled': chartAccelerometerEnabled,
      'chart_gps_enabled': chartGpsEnabled,
      'chart_window_time_seconds': chartWindowTimeSeconds,
      'chart_refresh_time_millis': chartRefreshTimeMillis,
      'network_enabled': networkEnabled,
      'network_api_url': networkApiURL,
      'network_receiver_url': networkReceiverURL,
      'network_buffer_time_seconds': networkBufferTimeSeconds,
      'sensors_enabled': sensorsEnabled,
      'gps_distance_filter': gpsDistanceFilter,
      'user_account': userAccountData.toJson(),
      'map_points_border_enabled': mapPointsBorderEnabled,
      'map_points_size': mapPointsSize,
      'map_location_enabled': mapLocationEnabled,
    };
  }

  factory ConfigurationData.fromJson(Map<String, dynamic> json) {
    return ConfigurationData(
        chartGyroscopeEnabled: json['chart_gyroscope_enabled'],
        chartAccelerometerEnabled: json['chart_accelerometer_enabled'],
        chartGpsEnabled: json['chart_gps_enabled'],
        chartWindowTimeSeconds: json['chart_window_time_seconds'],
        chartRefreshTimeMillis: json['chart_refresh_time_millis'],
        networkEnabled: json['network_enabled'],
        networkApiURL: json['network_api_url'],
        networkReceiverURL: json['network_receiver_url'],
        networkBufferTimeSeconds: json['network_buffer_time_seconds'],
        sensorsEnabled: json['sensors_enabled'],
        gpsDistanceFilter: json['gps_distance_filter'],
        userAccountData: UserAccountData.fromJson(json['user_account']),
        mapPointsBorderEnabled: json['map_points_border_enabled'],
        mapPointsSize: json['map_points_size'],
        mapLocationEnabled: json['map_location_enabled']);
  }

  factory ConfigurationData.create() {
    return ConfigurationData(
      chartGyroscopeEnabled: false,
      chartAccelerometerEnabled: false,
      chartGpsEnabled: false,
      chartWindowTimeSeconds: 30,
      chartRefreshTimeMillis: 1000,
      networkEnabled: false,
      networkApiURL: 'localhost:9000',
      networkReceiverURL: 'localhost:1883',
      networkBufferTimeSeconds: 30,
      sensorsEnabled: true,
      gpsDistanceFilter: 50,
      userAccountData: UserAccountData.create(),
      mapPointsBorderEnabled: true,
      mapPointsSize: 10,
      mapLocationEnabled: true,
    );
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
