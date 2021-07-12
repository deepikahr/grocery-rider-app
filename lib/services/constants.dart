import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // app name
  static String appName = 'Readymade Grocery App';

  // Base url
  static String? apiURL = dotenv.env['API_URL'];

  // One signal key
  static String? oneSignalKey = dotenv.env['ONE_SIGNAL_KEY'];

  // Google API key
  static String? googleMapApiKey = Platform.isIOS
      ? dotenv.env['IOS_GOOGLE_MAP_API_KEY']
      : dotenv.env['ANDROID_GOOGLE_MAP_API_KEY'];

  // PREDEFINED
  static String predefined = dotenv.env['PREDEFINED'] ?? "false";

  //email validation
  static String emailValidation =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
}
