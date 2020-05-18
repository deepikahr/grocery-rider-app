import 'common.dart';
import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

class APIService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> getLocationformation() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client
        .get(Constants.BASE_URL + 'delivery/tax/settings/details', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.get(Constants.BASE_URL + 'users/me',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token'
        });
    return json.decode(response.body);
  }

  static Future<dynamic> getGlobalSettings() async {
    final response = await client.get(Constants.BASE_URL + 'setting/user/App',
        headers: {'Content-Type': 'application/json'});
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> aboutUs() async {
    final response = await client
        .get(Constants.BASE_URL + "business/business/about/us", headers: {
      'Content-Type': 'application/json',
    });
    return json.decode(response.body);
  }
}
