import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider_products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold= Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
              onPressed: (){
                Navigator.of(context).pushNamed("/edit-product", arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor,),
              onPressed: () async{
                try{
                  await Provider.of<ProviderProducts>(context, listen: false).deleteProducts(id);
                }catch(error){
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(
                    content: Text("Deleting failed", textAlign: TextAlign.center,),
                    backgroundColor: Colors.black87,
                    elevation: 5,
                    duration: Duration(seconds: 2),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}





//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import '../provider/product.dart';
//import '../provider/provider_products.dart';
//import 'package:provider/provider.dart';
//
//class UserProductItem extends StatelessWidget {
//  final Product productItem;
//  UserProductItem(this.productItem);
//
//  @override
//  Widget build(BuildContext context) {
//    var scaffold= Scaffold.of(context);
//
//    return ListTile(
//      leading: CircleAvatar(
//        backgroundImage: NetworkImage(productItem.imageUrl),
//      ),
//      title: Text(productItem.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//      trailing: Container(
//        width: 100,
//        child: Row(
//          children: <Widget>[
//            IconButton(
//              icon: Icon(Icons.edit),
//              color: Theme.of(context).primaryColor,
//              onPressed: (){
//                Navigator.of(context).pushNamed("/edit-product", arguments: productItem.id);
//              },
//            ),
//            IconButton(
//              icon: Icon(Icons.delete),
//              color: Theme.of(context).errorColor,
//              onPressed: () async{
//                try{
//                  await Provider.of<ProviderProducts>(context, listen: false).deleteProduct(productItem.id);
//                }catch(error){
//                  scaffold.hideCurrentSnackBar();
//                  scaffold.showSnackBar(SnackBar(
//                    content: Text("Deleting failed!", textAlign: TextAlign.center,),
//                    backgroundColor: Colors.black87,
//                    duration: Duration(seconds: 2),
//                  ));
//                }
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
