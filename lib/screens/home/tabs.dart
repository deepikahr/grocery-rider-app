import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/services/socket.dart';

import '../../services/api_service.dart';
import '../../services/common.dart';
import '../../styles/styles.dart';
import 'history.dart';
import 'home.dart';
import 'profile.dart';

class Tabs extends StatefulWidget {
  final Map localizedValues;
  final String locale;

  Tabs({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SocketService socket = SocketService();
  TabController tabController;
  Map newOrder;
  bool isOrderAccept = false, isOrderReject = false;
  @override
  void initState() {
    getData();
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (tabController != null) tabController.dispose();
    super.dispose();
  }

  void getData() async {
    APIService.getLocationformation().then((onValue) async {
      if (onValue['response_data'] != null &&
          onValue['response_data']['currencyCode'] != null) {
        Common.setCurrency(onValue['response_data']['currencyCode']);
      } else {
        Common.setCurrency("\$");
      }
    });
  }

  orderAccept(order) {
    if (mounted) {
      setState(() {
        isOrderAccept = true;
      });
    }

    APIService.orderAcceptApi(order['_id'].toString()).then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          isOrderAccept = false;
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Tabs(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues),
                ),
                (Route<dynamic> route) => false);
          }
        });
      } else {
        if (mounted) {
          setState(() {
            isOrderAccept = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isOrderAccept = false;
        });
      }
    });
  }

  orderReject(order) {
    if (mounted) {
      setState(() {
        isOrderReject = true;
      });
    }

    APIService.orderRejectApi(order['_id'].toString()).then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          isOrderReject = false;
          Navigator.of(context);
        });
      } else {
        if (mounted) {
          setState(() {
            isOrderReject = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isOrderAccept = false;
        });
      }
    });
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
