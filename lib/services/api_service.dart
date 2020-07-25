import 'package:grocerydelivery/services/interCepter.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' show Client;
import 'constants.dart';
import 'dart:convert';

Client client =
    HttpClientWithInterceptor.build(interceptors: [ApiInterceptor()]);

class APIService {
  // get location info
  static Future<Map<String, dynamic>> getLocationformation() async {
    final response = await client.get(Constants.baseURL + 'settings/details');
    return json.decode(response.body);
  }

  // get json data
  static Future<Map<String, dynamic>> getLanguageJson(languageCode) async {
    final response = await client
        .get(Constants.baseURL + "languages/delivery?code=$languageCode");
    return json.decode(response.body);
  }

  // get languages list
  static Future<dynamic> getLanguagesList() async {
    final response = await client.get(Constants.baseURL + "languages/list");
    return json.decode(response.body);
  }

  //notification list
  static Future<Map<String, dynamic>> getOrderHistory(orderId) async {
    final response = await client
        .get(Constants.baseURL + "orders/delivery-boy/detail/$orderId");
    return json.decode(response.body);
  }

  static Future<dynamic> orderStausChange(body, orderId) async {
    final response = await client.put(
      Constants.baseURL + "orders/delivery-boy/status-update/$orderId",
      body: json.encode(body),
    );
    print("orders/delivery-boy/status-update/$orderId");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  // get delivered order list
  static Future<dynamic> getDeliverdOrder(limit, index) async {
    final response = await client.put(Constants.baseURL +
        "orders/delivery-boy/delivered/list?limit=$limit&page=$index");
    return json.decode(response.body);
  }

  // get assigned order list
  static Future<dynamic> getAssignedOrder(limit, index) async {
    final response = await client.put(Constants.baseURL +
        "orders/delivery-boy/assigned/list?limit=$limit&page=$index");
    return json.decode(response.body);
  }

  // get order Accept api order
  static Future<Map<String, dynamic>> orderAcceptApi(orderId) async {
    final response = await client
        .put(Constants.baseURL + "orders/delivery-boy/accept/$orderId");
    return json.decode(response.body);
  }

  // get RejectApi order
  static Future<Map<String, dynamic>> orderRejectApi(orderId) async {
    final response = await client
        .put(Constants.baseURL + "orders/delivery-boy/reject/$orderId");
    return json.decode(response.body);
  }
}
