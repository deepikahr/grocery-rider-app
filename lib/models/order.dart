import 'package:flutter/foundation.dart';

class OrderModel extends ChangeNotifier {
  List _orders;
  List _delieveredOrders;
  String _currency = 'Rs';

  List get orders => _orders;
  List get deliveredOrders => _delieveredOrders;
  int get lengthOfDeliveredOrders => _delieveredOrders.length;
  String get currency => _currency;

  void addOrders(dynamic order) {
    if (order is Map) {
      _orders.add(order);
    }
    if (order is List) {
      _orders = order;
    }
    notifyListeners();
  }

  void addDelieveredOrders(dynamic order) {
    if (order is Map) {
      _delieveredOrders.add(order);
    }
    if (order is List) {
      _delieveredOrders = order;
    }
    notifyListeners();
  }

  void updateOrder(Map order, index) {
    _orders[index] = order;
    notifyListeners();
  }

  void updateCurrency(String cur) {
    _currency = cur;
    notifyListeners();
  }
}
