import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _sendingBuyRequest = false;
  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);
    final _cartItems = _cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'R\$ ${_cart.cartTotalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: _cart.itemsCount > 0
                        ? () async {
                            setState(() {
                              _sendingBuyRequest = true;
                            });
                            try {
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(
                                _cartItems,
                                _cart.cartTotalPrice,
                              );
                              _cart.clear();
                              Navigator.of(context).pop();
                            } catch (error) {
                              print(error);
                              await showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text('Erro inesperado'),
                                      content: Text(
                                        "Por favor, tente novamente ou retorne mais tarde.",
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Retornar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } finally {
                              setState(() {
                                _sendingBuyRequest = false;
                              });
                            }
                          }
                        : null,
                    child: _sendingBuyRequest
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        : Text('Comprar'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.itemsCount,
              itemBuilder: (ctx, index) {
                return CartItemWidget(_cartItems[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
