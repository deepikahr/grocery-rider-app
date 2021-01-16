import 'dart:convert';

import 'package:grocerydelivery/services/interCepter.dart';
import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';

import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class AuthService {
  //login
  static Future login(body) async {
    return client
        .post(Constants.apiURL + '/users/login-phone', body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // forgetPassword
  static Future forgetPassword(mobileNumber) async {
    Map body = {"mobileNumber": mobileNumber.toString()};
    return client
        .post(Constants.apiURL + "/users/send-otp-phone",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // verify otp
  static Future verifyOtp(body) async {
    return client
        .post(Constants.apiURL + "/users/verify-otp/number",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // reset password
  static Future resetPassword(body) async {
    return client
        .post(Constants.apiURL + "/users/reset-password-number",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // change password
  static Future changePassword(body) async {
    return client
        .post(Constants.apiURL + "/users/change-password",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  //get user info
  static Future getUserInfo() async {
    return client.get(Constants.apiURL + '/users/me').then((response) {
      return json.decode(response.body);
    });
  }

// user data update
  static Future updateUserInfo(body) async {
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
  static Future verificationMailSendApi(email) async {
    return client
        .get(Constants.apiURL + '/users/resend-verify-email?email=$email')
        .then((response) {
      return json.decode(response.body);
    });
  }
}
