import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/order_widget.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<void> _fetchOrder() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos!'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchOrder,
        child: ListView.builder(
            itemCount: _orders.itemsCount,
            itemBuilder: (ctx, index) {
              return OrderWidget(_orders.items[index]);
            }),
      ),
      drawer: AppDrawer(),
    );
  }
}
