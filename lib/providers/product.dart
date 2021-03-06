import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/authProvider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> changeStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-crud-31d86-default-rtdb.firebaseio.com/userFavorites/${AuthProvider.userId}/$id.json?auth=$token';

    try {
      http.patch(Uri.parse(url),
          body: json.encode({
            'isFavorite': isFavorite,
            'title': title,
            'description': description,
            'price': price,
            'imageUrl': imageUrl
          }));
    } catch (e) {
      isFavorite=oldStatus;
      notifyListeners();
    }
  }
}
