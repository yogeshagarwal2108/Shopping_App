import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/order_screen.dart';
import '../provider/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 140,
            width: double.infinity,
            child: AppBar(
              title: Text("Hello Friends!!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                textAlign: TextAlign.justify,),
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
            onTap: (){
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
            onTap: (){
//              Navigator.of(context).pushReplacement(CustomRoute(
//                builder: (context)=> OrderScreen(),
//              ),);
              Navigator.of(context).pushReplacementNamed("/order-screen");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
            onTap: (){
              Navigator.of(context).pushReplacementNamed("/user-product");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
//              Navigator.of(context).pushReplacementNamed("/user-product");
            },
          ),
        ],
      ),
    );
  }
}






//import 'package:flutter/material.dart';
//import 'package:shop_app/screens/order_screen.dart';
//import 'package:shop_app/screens/user_product_screen.dart';
//import '../provider/auth.dart';
//import 'package:provider/provider.dart';
//import '../helpers/custom_route.dart';
//
//class AppDrawer extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Drawer(
//      child: Column(
//        children: <Widget>[
//          AppBar(
//            title: Text("Hello Friends"),
//            automaticallyImplyLeading: false,
//          ),
//          ListTile(
//            leading: Icon(Icons.shop),
//            title: Text("Shop"),
//            onTap: (){
//              Navigator.of(context).pushReplacementNamed("/");
//            },
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.payment),
//            title: Text("Orders"),
//            onTap: (){
//              Navigator.of(context).pushReplacementNamed("/order-screen");
//            },
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.edit),
//            title: Text("Manage Products"),
//            onTap: (){
//              Navigator.of(context).pushReplacementNamed("/user-product");
////              Navigator.of(context).pushReplacement(CustomRoute(
////                builder: (context)=> UserProductScreen(),
////              ));
//            },
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.exit_to_app),
//            title: Text("Logout"),
//            onTap: (){
//              Navigator.of(context).pop();
//              Navigator.of(context).pushReplacementNamed("/");
//              Provider.of<Auth>(context, listen: false).logout();
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}
