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





//import 'package:flutter/material.dart';
//import '../provider/order.dart';
//import '../provider/cart.dart';
//import 'package:provider/provider.dart';
//
//class OrderButton extends StatefulWidget {
//  @override
//  _OrderButtonState createState() => _OrderButtonState();
//}
//
//class _OrderButtonState extends State<OrderButton> {
//  var isLoading= false;
//
//  @override
//  Widget build(BuildContext context) {
//    final cart= Provider.of<Cart>(context);
//
//    return FlatButton(
//      child: isLoading
//          ? CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)
//          : Text("Order Now", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
////                    color: Theme.of(context).primaryColor,
//      onPressed: (cart.totalPrice <= 0 || isLoading) ? null : () async{
//        setState(() {
//          isLoading= true;
//        });
//        await Provider.of<Order>(context, listen: false).addOrder(cart.totalPrice, cart.items.values.toList());
//        cart.clear();
//        setState(() {
//          isLoading= false;
//        });
//      },
//      padding: EdgeInsets.all(10.0),
//    );
//  }
//}
