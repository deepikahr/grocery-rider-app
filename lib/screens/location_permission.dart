import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/screens/home/tabs.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/button.dart';
import 'package:location/location.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

class LocationPermissionCheck extends StatefulWidget {
  final bool isLoggedIn;
  final Map? localizedValues;
  final String? locale;
  const LocationPermissionCheck(
      {Key? key, this.isLoggedIn = false, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _LocationPermissionCheckState createState() =>
      _LocationPermissionCheckState();
}

class _LocationPermissionCheckState extends State<LocationPermissionCheck> {
  var message;
  PermissionStatus? _permissionGranted;
  Location _location = Location();
  LocationData? currentLocation;
  bool isChecking = false;
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  checkPermission() async {
    setState(() {
      isChecking = true;
      message = 'PLEASE_WAIT';
    });
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        goToPage();
        return;
      } else {
        setState(() {
          if (_permissionGranted == PermissionStatus.deniedForever) {
            message = 'LOCATION_ALLOW_ERROR_MSG_PERMANTLY';
          } else {
            message = 'LOCATION_ALLOW_ERROR_MSG';
          }
          isChecking = false;
        });
      }
    }
    currentLocation = await _location.getLocation();
    if (currentLocation != null) {
      goToPage();
    }
  }

  goToPage() {
    setState(() {
      if (widget.isLoggedIn) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Tabs(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
              ),
            ),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LOGIN(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
              ),
            ),
            (Route<dynamic> route) => false);
      }
      isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: GFAvatar(
                backgroundImage: AssetImage('lib/assets/logo.png'),
                radius: 60,
              ),
            ),
            Center(
              child: Text(
                MyLocalizations.of(context)!.getLocalizations(message ?? ''),
                style: textmediumblack(),
              ),
            ),
            SizedBox(height: 20),
            isChecking
                ? SquareLoader()
                : Row(
                    children: <Widget>[
                      buildRetryButton(),
                      SizedBox(width: 10),
                      buildSettingButton(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildRetryButton() {
    return Expanded(
      child: InkWell(
        onTap: checkPermission,
        child: alartAcceptRejectButton(context, "RETRY", false),
      ),
    );
  }

  Widget buildSettingButton() {
    return Expanded(
        child: InkWell(
      onTap: () {
        permission.openAppSettings();
      },
      child: alartAcceptRejectButton(context, "SETTING", false),
    ));
  }
}
