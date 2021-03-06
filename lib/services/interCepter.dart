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
      log('\nššš REQUEST ššš');
      log('ššš baseUrl: ${data.baseUrl}');
      log('ššš url: ${data.url}');
      log('ššš headers: ${data.headers}');
      log('ššš body: ${data.body}');
      log('ššš method: ${data.method}');
      log('ššš queryParameters: ${data.params}');
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    var errorData = json.decode(data.body!);
    log('\nššš RESPONSE ššš');
    log('ššš url: ${data.url}');
    log('ššš status code: ${data.statusCode}');
    log('ššš response: ${data.body}');

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
