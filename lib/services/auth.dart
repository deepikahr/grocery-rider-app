import 'dart:convert';

import 'package:grocerydelivery/services/interCepter.dart';
import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';

import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class AuthService {
  //login
  static Future<Map<String, dynamic>> login(body) async {
    return client
        .post(Constants.apiURL + '/users/login', body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // forgetPassword
  static Future<Map<String, dynamic>> forgetPassword(email) async {
    Map body = {"email": email};
    return client
        .post(Constants.apiURL + "/users/forgot-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify otp
  static Future<Map<String, dynamic>> verifyOtp(otp, email) async {
    return client
        .get(Constants.apiURL + "/users/verify-otp?email=$email&otp=$otp")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // reset password
  static Future<Map<String, dynamic>> resetPassword(body) async {
    return client
        .post(Constants.apiURL + "/users/reset-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // change password
  static Future<Map<String, dynamic>> changePassword(body) async {
    return client
        .post(Constants.apiURL + "/users/change-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //get user info
  static Future<Map<String, dynamic>> getUserInfo() async {
    return client.get(Constants.apiURL + '/users/me').then((response) {
      return json.decode(response.body);
    });
  }

// user data update
  static Future<Map<String, dynamic>> updateUserInfo(body) async {
    return client
        .put(Constants.apiURL + "/users/update/profile",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // image delete
  static Future imagedelete() async {
    return client
        .delete(Constants.apiURL + "/users/delete/image")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify mail send api
  static Future<dynamic> verificationMailSendApi(email) async {
    return client
        .get(Constants.apiURL + '/users/resend-verify-email?email=$email')
        .then((response) {
      return json.decode(response.body);
    });
  }
}
