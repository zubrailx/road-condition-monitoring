import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/app/route.dart';
import 'package:mobile/widgets/network_switch.dart';
import 'package:mobile/widgets/sensor_switch.dart';

class NavBar extends StatelessWidget {
  const NavBar(
      {super.key,
      required this.tabController,
      required this.titles,
      required this.icons});

  final TabController tabController;
  final List<String> titles;
  final List<Widget> icons;

  static const double iconWidth = 32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(titles[tabController.index],
                  style: theme.textTheme.titleMedium),
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 15,
              children: <Widget>[
                SensorSwitchWidget(width: iconWidth),
                NetworkSwitchWidget(width: iconWidth),
                IconButton(
                    icon: SvgPicture.asset("assets/svg/FileSearch.svg",
                        width: iconWidth),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.logs.v)),
              ],
            )
          ],
        ),
        TabBar(
          controller: tabController,
          indicatorColor: Colors.amber,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          dividerHeight: 0,
          tabs: icons.map<Widget>((e) => Tab(icon: e)).toList(),
        )
      ],
    );
  }
}
