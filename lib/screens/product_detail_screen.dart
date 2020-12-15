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
