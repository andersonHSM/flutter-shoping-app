import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/utils/app_routes.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/product_item.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _products.itemsCount,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ProductItem(_products.items[index]),
                Divider(),
              ],
            );
          },
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
