import 'package:flutter/foundation.dart';

class OrderModel extends ChangeNotifier {
  List _orders = [];

  int get ordersLength => _orders.length;
  List get orders => _orders;

  void addOrders(dynamic order) {
    if (order is Map) {
      _orders.add(order);
    }
    if (order is List) {
      _orders = order;
    }
    notifyListeners();
  }

  void add(Map order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrder(Map order, index) {
    _orders[index] = order;
    notifyListeners();
  }

  void removeAll() {
    _orders.clear();
    notifyListeners();
  }
}
