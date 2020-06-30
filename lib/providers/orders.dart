import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double totalPrice;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.totalPrice,
    this.date,
    this.id,
    this.products,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = "https://flutter-shop-2a75f.firebaseio.com/orders";
  List<Order> _items = [];
  String _token;
  String _userId;

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Orders([this._token, this._userId, this._items = const []]);

  Future<void> fetchOrders() async {
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    final Map<String, dynamic> _data = json.decode(response.body);
    _items.clear();
    notifyListeners();

    if (_data == null) return;
    _data.forEach((orderId, order) {
      _items.add(
        Order(
            id: order['id'],
            date: DateTime.parse(order['date']),
            products: (order['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                price: item['price'],
                title: item['title'],
                quantity: item['quantity'],
                productId: item['productId'],
              );
            }).toList(),
            totalPrice: order['totalPrice']),
      );
    });
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    // final total = products.fold(0.0, (acc, product) {
    //   return acc + product.price * product.quantity;
    // });
    final date = DateTime.now();
    final response = await http.post(
      "$_baseUrl/$_userId.json?auth=$_token",
      body: json.encode(
        {
          'totalPrice': total,
          'products': products
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
          'date': date.toIso8601String()
        },
      ),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        totalPrice: total,
        products: products,
        date: date,
      ),
    );

    notifyListeners();
  }
}
