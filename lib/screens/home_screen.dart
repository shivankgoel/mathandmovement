import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathandmovement/utils/defaultscreens.dart';
import 'package:mathandmovement/widgets/drawer.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mathandmovement/screens/materials_screen.dart';
import 'package:mathandmovement/screens/music_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mathandmovement/screens/materials_screen.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabController tabController;
  ScrollController _scrollController;
  final _myTabbedPageKey = new GlobalKey<_HomeScreenState>();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? tempwidget(context, false, tabController, _myTabbedPageKey)
            : tempwidget(context, true, tabController, _myTabbedPageKey);
      },
    );
  }
}

Widget tempwidget(BuildContext context, bool _fullScreen,
    TabController tabController, GlobalKey _myTabbedPageKey) {
  return DefaultTabController(
    length: 4,
    child: Scaffold(
      drawer: DrawerMenu(),
      //key: _scaffoldKey,
      appBar: _fullScreen
          ? null
          : AppBar(
              title: Text('Math & Movement'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(icon: FaIcon(FontAwesomeIcons.bookOpen)),
                  Tab(icon: FaIcon(FontAwesomeIcons.music)),
                  Tab(icon: FaIcon(FontAwesomeIcons.appleAlt)),
                  Tab(icon: FaIcon(FontAwesomeIcons.home)),
                ],
              ),
            ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          MaterialsScreen(_myTabbedPageKey),
          MusicScreen(),
          GiveScaffoldCenterText("Tab 2"),
          GiveScaffoldCenterText("Tab 3"),
        ],
      ),
    ),
  );
}
