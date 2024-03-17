import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class NetworkSwitchWidget extends StatefulWidget {
  const NetworkSwitchWidget({super.key, required this.width});

  final double width;

  @override
  State createState() {
    return _NetworkSwitchWidgetState();
  }
}

class _NetworkSwitchWidgetState extends State<NetworkSwitchWidget> {
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: isPaused
            ? SvgPicture.asset("assets/svg/NetworkClose.svg",
                width: widget.width)
            : SvgPicture.asset("assets/svg/NetworkUpload.svg",
                width: widget.width),
        onPressed: () {
          GetIt.I<Talker>().warning("networking has not been implemented yet");
          setState(() {
            isPaused = !isPaused;
          });
        });
  }
}
