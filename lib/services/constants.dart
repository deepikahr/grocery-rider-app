import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

class Constants {
  // app name
  static String appName = 'Readymade Grocery App';

  // Base url
  static String? apiURL = FlutterConfig.get('API_URL');

  // One signal key
  static String? oneSignalKey = FlutterConfig.get('ONE_SIGNAL_KEY');

  // Google API key
  static String? googleMapApiKey = Platform.isIOS
      ? FlutterConfig.get('IOS_GOOGLE_MAP_API_KEY')
      : FlutterConfig.get('ANDROID_GOOGLE_MAP_API_KEY');

  // PREDEFINED
  static String predefined = FlutterConfig.get('PREDEFINED') ?? "false";

  //email validation
  static String emailValidation =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
}
