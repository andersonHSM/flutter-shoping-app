import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/exceptions/http_exception.dart';

import 'package:shopping_app/providers/product.dart';

class Products with ChangeNotifier {
  String _token;
  String _userId;
  final _baseUrl = 'https://flutter-shop-2a75f.firebaseio.com/';
  List<Product> _items = [];

  Products(this._token, this._userId, this._items);

  List<Product> get items => [..._items];

  int get itemsCount => _items.length;

  List<Product> get favoriteItems {
    //http.get("$_baseUrl/");
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAllProducts() async {
    final response = await http.get("$_baseUrl/products.json?auth=$_token");
    final favResponse = await http.get(
        "https://flutter-shop-2a75f.firebaseio.com/userFavorites/$_userId.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);
    final Map<String, dynamic> favMap = json.decode(favResponse.body);

    if (data == null || data.isEmpty) {
      return;
    }
    _items.clear();

    data.forEach((prodId, product) {
      final isFavorite = favMap == null ? false : favMap[prodId] ?? false;

      _items.add(Product(
        description: product['description'],
        imageUrl: product['imageUrl'],
        price: product['price'],
        title: product['title'],
        isFavorite: isFavorite,
        id: prodId,
      ));
    });

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var response = await http.post("$_baseUrl/products.json?auth=$_token",
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
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

    await http.patch("$_baseUrl/products/${product.id}.json?auth=$_token",
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

    final response =
        await http.delete("$_baseUrl/products/${product.id}.json?auth=$_token");

    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException(
        'Ocorreu um erro na exclusão do produto.',
      );
    }
  }
}
