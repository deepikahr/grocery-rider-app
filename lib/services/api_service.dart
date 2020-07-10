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
        .get(Constants.baseURL + 'delivery/tax/settings/details', headers: {
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
    final response = await client.get(Constants.baseURL + 'users/me', headers: {
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

    final response = await client.get(Constants.baseURL + 'setting/user/App',
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
        .get(Constants.baseURL + "business/business/about/us", headers: {
      'Content-Type': 'application/json',
      'language': languageCode
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    final response = await client.get(
        Constants.baseURL +
            "language/user/info?req_from=deliveyAppJson&language_code=$languageCode",
        headers: {
          'Content-Type': 'application/json',
        });
    return json.decode(response.body);
  }

  // verify email
  static Future<Map<String, dynamic>> verifyEmail(body) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/verify/email",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // reset password
  static Future<Map<String, dynamic>> resetPassword(body, token) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(
        Constants.baseURL + "users/reset-password",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  // verify otp
  static Future<Map<String, dynamic>> verifyOtp(body, token) async {
    String languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    final response = await client.post(Constants.baseURL + "users/verify/OTP",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }

  static Future<dynamic> setLanguageCodeToProfileDefult(languageCode) async {
    String token;
    await Common.getToken().then((tkn) {
      token = tkn;
    });

    final response =
        await client.get(Constants.baseURL + 'users/language/set', headers: {
      'Content-Type': 'application/json',
      'language': languageCode,
      'Authorization': 'bearer $token',
    });
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> changePassword(body) async {
    String token, languageCode;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    final response = await client.post(
        Constants.baseURL + "users/change-password",
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
          'language': languageCode,
        });
    return json.decode(response.body);
  }
}
