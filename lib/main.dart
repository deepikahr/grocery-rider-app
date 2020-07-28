import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/screens/home/tabs.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'models/admin_info.dart';
import 'models/location.dart';
import 'models/order.dart';
import 'models/socket.dart';
import 'services/constants.dart';
import 'services/localizations.dart';
import 'styles/styles.dart';

void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  initPlatformPlayerState();
  runZoned<Future<Null>>(() {
    runApp(MaterialApp(
      home: AnimatedScreen(),
      debugShowCheckedModeBanner: false,
    ));
    return Future.value(null);
    // ignore: deprecated_member_use
  }, onError: (error, stackTrace) {});

  Common.getSelectedLanguage().then((selectedLocale) {
    print(selectedLocale);
    Map localizedValues;
    String defaultLocale = 'en';
    String locale = selectedLocale ?? defaultLocale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    APIService.getLanguageJson(locale).then((value) async {
      localizedValues = value['response_data']['json'];
      defaultLocale = value['response_data']['languageCode'];
      locale = defaultLocale;

      await Common.setSelectedLanguage(locale);
      runZoned<Future<Null>>(() {
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => OrderModel()),
              ChangeNotifierProvider(create: (context) => AdminModel()),
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
  if (playerId == null) {
    initPlatformPlayerState();
  } else {
    await Common.setPlayerID(playerId).then((onValue) {});
  }
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
            Common.getSelectedLanguage().then((selectedLocale) async {
              Map body = {"language": selectedLocale};
              await AuthService.updateUserInfo(body);
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
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale(widget.locale)],
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
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
