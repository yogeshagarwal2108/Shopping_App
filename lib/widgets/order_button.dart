import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../provider/order.dart';

class OrderButton extends StatefulWidget {
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return FlatButton(
        child: isLoading
            ? CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)
            : Text("Order Now", style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),
        onPressed: (cart.totalAmount<=0) ? null : () async {
//        Navigator.of(context).pushNamed("/order-screen");
          if (cart.totalAmount != 0.0) {
            setState(() {
              isLoading= true;
            });
            await Provider.of<Order>(context, listen: false).addOrders(cart.items.values.toList(), cart.totalAmount);
            cart.clear();
            setState(() {
              isLoading= false;
            });
          }
        }
    );
  }
}
