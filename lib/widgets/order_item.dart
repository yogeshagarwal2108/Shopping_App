import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../provider/order.dart' as o;

class OrderItem extends StatefulWidget {
  final o.OrderItem orderProducts;
  OrderItem(this.orderProducts);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin{
  bool expanded= false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
      height: expanded ? min(widget.orderProducts.cartItems.length * 20.0 + 10, 100) + 102 : 102,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("\$${widget.orderProducts.totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              subtitle: Text("${DateFormat("dd/MM/yyyy hh:mm").format(widget.orderProducts.date)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: (){
                  setState(() {
                    expanded= !expanded;
                  });
                },
              ),
            ),

            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: expanded ? min(widget.orderProducts.cartItems.length * 20.0 + 10, 180) : 0,
              child: ListView.builder(
                itemCount: widget.orderProducts.cartItems.length,
                itemBuilder: (context, i)=> Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.orderProducts.cartItems[i].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text("${widget.orderProducts.cartItems[i].quantity}x \$${widget.orderProducts.cartItems[i].price}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
