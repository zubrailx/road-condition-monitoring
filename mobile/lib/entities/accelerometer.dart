class AccelerometerData {
  const AccelerometerData(
      {required this.time,
      required this.x,
      required this.y,
      required this.z,
      required this.ms});

  final DateTime? time;
  final double? x;
  final double? y;
  final double? z;
  final int? ms;

  Map<String, dynamic> toJson() {
    return {
      'time': time?.toIso8601String(),
      'x': x,
      'y': y,
      'z': z,
      'ms': ms,
    };
  }

  factory AccelerometerData.fromJson(Map<String, dynamic> json) {
    return AccelerometerData(
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      x: json['x'],
      y: json['y'],
      z: json['z'],
      ms: json['ms'],
    );
  }
}
