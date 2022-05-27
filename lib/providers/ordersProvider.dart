import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/authProvider.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:http/http.dart' as http;

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

  // final String authToken;

  // OrdersProvider(this.authToken,this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-crud-31d86-default-rtdb.firebaseio.com/orders.json?auth=${AuthProvider.token}';

    try {
      final response = await http.get(Uri.parse(url));
      List<OrderItem> loaderOrders = [];

      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((orderId, orderData) {
        loaderOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList()));
      });

      _orders = loaderOrders;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> listItem, double total) async {
    final url =
        'https://flutter-crud-31d86-default-rtdb.firebaseio.com/orders.json?auth=${AuthProvider.token}';

    final timeStamp = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': listItem
              .map((item) => {
                    'id': item.id,
                    'title': item.title,
                    'quantity': item.quantity,
                    'price': item.price
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: listItem,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeItemOrders(String productId) {
    _orders.remove(productId);
    notifyListeners();
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
