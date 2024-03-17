import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/widgets/logs.dart';
import 'package:mobile/widgets/map.dart';
import 'package:mobile/widgets/nav_bar.dart';
import 'package:mobile/widgets/options.dart';
import 'package:mobile/widgets/sensors.dart';
import 'package:mobile/widgets/user_account.dart';


class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  static const double iconWidth = 32;

  final icons = <Widget>[
    SvgPicture.asset("assets/svg/RadioFill.svg", width: iconWidth),
    SvgPicture.asset("assets/svg/Map.svg", width: iconWidth * 0.9),
    SvgPicture.asset("assets/svg/UserCard.svg", width: iconWidth),
    SvgPicture.asset("assets/svg/Options.svg", width: iconWidth * 0.8)
  ];
  final titles = <String>[ "Sensors", "Map", "User Account", "Options"];

  late final TabController _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: tabIndex);
    _tabController.addListener(() {
      if (tabIndex != _tabController.index) {
        setState(() {
          tabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          NavBar(tabController: _tabController, icons: icons, titles: titles),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  const SensorsWidget(),
                  const MapWidget(),
                  UserAccountWidget(),
                  const OptionsWidget()
                ],
              )
          )
        ]

      )
    );
  }
}
