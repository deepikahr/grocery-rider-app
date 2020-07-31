import 'dart:convert';

import 'package:grocerydelivery/services/interCepter.dart';
import 'package:http/http.dart' show Client;
import 'package:http_interceptor/http_interceptor.dart';

import 'constants.dart';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class APIService {
  // get location info
  static Future<Map<String, dynamic>> getLocationformation() async {
    final response = await client.get(Constants.apiURL + '/settings/details');
    return json.decode(response.body);
  }

  // get json data
  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    return client
        .get(Constants.apiURL + "/languages/delivery?code=$languageCode")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get languages list
  static Future<dynamic> getLanguagesList() async {
    return client.get(Constants.apiURL + "/languages/list").then((response) {
      return json.decode(response.body);
    });
  }

  //notification list
  static Future<Map<String, dynamic>> getOrderHistory(orderId) async {
    return client
        .get(Constants.apiURL + "/orders/delivery-boy/detail/$orderId")
        .then((response) {
      return json.decode(response.body);
    });
  }

  static Future<dynamic> orderStausChange(body, orderId) async {
    return client
        .put(Constants.apiURL + "/orders/delivery-boy/status-update/$orderId",
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get delivered order list
  static Future<dynamic> getDeliverdOrder(limit, index) async {
    return client
        .get(Constants.apiURL +
            "/orders/delivery-boy/delivered/list?limit=$limit&page=$index")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get assigned order list
  static Future<dynamic> getAssignedOrder(limit, index) async {
    return client
        .get(Constants.apiURL +
            "/orders/delivery-boy/assigned/list?limit=$limit&page=$index")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get order Accept api order
  static Future<Map<String, dynamic>> orderAcceptApi(orderId) async {
    return client
        .put(Constants.apiURL + "/orders/delivery-boy/accept/$orderId")
        .then((response) {
      return json.decode(response.body);
    });
  }

  // get RejectApi order
  static Future<Map<String, dynamic>> orderRejectApi(orderId) async {
    return client
        .put(Constants.apiURL + "/orders/delivery-boy/reject/$orderId")
        .then((response) {
      return json.decode(response.body);
    });
  }
}
