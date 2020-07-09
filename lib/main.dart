import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'models/admin_info.dart';
import 'models/location.dart';
import 'models/order.dart';
import 'models/socket.dart';
import 'package:provider/provider.dart';
import 'styles/styles.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/constants.dart';
import 'services/localizations.dart';

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
    Map localizedValues;
    String defaultLocale = '';
    String locale = selectedLocale ?? defaultLocale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    APIService.getLanguageJson(locale).then((value) async {
      localizedValues = value['response_data']['json'];
      if (locale == '') {
        defaultLocale = value['response_data']['defaultCode']['languageCode'];
        locale = defaultLocale;
      }
      await Common.setSelectedLanguage(locale);
      await Common.setAllLanguageNames(value['response_data']['langName']);
      await Common.setAllLanguageCodes(value['response_data']['langCode']);
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

class DeliveryApp extends StatelessWidget {
  final String locale;
  final Map localizedValues;
  DeliveryApp({
    Key key,
    this.locale,
    this.localizedValues,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: [
        MyLocalizationsDelegate(localizedValues, [locale]),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale(locale)],
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(primaryColor: primary, accentColor: primary),
      home: LOGIN(
        locale: locale,
        localizedValues: localizedValues,
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
