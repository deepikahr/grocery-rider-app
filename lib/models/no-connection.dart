import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:grocerydelivery/main.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/styles/styles.dart';

class ConnectivityPage extends StatefulWidget {
  final String title, msg;

  ConnectivityPage({Key key, this.title, this.msg});
  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  Timer connectivityTimer;
  @override
  void initState() {
    checkInternatConnection();
    connectivityTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkInternatConnection();
    });
    super.initState();
  }

  checkInternatConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      main();
    }
  }

  @override
  void dispose() {
    if (connectivityTimer != null && connectivityTimer.isActive)
      connectivityTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            buildNoConnection(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(widget.title ?? "",
                    style: textAddressLocation(), textAlign: TextAlign.center),
                SizedBox(height: 20),
                Text("${Constants.appName} ${widget.msg}" ?? "",
                    style: textAddressLocationLow(),
                    textAlign: TextAlign.center),
                SizedBox(height: 180)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildNoConnection() {
    return Positioned(
      bottom: 0.0,
      child: Image(
        image: AssetImage("lib/assets/noconnection.png"),
        fit: BoxFit.cover,
        height: screenHeight(context) - 170,
        width: screenWidth(context),
      ),
    );
  }
}
