import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';
import '../provider/provider_products.dart';

enum popUpOptions{
  Favourites, All
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavourite= false;
  var isLoading= false;

  var isInit= true;
  @override
  void didChangeDependencies() {
    if(isInit){
      setState(() {
        isLoading= true;
      });
      Provider.of<ProviderProducts>(context, listen: false).fetchAndSetData().then((_){
        setState(() {
          isLoading= false;
        });
      });
    }
    isInit= false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),

        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (val){
              if(val== popUpOptions.Favourites){
                setState(() {
                  showFavourite= true;
                });
              }
              else{
                setState(() {
                  showFavourite= false;
                });
              }
            },

            itemBuilder: (context)=> [
              PopupMenuItem(
                child: Text("Only Favourites"),
                value: popUpOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("All Products"),
                value: popUpOptions.All,
              ),
            ],
          ),

          Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed("/cart-screen");
              },
            ),
            value: cart.items.length,
            color: Colors.orange,
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)) : ProductGrid(showFavourite),
    );
  }
}





//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '../widgets/app_drawer.dart';
//import '../widgets/product_grid.dart';
//import '../provider/provider_products.dart';
//import '../widgets/badge.dart';
//import '../provider/cart.dart';
//
//enum popUpOption{
//  Favorites, All,
//}
//
//class ProductOverviewScreen extends StatefulWidget {
//  @override
//  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
//}
//
//class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
//
//  bool onlyFavourite= false;
//  var isInit= true;
//  var isLoading= false;
//
//  @override
//  void didChangeDependencies() {
//    if(isInit){
//      setState(() {
//        isLoading= true;
//      });
//      Provider.of<ProviderProducts>(context).fetchAndSetData().then((_){
//        setState(() {
//          isLoading= false;
//        });
//      });
//    }
//    isInit= false;
//    super.didChangeDependencies();
//  }
//
//  @override
//  Widget build(BuildContext context){
//    final productContainer= Provider.of<ProviderProducts>(context);
//    final cart= Provider.of<Cart>(context);
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Product Overview"),
//        actions: <Widget>[
//          PopupMenuButton(
//            onSelected: (popUpOption val){
//              setState(() {
//                if(val== popUpOption.Favorites){
//                  onlyFavourite= true;
//                }
//                else{
//                  onlyFavourite= false;
//                }
//              });
//            },
//
//            icon: Icon(Icons.more_vert),
//            itemBuilder: (context)=> [
//              PopupMenuItem(
//                child: Text("Only Favorites"),
//                value: popUpOption.Favorites,
//              ),
//              PopupMenuItem(
//                child: Text("Show All"),
//                value: popUpOption.All,
//              ),
//            ],
//          ),
//
//          Consumer<Cart>(
//            builder: (context, cart, ch)=> Badge(
//              child: ch,
//              value: cart.itemCount.toString(),
//            ),
//
//            child: IconButton(
//              icon: Icon(Icons.shopping_cart),
//              onPressed: (){
//                Navigator.of(context).pushNamed("/cart-screen");
//              },
//            ),
//          )
//        ],
//      ),
//
//      drawer: AppDrawer(),
//
//      body: isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)) : ProductGrid(onlyFavourite),
//    );
//  }
//}
