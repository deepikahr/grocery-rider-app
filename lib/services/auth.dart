import 'package:grocerydelivery/services/interCepter.dart';
import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';
import 'constants.dart';
import 'dart:convert';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class AuthService {
  //login
  static Future<Map<String, dynamic>> login(body) async {
    final response = await client.post(
      Constants.baseURL + 'users/login',
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  // forgetPassword
  static Future<Map<String, dynamic>> forgetPassword(email) async {
    Map body = {"email": email};
    final response = await client.post(
        Constants.baseURL + "users/forgot-password",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // verify otp
  static Future<Map<String, dynamic>> verifyOtp(otp, email) async {
    final response = await client
        .get(Constants.baseURL + "users/verify-otp?email=$email&otp=$otp");
    return json.decode(response.body);
  }

  // reset password
  static Future<Map<String, dynamic>> resetPassword(body) async {
    final response = await client.post(
        Constants.baseURL + "users/reset-password",
        body: json.encode(body));
    return json.decode(response.body);
  }

  // change password
  static Future<Map<String, dynamic>> changePassword(body) async {
    final response = await client.post(
        Constants.baseURL + "users/change-password",
        body: json.encode(body));
    return json.decode(response.body);
  }

  //get user info
  static Future<Map<String, dynamic>> getUserInfo() async {
    final response = await client.get(Constants.baseURL + 'users/me');
    return json.decode(response.body);
  }

// user data update
  static Future<Map<String, dynamic>> updateUserInfo(body) async {
    final response = await client.put(
        Constants.baseURL + "users/update/profile",
        body: json.encode(body));
    return json.decode(response.body);
  }
}
