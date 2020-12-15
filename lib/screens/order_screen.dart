import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Order;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final orderProducts= Provider.of<Order>(context);
    print("building");
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),

        body: FutureBuilder(
            future: Provider.of<Order>(context, listen: false).fetchAndSetOrder(),
            builder: (context, dataSnapshot){
              if(dataSnapshot.connectionState== ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,));
              }
              else if(dataSnapshot.error != null){
                return Center(
                  child: Text("error occurred!"),
                );
              }
              else{
                return Consumer<Order>(
                  builder: (context, orderProducts, child)=> ListView.builder(
                    itemCount: orderProducts.orders.length,
                    itemBuilder: (context, i)=> OrderItem(orderProducts.orders[i]),
                  ),
                );
              }
            }
        )
    );
  }
}
