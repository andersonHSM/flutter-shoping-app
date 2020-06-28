import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/cart.dart';

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
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrder(List<CartItem> products, double total) {
    // final total = products.fold(0.0, (acc, product) {
    //   return acc + product.price * product.quantity;
    // });
    _items.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        totalPrice: total,
        products: products,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
