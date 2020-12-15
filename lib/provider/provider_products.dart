import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class ProviderProducts with ChangeNotifier{
  List<Product> _items= [];

  final String authToken;
  final String userId;
  ProviderProducts(this.authToken, this.userId, this._items);

  List<Product> get items{
    return [..._items];
  }

  List<Product> get favourites{
    return _items.where((product){
      return product.isFavourite;
    }).toList();
  }

  Product findById(productId){
    return _items.firstWhere((product)=> product.id== productId);
  }

  Future<void> fetchAndSetData([bool filterByUser= false]) async{                     ////// [] - for optional argument
    var filter= filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url= 'https://shop-app-acd16.firebaseio.com/products.json?auth=$authToken&$filter';
    final List<Product> loadedProduct= [];

    try{
      var response= await http.get(url);
      var extractedData= json.decode(response.body) as Map<String, dynamic>;

      if(extractedData== null){
        return;
      }

      url= "https://shop-app-acd16.firebaseio.com/userFavourites/$userId.json?auth=$authToken";
      response= await http.get(url);
      var favouriteResponse= json.decode(response.body) as Map<String, dynamic>;
//      print(json.decode(response.body));
      extractedData.forEach((prodId, prodData){
        loadedProduct.add(Product(
          id: prodId,
          title: prodData["title"],
          price: prodData["price"],
          description: prodData["description"],
          imageUrl: prodData["imageUrl"],
          isFavourite: favouriteResponse== null ? false : favouriteResponse[prodId] ?? false,   //or// favouriteResponse[prodId]== null ? false : favouriteResponse[prodId],
        ));
      });
      _items= loadedProduct;
      notifyListeners();
    }catch(error){
      print(error);
    }
  }

  Future<void> addProducts(Product product) async{
    final url= "https://shop-app-acd16.firebaseio.com/products.json?auth=$authToken";

    try{
      var response= await http.post(url, body: json.encode({
        "title": product.title,
        "price": product.price,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "creatorId": userId,
      }),);

      final newProduct= Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl
      );
      _items.add(newProduct);
      notifyListeners();
    }catch(error){
      print(error);
      throw HttpException("Could not add products");
    }
  }

  Future<void> updateProducts(String id, Product product) async{
    final productIndex= _items.indexWhere((prod){
      return prod.id== id;
    });
    if(productIndex >= 0){
      final url= "https://shop-app-acd16.firebaseio.com/products/$id.json?auth=$authToken";
      try{
        var response= await http.patch(url, body: json.encode({
          "title": product.title,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
        }),);
        print(json.decode(response.body));
      }catch(error){
        print(error);
      }

      _items[productIndex]= product;
      notifyListeners();
    }
    else{
      print("...");
    }
  }

  Future<void> deleteProducts(String id) async{
    final url= "https://shop-app-acd16.firebaseio.com/products/$id.json?auth=$authToken";

    var existingProductIndex= _items.indexWhere((product){
      return product.id== id;
    });
    var existingProduct= _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
//    _items.removeWhere((product){
//      return product.id== id;
//    });
    try{
      var response= await http.delete(url);
      if(response.statusCode >= 400){
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw "Could not delete product";
      }
      else{
        existingProduct= null;
      }
    }catch(error){
      throw error;
    }
  }
}
