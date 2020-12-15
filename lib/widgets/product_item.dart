import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
//    final productData= Provider.of<ProviderProducts>(context).findById(productId);
    final product= Provider.of<Product>(context);
    final cart= Provider.of<Cart>(context, listen: false);
    final authData= Provider.of<Auth>(context, listen: false);
    final scaffold= Scaffold.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed("/product-detail", arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage("assets/images/product-placeholder.png"),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: () async{
              try{
                await product.toggleFavourite(authData.token, authData.userId);
              }catch(error){
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(SnackBar(
                  content: Text("Updating favourite failed", textAlign: TextAlign.center,),
                  duration: Duration(seconds: 2),
                  elevation: 5,
                  backgroundColor: Colors.black87,
                ));
              }
            },
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.red,
            onPressed: (){
              cart.addCartItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Item added to cart"),
                  backgroundColor: Colors.black87,
                  elevation: 3,
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    textColor: Colors.white,
                    onPressed: (){
                      cart.removeSingleItem(product.id);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Item successfully removed from cart"),
                        backgroundColor: Colors.black87,
                        duration: Duration(seconds: 2),
                      ));
                    },
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
