class PointResponse {
  final DateTime time;
  final double latitude;
  final double longitude;
  final double prediction;

  PointResponse(
      {required this.time,
      required this.latitude,
      required this.longitude,
      required this.prediction});

  @override
  String toString() => 'LocationMarkerPosition('
      'time: $time, '
      'latitude: $latitude, '
      'longitude: $longitude, '
      'prediction: $prediction)';

  factory PointResponse.fromJson(Map<String, dynamic> json) {
    return PointResponse(
      time: DateTime.parse(json['time']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      prediction: json['prediction'],
    );
  }
}
