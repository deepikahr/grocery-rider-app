import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocerydelivery/models/no-connection.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/screens/home/tabs.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/socket.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'models/location.dart';
import 'models/socket.dart';
import 'services/constants.dart';
import 'services/localizations.dart';
import 'styles/styles.dart';

Timer onesignlTimer, connectivityTimer;
void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  initPlatformPlayerState();
  onesignlTimer = Timer.periodic(Duration(seconds: 4), (timer) {
    initPlatformPlayerState();
  });
  checkInternatConnection();
  connectivityTimer = Timer.periodic(Duration(seconds: 10), (timer) {
    checkInternatConnection();
  });
  runZoned<Future<Null>>(() {
    runApp(MaterialApp(
      home: AnimatedScreen(),
      debugShowCheckedModeBanner: false,
    ));
    return Future.value(null);
    // ignore: deprecated_member_use
  }, onError: (error, stackTrace) {});

  Common.getSelectedLanguage().then((selectedLocale) {
    Map localizedValues;
    String defaultLocale = '';
    String locale = selectedLocale ?? defaultLocale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    APIService.getLanguageJson(locale).then((value) async {
      localizedValues = value['response_data']['json'];
      locale = value['response_data']['languageCode'];
      String title, msg;
      if (value['response_data']['json'][locale]['NO_INTERNET'] == null) {
        title = "No Internet connection";
      } else {
        title = value['response_data']['json'][locale]['NO_INTERNET'];
      }
      if (value['response_data']['json'][locale]['NO_INTERNET_MSG'] == null) {
        msg =
            "requires an internet connection. Chcek you connection then try again.";
      } else {
        msg = value['response_data']['json'][locale]['NO_INTERNET_MSG'];
      }
      await Common.setNoConnection(
          {"NO_INTERNET": title, "NO_INTERNET_MSG": msg});
      await Common.setSelectedLanguage(locale);
      runZoned<Future<Null>>(() {
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => SocketModel()),
              ChangeNotifierProvider(create: (context) => LocationModel()),
            ],
            child: DeliveryApp(
              locale: locale,
              localizedValues: localizedValues,
            ),
          ),
        );
        return Future.value(null);
        // ignore: deprecated_member_use
      }, onError: (error, stackTrace) {});
    });
  });
}

checkInternatConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    Common.getNoConnection().then((value) {
      String title, msg;
      if (value == null) {
        title = "No Internet connection";
        msg =
            "requires an internet connection. Chcek you connection then try again.";
      } else {
        title = value["NO_INTERNET"];
        msg = value["NO_INTERNET_MSG"];
      }
      Common.setNoConnection({"NO_INTERNET": title, "NO_INTERNET_MSG": msg});
      Common.getNoConnection().then((value) {
        runZoned<Future<Null>>(() {
          runApp(MaterialApp(
              home: ConnectivityPage(
                  title: value['NO_INTERNET'], msg: value['NO_INTERNET_MSG']),
              debugShowCheckedModeBanner: false));
          return Future.value(null);
        }, onError: (error, stackTrace) {});
      });
    });
  }
}

void initPlatformPlayerState() async {
  var settings = {
    OSiOSSettings.autoPrompt: true,
    OSiOSSettings.promptBeforeOpeningPushUrl: true
  };
  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {});
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  await OneSignal.shared.init(Constants.oneSignalKey, iOSSettings: settings);
  OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  var status = await OneSignal.shared.getPermissionSubscriptionState();
  String playerId = status.subscriptionStatus.userId;
  if (playerId != null) {
    await Common.setPlayerID(playerId);
    setPlayerId();
    if (onesignlTimer != null && onesignlTimer.isActive) onesignlTimer.cancel();
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
  final String locale;
  final Map localizedValues;

  DeliveryApp({
    Key key,
    this.locale,
    this.localizedValues,
  });

  @override
  _DeliveryAppState createState() => _DeliveryAppState();
}

class _DeliveryAppState extends State<DeliveryApp> {
  bool isLoggedIn = false, checkDeliveyDisOrNot = false;
  SocketService socket = SocketService();

  @override
  void initState() {
    checkAUthentication();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(widget.locale),
      localizationsDelegates: [
        MyLocalizationsDelegate(widget.localizedValues, [widget.locale]),
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [Locale(widget.locale)],
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(primaryColor: primary, accentColor: primary),
      home: checkDeliveyDisOrNot
          ? AnimatedScreen()
          : isLoggedIn == false
              ? LOGIN(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                )
              : Tabs(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
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
        child: Image.asset(
          'lib/assets/splash.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
