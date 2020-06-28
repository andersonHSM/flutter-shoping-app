import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  ProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<Products>(context, listen: false);
    return ListTile(
      title: Text(_product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: _product,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Deseja remover o produto?',
                          textAlign: TextAlign.center),
                      actions: <Widget>[
                        Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              textColor: Theme.of(context).errorColor,
                              child: Text('Confirmar'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ).then(
                  (value) {
                    if (value) {
                      _products.deleteProduct(_product.id);
                    }
                  },
                );
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
