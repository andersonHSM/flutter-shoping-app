import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';

import 'package:shopping_app/widgets/product_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == FilterOptions.Favorite) {
                _products.showFavoriteOnly();
              } else {
                _products.showAll();
              }
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('Somente Favoritos'),
                  value: FilterOptions.Favorite,
                ),
                PopupMenuItem(
                  child: Text('Todos'),
                  value: FilterOptions.All,
                )
              ];
            },
          )
        ],
      ),
      body: ProductGrid(),
    );
  }
}
