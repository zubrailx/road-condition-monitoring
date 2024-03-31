class GpsData {
  const GpsData(
      {required this.time,
      required this.latitude,
      required this.longitude,
      required this.accuracy,
      required this.ms});

  final DateTime? time;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final int? ms;

  Map<String, dynamic> toJson() {
    return {
      'time': time?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'ms': ms,
    };
  }

  factory GpsData.fromJson(Map<String, dynamic> json) {
    return GpsData(
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
      accuracy: json['accuracy'],
      ms: json['ms'],
    );
  }
}
