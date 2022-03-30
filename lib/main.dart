import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/services/alert-service.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/socket.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'models/location.dart';
import 'models/socket.dart';
import 'screens/address_pick.dart';
import 'screens/auth/login.dart';
import 'screens/home/tabs.dart';
import 'services/constants.dart';
import 'services/localizations.dart';
import 'services/locationService.dart';
import 'styles/styles.dart';

void main() {
  initializeMain(isTest: false);
}

void initializeMain({bool? isTest}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  AlertService().checkConnectionMethod();
  runZonedGuarded(() {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SocketModel()),
      ChangeNotifierProvider(create: (context) => LocationModel())
    ], child: DeliveryApp()));
    return Future.value(null);
  }, (error, stackTrace) {});
  initializeLanguage(isTest: isTest);
}

void initializeLanguage({bool? isTest}) async {
  if (isTest != null && !isTest) {
    initPlatformPlayerState();
  }
}

void initPlatformPlayerState() async {
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId(Constants.oneSignalKey!);
  await OneSignal.shared.promptUserForPushNotificationPermission();
  var playerId = (await OneSignal.shared.getDeviceState())?.userId;
  print('playerId-- $playerId');
  if (playerId != null) {
    await Common.setPlayerID(playerId);
    setPlayerId();
  }
}

void setPlayerId() async {
  await Common.getToken().then((token) async {
    if (token != null) {
      Common.getPlayerId().then((palyerId) {
        Common.getSelectedLanguage().then((selectedLocale) async {
          Map body = {"language": selectedLocale, "playerId": palyerId};
          await AuthService.updateUserInfo(body);
        });
      });
    }
  });
}

class DeliveryApp extends StatefulWidget {
  @override
  _DeliveryAppState createState() => _DeliveryAppState();
}

class _DeliveryAppState extends State<DeliveryApp> {
  bool isLoggedIn = false, checkDeliveyDisOrNot = false;
  SocketService socket = SocketService();
  Map? localizedValues;
  String? locale;
  bool isGetJsonLoading = false, isPermissionChecking = false;
  LatLng? latLng;
  @override
  void initState() {
    getJson();
    checkAUthentication();
    checkPermission();
    super.initState();
  }

  getJson() async {
    setState(() {
      isGetJsonLoading = true;
    });
    await Common.getSelectedLanguage().then((selectedLocale) async {
      String defaultLocale = '';
      locale = selectedLocale ?? defaultLocale;
      await APIService.getLanguageJson(locale).then((value) async {
        setState(() {
          isGetJsonLoading = false;
        });
        localizedValues = value['response_data']['json'];
        locale = value['response_data']['languageCode'];
        Common.setNoConnection({
          "NO_INTERNET": value['response_data']['json'][locale]["NO_INTERNET"],
          "ONLINE_MSG": value['response_data']['json'][locale]["ONLINE_MSG"],
          "NO_INTERNET_MSG": value['response_data']['json'][locale]
              ["NO_INTERNET_MSG"]
        });
        await Common.setSelectedLanguage(locale!);
      });
    });
  }

  void checkAUthentication() async {
    if (mounted) {
      setState(() {
        checkDeliveyDisOrNot = true;
      });
    }
    await Common.getToken().then((token) async {
      if (token != null) {
        if (mounted) {
          setState(() {
            checkDeliveyDisOrNot = false;
            isLoggedIn = true;
            Common.getPlayerId().then((palyerId) {
              Common.getSelectedLanguage().then((selectedLocale) async {
                Map body = {"language": selectedLocale, "playerId": palyerId};
                await AuthService.updateUserInfo(body);
              });
            });
          });
        }
      } else {
        if (mounted) {
          setState(() {
            checkDeliveyDisOrNot = false;
            isLoggedIn = false;
          });
        }
      }
    });
  }

  checkPermission() async {
    if (mounted) {
      setState(() {
        isPermissionChecking = true;
      });
    }
    String permission = await LocationUtils().locationPermission();
    if (permission != 'ALLOW') {
      if (mounted) {
        setState(() {
          isPermissionChecking = false;
        });
      }
    } else {
      Position? position = await LocationUtils().currentLocation();
      if (mounted) {
        setState(() {
          latLng = LatLng(position.latitude, position.longitude);
          isPermissionChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isGetJsonLoading || checkDeliveyDisOrNot || isPermissionChecking
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.transparent,
                selectionHandleColor: Colors.transparent,
                cursorColor: primary,
              ),
              primaryColor: primary,
              colorScheme: ThemeData().colorScheme.copyWith(
                    secondary: primary,
                  ),
            ),
            darkTheme: ThemeData(brightness: Brightness.dark),
            home: AnimatedScreen())
        : MaterialApp(
            locale: Locale(locale!),
            localizationsDelegates: [
              MyLocalizationsDelegate(localizedValues, [locale]),
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            supportedLocales: [Locale(locale!)],
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.transparent,
                selectionHandleColor: Colors.transparent,
                cursorColor: primary,
              ),
              primaryColor: primary,
              colorScheme: ThemeData().colorScheme.copyWith(
                    secondary: primary,
                  ),
            ),
            home: latLng != null
                ? isLoggedIn
                    ? Tabs(
                        locale: locale,
                        localizedValues: localizedValues,
                      )
                    : LoginPage(
                        locale: locale,
                        localizedValues: localizedValues,
                      )
                : AddressPickPage(
                    locale: locale,
                    localizedValues: localizedValues,
                    initialLocation: latLng,
                  ),
          );
  }
}

class AnimatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset('lib/assets/splash.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width),
      ),
    );
  }
}
