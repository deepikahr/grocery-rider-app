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
    final response = await client.put(
      Constants.baseURL + "orders/delivery-boy/accept/$orderId",
    );
    print("/orders/delivery-boy/accept/$orderId");
    return json.decode(response.body);
  }

  static Future<dynamic> orderStausChange(body) async {
    final response = await client.put(
      Constants.baseURL + "orders/delivery-boy/status/update",
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  // get delivered order list
  static Future<dynamic> getDeliverdOrder(limit, index) async {
    final response = await client.put(
      Constants.baseURL +
          "orders/delivery-boy/delivered/list?limit=$limit&page=$index",
    );
    print("/orders/delivery-boy/delivered/list?limit=$limit&page=$index");
    print(json.decode(response.body));

    return json.decode(response.body);
  }

  // get assigned order list
  static Future<dynamic> getAssignedOrder(limit, index) async {
    final response = await client.put(
      Constants.baseURL +
          "orders/delivery-boy/assigned/list?limit=$limit&page=$index",
    );
    print("orders/delivery-boy/assigned/list?limit=$limit&page=$index");
    print(json.decode(response.body));

    return json.decode(response.body);
  }

  // get orderAcceptOrRejectApi order
  static Future<Map<String, dynamic>> orderAcceptOrRejectApi(body) async {
    final response = await client.put(
      Constants.baseURL + "orders/accept-or-reject/delivery-boy",
      body: json.encode(body),
    );
    return json.decode(response.body);
  }
}
