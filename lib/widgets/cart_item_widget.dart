import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem _cartItem;

  const CartItemWidget(this._cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(_cartItem.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            title: Text(_cartItem.title),
            subtitle: Text('R\$ ${_cartItem.price * _cartItem.quantity}'),
            trailing: Text('${_cartItem.quantity}x'),
            leading: CircleAvatar(
                child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('${_cartItem.price}'),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
