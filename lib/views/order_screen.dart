import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos!'),
      ),
      body: ListView.builder(
          itemCount: _orders.itemsCount,
          itemBuilder: (ctx, index) {
            return OrderWidget(_orders.items[index]);
          }),
      drawer: AppDrawer(),
    );
  }
}
