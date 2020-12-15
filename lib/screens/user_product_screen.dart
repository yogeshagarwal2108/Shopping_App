import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/provider_products.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {

//  @override
//  void initState() {
//    Provider.of<ProviderProducts>(context, listen: false).fetchAndSetData(true);
//    super.initState();
//  }

//  @override
//  void didChangeDependencies() {
//    Provider.of<ProviderProducts>(context, listen: false).fetchAndSetData();
//    super.didChangeDependencies();
//  }

  Future<void> refreshScreen(BuildContext context) async{
    await Provider.of<ProviderProducts>(context, listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed("/edit-product");
            },
          ),
        ],
      ),
      drawer: AppDrawer(),

      body: FutureBuilder(
          future: refreshScreen(context),
          builder: (context, snapshotData) {
            if(snapshotData.connectionState== ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,));
            }
            else if(snapshotData.error != null){
              return Center(child: Text("error occurred!"),);
            }
            else{
              return RefreshIndicator(
                onRefresh: ()=> refreshScreen(context),
                color: Theme.of(context).primaryColor,
                child: Consumer<ProviderProducts>(
                  builder: (context, products, _)=> ListView.builder(
                    itemCount: products.items.length,
                    itemBuilder: (context, i)=> Column(
                      children: <Widget>[
                        UserProductItem(products.items[i].id, products.items[i].title, products.items[i].imageUrl),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
      ),
    );
  }
}






//import 'package:flutter/material.dart';
//import '../widgets/app_drawer.dart';
//import '../provider/provider_products.dart';
//import 'package:provider/provider.dart';
//import '../widgets/user_product_item.dart';
//
//class UserProductScreen extends StatelessWidget {
//
//  Future<void> _refreshScreen(BuildContext context) async{
//    await Provider.of<ProviderProducts>(context, listen: false).fetchAndSetData(true);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Your Products"),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: (){
//              Navigator.of(context).pushNamed("/edit-product");
//            },
//          )
//        ],
//      ),
//      drawer: AppDrawer(),
//      body: FutureBuilder(
//        future: _refreshScreen(context),
//        builder: (context, snapshotData){
//          if(snapshotData.connectionState== ConnectionState.waiting){
//            return Center(
//              child: CircularProgressIndicator(
//                backgroundColor: Theme.of(context).primaryColor,
//              )
//            );
//          }
//          else if(snapshotData.error!= null){
//            return Center(
//              child: Text("error occurred!"),
//            );
//          }
//          else{
//            return RefreshIndicator(
//              onRefresh: ()=> _refreshScreen(context),
//              color: Theme.of(context).primaryColor,
//              child: Consumer<ProviderProducts>(
//                builder: (context, product, _)=> ListView.builder(
//                  itemCount: product.items.length,
//                  itemBuilder: (context, i)=> Column(
//                    children: <Widget>[
//                      UserProductItem(product.items[i]),
//                      Divider(),
//                    ],
//                  ),
//                ),
//              ),
//            );
//          }
//        }
//      ),
//    );
//  }
//}
