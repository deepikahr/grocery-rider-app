import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'dart:convert';

class AuthService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> lOGIN(body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await client.post(Constants.BASE_URL + 'users/login',
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': prefs.getString('selectedLanguage') ?? ""
        });
    return json.decode(response.body);
  }
}
