import 'package:grocerydelivery/services/common.dart';
import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

class AuthService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> lOGIN(body) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.BASE_URL + 'users/login',
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode
        });
    return json.decode(response.body);
  }

  static Future<dynamic> setLanguageCodeToProfile() async {
    String languageCode, token;
    await Common.getToken().then((tkn) {
      token = tkn;
    });
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response =
        await client.get(Constants.BASE_URL + 'users/language/set', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
      'Authorization': 'bearer $token',
    });
    return json.decode(response.body);
  }
}
