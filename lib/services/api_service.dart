import 'package:shared_preferences/shared_preferences.dart';

import 'common.dart';
import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

class APIService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> getLocationformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    print('Delivery agent token --> $token');
    final response = await client
        .get(Constants.BASE_URL + 'delivery/tax/settings/details', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': prefs.getString('selectedLanguage') ?? ""
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response =
        await client.get(Constants.BASE_URL + 'users/me', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': prefs.getString('selectedLanguage') ?? ""
    });
    return json.decode(response.body);
  }

  static Future<dynamic> getGlobalSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
        await client.get(Constants.BASE_URL + 'setting/user/App', headers: {
      'Content-Type': 'application/json',
      'language': prefs.getString('selectedLanguage') ?? ""
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> aboutUs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await client
        .get(Constants.BASE_URL + "business/business/about/us", headers: {
      'Content-Type': 'application/json',
      'language': prefs.getString('selectedLanguage') ?? ""
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    final response = await client.get(
        Constants.BASE_URL +
            "language/user/info?req_from=deliveyAppJson&language_code=$languageCode",
        headers: {
          'Content-Type': 'application/json',
        });
    return json.decode(response.body);
  }
}
