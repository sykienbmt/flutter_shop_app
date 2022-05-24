import 'package:flutter/material.dart';
import 'package:shop_app/providers/cartProvider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  void addOrder(List<CartItem> listItem, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: listItem,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeItemOrders(String productId){
    _orders.remove(productId);
    notifyListeners();
  }

  void clear(){
    _orders=[];
    notifyListeners();
  }
}
