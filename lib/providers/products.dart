import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_app/providers/product.dart';

import 'package:shopping_app/data/DUMMY_DATA.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  int get itemsCount => _items.length;

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-shop-2a75f.firebaseio.com/products.json';
    var response = await http.post(url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.price,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ));

    String id = json.decode(response.body)['name'];
    _items.add(Product(
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      title: product.title,
      id: id,
    ));

    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index < 0) {
      return;
    }

    _items[index] = product;

    notifyListeners();
  }

  void deleteProduct(String id) {
    final int index = _items.indexWhere((prod) => prod.id == id);

    if (index < 0) {
      return;
    }
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}

// List<Product> get items {
//   if (_showFavoriteOnly) {
//     return _items.where((product) => product.isFavorite).toList();
//   }

//   return [..._items];
// }

// bool _showFavoriteOnly = false;
// void showFavoriteOnly() {
//   _showFavoriteOnly = true;
//   notifyListeners();
// }

// void showAll() {
//   _showFavoriteOnly = false;
//   notifyListeners();
// }
// }
