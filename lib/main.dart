import 'package:flutter/material.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'models/admin_info.dart';
import 'models/location.dart';
import 'models/order.dart';
import 'models/socket.dart';
import 'package:provider/provider.dart';
import 'styles/styles.dart';
import 'screens/auth/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/constants.dart';
import 'services/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/initialize_i18n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initPlatformPlayerState();
  Map<String, Map<String, String>> localizedValues = await initializeI18n();
  String _locale = 'en';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderModel()),
        ChangeNotifierProvider(create: (context) => AdminModel()),
        ChangeNotifierProvider(create: (context) => SocketModel()),
        ChangeNotifierProvider(create: (context) => LocationModel()),
      ],
      child: DeliveryApp(
        _locale,
        localizedValues,
      ),
    ),
  );
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
    initPlatformPlayerState() ;
  } else {
    await Common.setPlayerID(playerId).then((onValue) {});
  }
}

class DeliveryApp extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  DeliveryApp(this.locale, this.localizedValues);
  @override
  _DeliveryAppState createState() => _DeliveryAppState();
}

class _DeliveryAppState extends State<DeliveryApp> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  var selectedLanguage = "English";

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        selectedLanguage = prefs.getString('selectedLanguage');
      });
      print('selected language $selectedLanguage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale:
          Locale(selectedLanguage == null ? widget.locale : selectedLanguage),
      localizationsDelegates: [
        MyLocalizationsDelegate(widget.localizedValues),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: languages.map((language) => Locale(language, '')),
      debugShowCheckedModeBanner: false,
      title: 'Readymade grocery delivery app',
      theme: ThemeData(
        primaryColor: primary,
        accentColor: primary,
      ),
      home: Login(
          locale: selectedLanguage == null ? widget.locale : selectedLanguage,
          localizedValues: widget.localizedValues),
    );
  }
}
