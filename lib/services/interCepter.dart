import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String languageCode, token;
    await Common.getSelectedLanguage().then((code) {
      languageCode = code ?? "";
    });
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    try {
      data.headers['Content-Type'] = 'application/json';
      data.headers['language'] = languageCode;
      data.headers['Authorization'] = 'bearer $token';
      print(data.headers);
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print(data.statusCode);
    print(json.decode(data.body));
    var errorData = json.decode(data.body);
    if (data.statusCode == 400) {
      var msg = '';
      for (int i = 0, l = errorData['errors'].length; i < l; i++) {
        msg += errorData['errors'][i] + '\n';
      }
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.error('Unexpected error :cry:');
    } else if (data.statusCode == 401) {
      await Common.setToken(null);
      await Common.setAccountID(null);
      return Future.error('Unexpected error :cry:');
    }
    return data;
  }
}
