import 'dart:convert';
import 'package:flutter/material.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initPlatformPlayerState();
  // Map<String, Map<String, String>> localizedValues = await initializeI18n();
  // String _locale = 'en';
  runApp(MaterialApp(
    home: AnimatedScreen(),
    debugShowCheckedModeBanner: false,
  ));
  SharedPreferences.getInstance().then((prefs) {
    Map localizedValues;
    String defaultLocale = '';
    String locale = prefs.getString('selectedLanguage') ?? defaultLocale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    APIService.getLanguageJson(locale).then((value) {
      print(value);
      localizedValues = value['response_data']['json'];
      if (locale == '') {
        defaultLocale = value['response_data']['defaultCode']['languageCode'];
        locale = defaultLocale;
      }
      prefs.setString('selectedLanguage', locale);
      prefs.setString('selectedLanguageName',
          value['response_data']['defaultCode']['languageName']);
      prefs.setString(
          'alllanguageNames', json.encode(value['response_data']['langName']));
      prefs.setString(
          'alllanguageCodes', json.encode(value['response_data']['langCode']));
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
  await OneSignal.shared.init(Constants.ONE_SIGNAL_KEY, iOSSettings: settings);
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
