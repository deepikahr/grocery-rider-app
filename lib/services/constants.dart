import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // app name
  static String appName = 'Readymade Grocery Delivery App';

  // Base url
  static String apiURL = DotEnv().env['API_URL'];

  // One signal key
  static String oneSignalKey = DotEnv().env['ONE_SIGNAL_KEY'];

  // Google API key
  static String googleMapApiKey = Platform.isIOS
      ? DotEnv().env['IOS_GOOGLE_MAP_API_KEY']
      : DotEnv().env['ANDROID_GOOGLE_MAP_API_KEY'];

  // image kit url
  static String imageKitUrl = DotEnv().env['IMAGE_URL_PATH'];
}
