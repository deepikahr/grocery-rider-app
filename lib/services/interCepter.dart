import 'dart:convert';
import 'dart:developer';
import 'package:grocerydelivery/services/alert-service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    try {
      data.headers['Content-Type'] = 'application/json';
      data.headers['language'] = languageCode!;
      data.headers['Authorization'] = 'bearer $token';
      log('\n🎇🎇🎇 REQUEST 🎇🎇🎇');
      log('🎇🎇🎇 baseUrl: ${data.baseUrl}');
      log('🎇🎇🎇 url: ${data.url}');
      log('🎇🎇🎇 headers: ${data.headers}');
      log('🎇🎇🎇 body: ${data.body}');
      log('🎇🎇🎇 method: ${data.method}');
      log('🎇🎇🎇 queryParameters: ${data.params}');
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    var errorData = json.decode(data.body!);
    log('\n🎇🎇🎇 RESPONSE 🎇🎇🎇');
    log('🎇🎇🎇 url: ${data.url}');
    log('🎇🎇🎇 status code: ${data.statusCode}');
    log('🎇🎇🎇 response: ${data.body}');

    if (data.statusCode == 400) {
      var msg = '';
      for (int? i = 0, l = errorData['errors'].length; i! < l!; i++) {
        if (l != i + 1) {
          msg += errorData['errors'][i] + "\n";
        } else {
          msg += errorData['errors'][i];
        }
      }
      AlertService().showToast(msg);
      return Future.error('Unexpected error :cry:');
    } else if (data.statusCode == 401) {
      await Common.deleteToken();
      await Common.deleteAccountID();
      return Future.error('Unexpected error :cry:');
    }
    return data;
  }
}
