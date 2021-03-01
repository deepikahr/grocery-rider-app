import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';

class AlertService {
  Timer checkConnectionTimer;
  bool isFirstTime = false;
  AppLifecycleState state;
  checkConnectionMethod() async {
    if (checkConnectionTimer != null && checkConnectionTimer.isActive)
      checkConnectionTimer.cancel();
    checkConnectionTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      state = WidgetsBinding.instance.lifecycleState;
      if (state != AppLifecycleState.paused) {
        Common.getNoConnection().then((value) {
          String noInternet = (value == null || value['NO_INTERNET'] == null
              ? "No Internet connection"
              : value['NO_INTERNET']);
          String onlineMsg = (value == null || value['ONLINE_MSG'] == null
              ? "Now you are online."
              : value['ONLINE_MSG']);
          String noInternetMsg = (value == null ||
                  value["NO_INTERNET_MSG"] == null
              ? "requires an internet connection. Chcek you connection then try again."
              : value["NO_INTERNET_MSG"]);
          if (connectivityResult == ConnectivityResult.none) {
            isFirstTime = true;
            String msg = "$noInternet\n ${Constants.appName} $noInternetMsg";
            AlertService().showToast(msg);
          } else {
            if (isFirstTime) {
              AlertService().showToast(onlineMsg);
              isFirstTime = false;
            }
          }
        });
      }
    });
  }

  showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primary,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showSnackbar(message, BuildContext context, _scaffoldKey) {
    final snackBar = SnackBar(
        backgroundColor: primary,
        content:
            Text(MyLocalizations.of(context).getLocalizations(message ?? "")),
        duration: Duration(milliseconds: 3000));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
