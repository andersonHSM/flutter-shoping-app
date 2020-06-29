import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/exceptions/http_exception.dart';

import 'package:shopping_app/providers/product.dart';

class Products with ChangeNotifier {
  final _baseUrl = 'https://flutter-shop-2a75f.firebaseio.com/products';
  List<Product> _items = [];

  List<Product> get items => [..._items];

  int get itemsCount => _items.length;

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAllProducts() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);
    if (data == null || data.isEmpty) {
      return;
    }
    _items.clear();

    data.forEach((prodId, product) {
      _items.add(Product(
        description: product['description'],
        imageUrl: product['imageUrl'],
        price: product['price'],
        title: product['title'],
        isFavorite: product['isFavorite'],
        id: prodId,
      ));
    });

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var response = await http.post("$_baseUrl.json",
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
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

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index < 0) {
      return;
    }

    await http.patch("$_baseUrl/${product.id}.json",
        body: json.encode({
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'title': product.title,
        }));
    _items[index] = product;

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final int index = _items.indexWhere((prod) => prod.id == id);

    if (index < 0) {
      return;
    }

    final product = _items[index];
    _items.remove(product);
    notifyListeners();

    final response = await http.delete("$_baseUrl/${product.id}.json");

    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException(
        'Ocorreu um erro na exclusão do produto.',
      );
    }
  }
}
