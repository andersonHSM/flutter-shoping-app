import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';

import 'package:shopping_app/utils/app_routes.dart';
import 'package:shopping_app/views/product_detail_screen.dart';
import 'package:shopping_app/views/products_overview._screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductsProvider(),
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
