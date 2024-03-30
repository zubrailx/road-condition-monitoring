import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/state/configuration.dart';
import 'package:provider/provider.dart';

class SensorSwitchWidget extends StatelessWidget {
  const SensorSwitchWidget({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    var configuration = context.watch<ConfigurationState>();
    var isEnabled = configuration.configurationData?.sensorsEnabled ?? true;
    return IconButton(
        icon: isEnabled
            ? SvgPicture.asset("assets/svg/Play.svg", width: width)
            : SvgPicture.asset("assets/svg/Pause.svg", width: width),
        onPressed: () {
          configuration.setSensorsEnabled(!isEnabled);
        });
  }
}
