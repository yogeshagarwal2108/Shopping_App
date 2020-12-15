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






//import 'package:flutter/material.dart';
//import '../widgets/app_drawer.dart';
//import '../provider/order.dart' show Order;
//import 'package:provider/provider.dart';
//import '../widgets/order_item.dart';
//
//class OrderScreen extends StatefulWidget {
//
//  @override
//  _OrderScreenState createState() => _OrderScreenState();
//}
//
//class _OrderScreenState extends State<OrderScreen> {
//
//  //  @override
////  void initState() {
////    Future.delayed(Duration.zero).then((_) async{
////      setState(() {
////        isLoading= true;
////      });
////      await Provider.of<Order>(context, listen: false).fetchAndSetOrder();
////      setState(() {
////        isLoading= false;
////      });
////    });
////    super.initState();
////  }
//
////  @override
////  void initState() {
////    isLoading= true;
////    Provider.of<Order>(context, listen: false).fetchAndSetOrder().then((_){                ///// (listen:false)  is must to use here in this case.
////      setState(() {
////        isLoading= false;
////      });
////    });
////    super.initState();
////  }
//
////  bool isInit= true;
////  @override
////  void didChangeDependencies(){
////    if(isInit){
////      setState(() {
////        isLoading= true;
////      });
////      Provider.of<Order>(context, listen: false).fetchAndSetOrder().then((response){
////        setState(() {
////          isLoading= false;
////        });
////      });
////    }
////    isInit= false;
////    super.didChangeDependencies();
////  }
//
//
//  Future _orderFuture;
//  Future _obtainOrderFuture(){
//    return Provider.of<Order>(context, listen: false).fetchAndSetOrder();
//  }
//
//  @override
//  void initState() {
//    _orderFuture= _obtainOrderFuture();
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print("order building");
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Your Orders"),
//      ),
//
//      drawer: AppDrawer(),
//
//      body: FutureBuilder(future: _orderFuture, builder: (context, dataSnapshot){
//        if(dataSnapshot.connectionState== ConnectionState.waiting){
//          return Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,));
//        }
//        else if(dataSnapshot.error != null){
//          return Center(
//            child: Text("An error occurred"),
//          );
//        }
//        else{
//          return Consumer<Order>(
//            builder: (context, orderProducts, child)=> ListView.builder(
//              itemCount: orderProducts.order.length,
//              itemBuilder: (context, i)=> OrderItem(orderProducts.order[i]),
//            ),
//          );
//        }
//      },),
//    );
//  }
//}
