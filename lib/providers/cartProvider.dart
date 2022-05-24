import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItemToCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (cartItem) => CartItem(
              id: cartItem.id,
              price: price,
              quantity: cartItem.quantity + 1,
              title: title));
    } else {
      _items.putIfAbsent(
        productId,
        (() => CartItem(
            id: DateTime.now().toString(),
            price: price,
            quantity: 1,
            title: title)),
      );
    }
    notifyListeners();
  }

  int get getCountItemsCart {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void removeItemCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }

    if (_items[id]!.quantity > 1) {
      items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
