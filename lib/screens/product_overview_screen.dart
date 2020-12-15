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
