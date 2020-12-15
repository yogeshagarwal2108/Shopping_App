import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../provider/cart.dart' as c;
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {

  final String productId;
  final c.CartItem cart;
  CartItem(this.productId, this.cart);

  @override
  Widget build(BuildContext context) {
    final cartItem= Provider.of<c.Cart>(context);

    return Dismissible(
      key: ValueKey(productId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 30),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),

      onDismissed: (dismiss){
        cartItem.removeItem(productId);
      },

      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (context)=> AlertDialog(
            title: Text("Are you sure!", style: TextStyle(fontWeight: FontWeight.bold),),
            content: Text("Do you really want to remove cart item?"),
            elevation: 5,
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },

      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: Text("\$${cart.price}", style: TextStyle(color: Theme.of(context).accentColor),)
              ),
            ),
          ),
          title: Text(cart.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          subtitle: Text("Total: \$${(cart.price * cart.quantity).toStringAsFixed(2)}", style: TextStyle(fontSize: 16),),
          trailing: Text("${cart.quantity} x"),
        ),
      ),
    );
  }
}
