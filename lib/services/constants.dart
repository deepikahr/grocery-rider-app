import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // app name
  static String appName = DotEnv().env['APPLICATION_NAME'];

  // Base url
  static String apiURL = DotEnv().env['API_URL'];

  // One signal key
  static String oneSignalKey = DotEnv().env['ONE_SIGNAL_KEY'];

  // Google API key
  static String googleMapApiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];
}
