import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/state/gps.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:mobile/state/user_accelerometer.dart';
import 'package:provider/provider.dart';

class SensorSwitchWidget extends StatefulWidget {
  const SensorSwitchWidget({super.key, required this.width});

  final double width;

  @override
  State createState() {
    return _SensorSwitchWidgetState();
  }
}

class _SensorSwitchWidgetState extends State<SensorSwitchWidget> {
  bool isPaused = false;

  _pause(UserAccelerometerState accelModel, GyroscopeState gyroModel,
      GpsState gpsModel) {
    accelModel.pause();
    gyroModel.pause();
    gpsModel.pause();
  }

  _resume(UserAccelerometerState accelModel, GyroscopeState gyroModel,
      GpsState gpsModel) {
    accelModel.resume();
    gyroModel.resume();
    gpsModel.resume();
  }

  @override
  Widget build(BuildContext context) {
    final accelModel = context.read<UserAccelerometerState>();
    final gyroModel = context.read<GyroscopeState>();
    final gpsModel = context.read<GpsState>();

    return IconButton(
        icon: isPaused
            ? SvgPicture.asset("assets/svg/Pause.svg", width: widget.width)
            : SvgPicture.asset("assets/svg/Play.svg", width: widget.width),
        onPressed: () {
          if (isPaused) {
            _resume(accelModel, gyroModel, gpsModel);
          } else {
            _pause(accelModel, gyroModel, gpsModel);
          }
          setState(() {
            isPaused = !isPaused;
          });
        });
  }
}
