import 'dart:convert';
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
      print('\n🎇🎇🎇 REQUEST 🎇🎇🎇');
      print('🎇🎇🎇 baseUrl: ${data.baseUrl}');
      print('🎇🎇🎇 url: ${data.url}');
      print('🎇🎇🎇 headers: ${data.headers}');
      printWrapped('🎇🎇🎇 body: ${data.body}');
      print('🎇🎇🎇 method: ${data.method}');
      print('🎇🎇🎇 queryParameters: ${data.params}');
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    var errorData = json.decode(data.body!);
    print('\n🎇🎇🎇 RESPONSE 🎇🎇🎇');
    print('🎇🎇🎇 url: ${data.url}');
    print('🎇🎇🎇 status code: ${data.statusCode}');
    printWrapped('🎇🎇🎇 response: ${data.body}');

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

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
