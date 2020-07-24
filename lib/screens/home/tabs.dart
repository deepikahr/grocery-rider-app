import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import '../../models/admin_info.dart';
import '../../models/order.dart';
import '../../services/api_service.dart';
import '../../services/common.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import '../../styles/styles.dart';
import 'home.dart';
import 'history.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tabs extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Tabs({Key key, this.localizedValues, this.locale}) : super(key: key);
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
    APIService.getLocationformation().then((onValue) async {
      if (onValue['response_data'] != null &&
          onValue['response_data']['currencyCode'] != null) {
        Provider.of<OrderModel>(context, listen: false)
            .updateCurrency(onValue['response_data']['currencyCode']);
      }
    });
    AuthService.getUserInfo().then((value) {
      print(value);
      if (value['response_code'] == 200 && mounted) {
        setState(() {
          Common.setAccountID(value['response_data']['_id']);
        });
      }
    });
  }

  void getAdminInfo() async {
    await APIService.getLocationformation().then((info) {
      Provider.of<AdminModel>(context, listen: false).updateInfo(info);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GFTabBarView(
        controller: tabController,
        children: <Widget>[
          Home(locale: widget.locale, localizedValues: widget.localizedValues),
          Profile(
              locale: widget.locale, localizedValues: widget.localizedValues),
          History(
              locale: widget.locale, localizedValues: widget.localizedValues),
        ],
      ),
      bottomNavigationBar: GFTabBar(
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
              height: 20,
            ),
            text: MyLocalizations.of(context).getLocalizations("HOME"),
          ),
          Tab(
            icon: SvgPicture.asset(
              'lib/assets/icons/profile.svg',
              color: primary,
              height: 20,
            ),
            text: MyLocalizations.of(context).getLocalizations("PROFILE"),
          ),
          Tab(
            icon: SvgPicture.asset(
              'lib/assets/icons/history.svg',
              color: primary,
              height: 20,
            ),
            text: MyLocalizations.of(context).getLocalizations("HISTORY"),
          ),
        ],
      ),
    );
  }
}
