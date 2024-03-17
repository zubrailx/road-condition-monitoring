class GyroscopeRecord {
  const GyroscopeRecord(
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
}
