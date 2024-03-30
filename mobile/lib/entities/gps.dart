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
}
