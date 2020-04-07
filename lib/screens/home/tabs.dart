import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/models/admin_info.dart';
import 'package:grocerydelivery/models/order.dart';
import 'package:grocerydelivery/models/socket.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/socket.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'home.dart';
import 'history.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController tabController;

  Map<String, dynamic> storeLocation;

  @override
  void initState() {
    initSocket();
    getAdminInfo();
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void initSocket() async {
    SocketService socket = SocketService();
    Provider.of<SocketModel>(context, listen: false).setSocketInstance(socket);
    await Common.getAccountID().then((id) {
      socket.getSocket().on('assigned-orders$id', (data) {
        Provider.of<OrderModel>(context, listen: false)
            .addOrders(data['assignedOrders']);
      });
      socket.getSocket().on('delivered-orders$id', (data) {
        Provider.of<OrderModel>(context, listen: false)
            .addDelieveredOrders(data['orders']);
      });
    });
  }

  void getAdminInfo() async {
    await APIService.getAdminInformation().then((info) {
      Provider.of<AdminModel>(context, listen: false).update(info);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GFTabBarView(
        controller: tabController,
        children: <Widget>[
          Home(),
          Profile(),
          History(),
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
              'lib/assets/icons/home.svg',
              color: primary,
            ),
            text: 'Home',
          ),
          Tab(
            icon: SvgPicture.asset(
              'lib/assets/icons/profile.svg',
              color: primary,
            ),
            text: 'Profile',
          ),
          Tab(
            icon: SvgPicture.asset(
              'lib/assets/icons/history.svg',
              color: primary,
            ),
            text: 'History',
          ),
        ],
      ),
    );
  }
}
