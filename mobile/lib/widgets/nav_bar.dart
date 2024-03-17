import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/app/route.dart';

class NavBar extends StatefulWidget {
  const NavBar(
      {super.key,
      required this.tabController,
      required this.titles,
      required this.icons});

  final TabController tabController;
  final List<String> titles;
  final List<Widget> icons;

  @override
  State<StatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
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
              child: Text(widget.titles[widget.tabController.index],
                  style: theme.textTheme.titleMedium),
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 15,
              children: <Widget>[
                IconButton(
                    icon: SvgPicture.asset("assets/svg/Play.svg",
                        width: iconWidth),
                    onPressed: () {}),
                IconButton(
                    icon: SvgPicture.asset("assets/svg/NetworkClose.svg",
                        width: iconWidth),
                    onPressed: () {}),
                IconButton(
                    icon: SvgPicture.asset("assets/svg/FileSearch.svg",
                        width: iconWidth),
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.logs.v)),
              ],
            )
          ],
        ),
        TabBar(
          controller: widget.tabController,
          indicatorColor: Colors.amber,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          dividerHeight: 0,
          tabs: widget.icons.map<Widget>((e) => Tab(icon: e)).toList(),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
