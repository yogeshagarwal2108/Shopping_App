import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../provider/provider_products.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String productId= ModalRoute.of(context).settings.arguments as String;

    final product= Provider.of<ProviderProducts>(context).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
//            title: Text(product.title),
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                  tag: productId,
                  child: Image.network(product.imageUrl, width: double.infinity, height: 300, fit: BoxFit.cover,)
              ),
            ),
            pinned: true,
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(product.price.toString(), textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.3, color: Colors.grey),),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(product.description, style: TextStyle(letterSpacing: 0.2), textAlign: TextAlign.center, softWrap: false,),
              ),
              SizedBox(height: 800,),
            ]),
          ),
        ],
      ),
    );
  }
}






//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '../provider/provider_products.dart';
//
//class ProductDetailScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//
//    String productId= ModalRoute.of(context).settings.arguments as String;
//    final loadedProduct= Provider.of<ProviderProducts>(context).findById(productId);
//
//    return Scaffold(
////      appBar: AppBar(
////        title: Text(loadedProduct.title),
////      ),
//
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
//            expandedHeight: 300,
//            pinned: true,
//            flexibleSpace: FlexibleSpaceBar(
//              title: Text(loadedProduct.title),
//              background: Hero(
//                tag: productId,
//                child: Image.network(loadedProduct.imageUrl, width: double.infinity, fit: BoxFit.cover)
//              ),
//            ),
//          ),
//          SliverList(
//            delegate: SliverChildListDelegate([
//              SizedBox(height: 10,),
//              Text("\$${loadedProduct.price}", style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),
//              SizedBox(height: 10,),
//              Container(
//                child: Text(loadedProduct.description, style: TextStyle(fontSize: 15, letterSpacing: 0.2), textAlign: TextAlign.center, softWrap: true,),
//                width: double.infinity,
//              ),
//              SizedBox(height: 600,),
//            ]),
//          ),
//        ],
//      ),
//    );
//  }
//}
