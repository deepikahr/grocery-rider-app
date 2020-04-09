import 'common.dart';
import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

class APIService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> getAdminInformation() async {
    String token;
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    print('Delivery agent token --> $token');
    final response = await client
        .get(Constants.BASE_URL + 'users/delivery/information', headers: {
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
}
