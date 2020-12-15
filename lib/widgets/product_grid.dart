import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider_products.dart';
import './product_item.dart';
import '../provider/product.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourite;
  ProductGrid(this.showFavourite);

  @override
  Widget build(BuildContext context) {
    final products= showFavourite ? Provider.of<ProviderProducts>(context, listen: false).favourites : Provider.of<ProviderProducts>(context, listen: false).items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5/4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 10,
      ),

      itemCount: products.length,
      itemBuilder: (context, i)=> ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
    );
  }
}





//import 'package:flutter/material.dart';
//import '../widgets/product_item.dart';
//import '../provider/provider_products.dart';
//import 'package:provider/provider.dart';
//import '../provider/product.dart';
//
//class ProductGrid extends StatelessWidget {
//
//  final bool onlyFavourite;
//  ProductGrid(this.onlyFavourite);
//
//  @override
//  Widget build(BuildContext context) {
//
//    final productsData= Provider.of<ProviderProducts>(context);
//    final products= onlyFavourite ? productsData.favouriteItems : productsData.items;
//
//    return GridView.builder(
//      padding: EdgeInsets.all(10),
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 2,
//        childAspectRatio: 5/4,
//        mainAxisSpacing: 10,
//        crossAxisSpacing: 10,
//      ),
//
//      itemCount: products.length,
//      itemBuilder: (context, i)=> ChangeNotifierProvider.value(
//        value: products[i],
//        child: ProductItem(),
//      )
//    );
//  }
//}
