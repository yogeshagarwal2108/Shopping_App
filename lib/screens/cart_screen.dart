import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart' as c;
import '../widgets/cart_item.dart';
import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<c.Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),

      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(10),
                    label: Text("\$${cart.totalAmount.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).accentColor),),
                  ),
                  OrderButton(),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              itemCount: cart.items.length,
              itemBuilder: (context, i)=> CartItem(cart.items.keys.toList()[i], cart.items.values.toList()[i]),
            ),
          ),
        ],
      ),
    );
  }
}
