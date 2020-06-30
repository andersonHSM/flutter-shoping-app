import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final _baseUrl = 'https://flutter-shop-2a75f.firebaseio.com/';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final response = await http.put(
        "$_baseUrl/userFavorites/$userId/${this.id}.json?auth=$token",
        body: json.encode(this.isFavorite),
      );
      notifyListeners();

      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
