import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'profile.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'home.dart';
import 'history.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Entry extends StatefulWidget {
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GFTabBarView(
        controller: tabController,
        children: <Widget>[
          Home(),
          Profile(),
          History()
        ],
      ),
      bottomNavigationBar: GFTabBar(
        initialIndex: 0,
        controller: tabController,
        length: 3,
        tabBarColor: Colors.white,
        labelColor: primary,
        unselectedLabelColor: primary,
        indicatorColor: primary,
        unselectedLabelStyle: titlePPM(),
        labelStyle: titlePPM(),
        tabs: <Widget>[
          Tab(
            icon: SvgPicture.asset(
                'lib/assets/icons/home.svg', color: primary,
            ),
            text: 'Home',
          ),
          Tab(
            icon: SvgPicture.asset(
                'lib/assets/icons/profile.svg', color: primary,
            ),
            text: 'Profile',
          ),
          Tab(
            icon: SvgPicture.asset(
                'lib/assets/icons/history.svg', color: primary,
            ),
            text: 'History',
          ),
        ],
      ),
    );
  }
}