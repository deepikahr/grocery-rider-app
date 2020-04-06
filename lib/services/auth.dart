import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

class AuthService {
  static final Client client = Client();

  static Future<Map<String, dynamic>> login(body) async {
    final response = await client.post(Constants.BASE_URL + 'users/login',
        body: json.encode(body), headers: {'Content-Type': 'application/json'});
    return json.decode(response.body);
  }

  // static Future<Map<String, dynamic>> transferMoney(body) async {
  //   String token;
  //   await Common.getToken().then((onValue) {
  //     token = onValue;
  //   });
  //   Map encryptedBody = {
  //     'required': true,
  //     'accessToken':
  //         Ecryption.encrypt(DateTime.now().millisecondsSinceEpoch.toString()),
  //     'body': Ecryption.encrypt(json.encode(body))
  //   };
  //   final response = await client.post(
  //       Constants.baseURLrbtmfs + 'mfs/transfer/am/other/airtel/user',
  //       body: json.encode(encryptedBody),
  //       headers: {'Content-Type': 'application/json', 'Authorization': token});
  //   return json.decode(Deryption.decrypt(response.body));
  // }

}
