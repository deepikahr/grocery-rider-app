import 'common.dart';
import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

class APIService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> getLocationformation() async {
    String token, languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.BASE_URL + 'delivery/tax/settings/details', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    String languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response =
        await client.get(Constants.BASE_URL + 'users/me', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token',
      'language': languageCode
    });
    return json.decode(response.body);
  }

  static Future<dynamic> getGlobalSettings() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client.get(Constants.BASE_URL + 'setting/user/App',
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode
        });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> aboutUs() async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });

    final response = await client
        .get(Constants.BASE_URL + "business/business/about/us", headers: {
      'Content-Type': 'application/json',
      'language': languageCode
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
