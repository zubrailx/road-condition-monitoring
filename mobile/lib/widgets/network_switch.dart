import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/state/configuration.dart';
import 'package:provider/provider.dart';

class NetworkSwitchWidget extends StatelessWidget {
  const NetworkSwitchWidget({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    var configuration = context.watch<ConfigurationState>();
    var isEnabled = configuration.configurationData?.networkEnabled ?? true;
    return IconButton(
        icon: isEnabled
            ? SvgPicture.asset("assets/svg/NetworkUpload.svg", width: width)
            : SvgPicture.asset("assets/svg/NetworkClose.svg", width: width),
        onPressed: () {
          configuration.setNetworkEnabled(!isEnabled);
        });
  }
}
