import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/widgets/nav_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  final icons = <Widget>[
    SvgPicture.asset("assets/svg/RadioFill.svg"),
    SvgPicture.asset("assets/svg/Layer.svg"),
    SvgPicture.asset("assets/svg/UserCard.svg"),
    SvgPicture.asset("assets/svg/Command.svg")
  ];
  final titles = <String>[ "Sensors", "Map Layers", "User Account", "Debug"];

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
                children: const <Widget>[
                  Text("sensors"),
                  Text("layers"),
                  Text("user"),
                  Text("options")
                ],
              )
          )
        ]

      )
    );
  }
}
