import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class ProviderProducts with ChangeNotifier{
  List<Product> _items= [
//  Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

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

  Future<void> fetchAndSetData([bool filterByUser= false]) async{                     ///////////////// [] - for optional argument
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







//import 'package:flutter/material.dart';
//import './product.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//import '../models/http_exception.dart';
//
//class ProviderProducts with ChangeNotifier{
//  List<Product> _items= [
////    Product(
////      id: 'p1',
////      title: 'Red Shirt',
////      description: 'A red shirt - it is pretty red!',
////      price: 29.99,
////      imageUrl:
////      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
////    ),
////    Product(
////      id: 'p2',
////      title: 'Trousers',
////      description: 'A nice pair of trousers.',
////      price: 59.99,
////      imageUrl:
////      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
////    ),
////    Product(
////      id: 'p3',
////      title: 'Yellow Scarf',
////      description: 'Warm and cozy - exactly what you need for the winter.',
////      price: 19.99,
////      imageUrl:
////      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
////    ),
////    Product(
////      id: 'p4',
////      title: 'A Pan',
////      description: 'Prepare any meal you want.',
////      price: 49.99,
////      imageUrl:
////      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
////    ),
//  ];
//
//
//  bool _showFavouriteOnly= false;
//
//  List<Product> get items{
//    return [..._items];
//  }
//
//  List<Product> get favouriteItems{
//    return _items.where((prodItem){
//      return prodItem.isFavorite;
//    }).toList();
//  }
//
////  onlyFavourite(){
////    _showFavouriteOnly= true;
////    notifyListeners();
////  }
////  all(){
////    _showFavouriteOnly= false;
////    notifyListeners();
////  }
//
//  final String tokenId;
//  final String userId;
//  ProviderProducts(this.tokenId, this.userId, this._items);
//
//  Product findById(id){
//    return items.firstWhere((product){
//      return product.id== id;
//    });
//  }
//
//  Future<void> fetchAndSetData([bool filterByUser= false]) async{
//    var filterString= filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
//    var url= 'https://shop-app-acd16.firebaseio.com/products.json?auth=$tokenId&$filterString';
//    final List<Product> loadedProduct= [];
//
//    try{
//      var response= await http.get(url);
//      var extractedData= json.decode(response.body) as Map<String, dynamic>;
//
//      if(extractedData== null){
//        return;
//      }
//
//      url= 'https://shop-app-acd16.firebaseio.com/userFavourites/$userId.json?auth=$tokenId';
//      response= await http.get(url);
//      var extractedUserFavourites= json.decode(response.body) as Map<String, dynamic>;
//
//      extractedData.forEach((prodId, prodData){
//        loadedProduct.add(Product(
//          id: prodId,
//          title: prodData["title"],
//          price: prodData["price"],
//          description: prodData["description"],
//          imageUrl: prodData["imageUrl"],
//          isFavorite: extractedUserFavourites== null ? false : extractedUserFavourites[prodId] ?? false,
//        ));
//      });
//      _items= loadedProduct;
//      notifyListeners();
//    }catch(error){
//      print(error);
//    }
//  }
//
//  Future<void> addProduct(Product product) async{
//    final url= "https://shop-app-acd16.firebaseio.com/products.json?auth=$tokenId";
//    try{
//      var response= await http.post(url, body: json.encode({
//        "title": product.title,
//        "price": product.price,
//        "description": product.description,
//        "imageUrl": product.imageUrl,
//        "creatorId": userId,
//      }),);
//      final newProduct= Product(
//        id: json.decode(response.body)["name"],
//        title: product.title,
//        price: product.price,
//        description: product.description,
//        imageUrl: product.imageUrl,
//      );
//      _items.add(newProduct);
//      notifyListeners();
//    }catch(error){
//      print("error: $error");
//      throw error;
//    }
//  }
//
//  Future<void> updateProduct(Product product, String productId) async{
//    final productIndex= _items.indexWhere((prod){
//      return prod.id== productId;
//    });
//    if(productIndex>=0){
//      final url= "https://shop-app-acd16.firebaseio.com/products/$productId.json?auth=$tokenId";
//      await http.patch(url, body: json.encode({
//        "title": product.title,
//        "price": product.price,
//        "description": product.description,
//        "imageUrl": product.imageUrl,
//      }),);
//      _items[productIndex]= product;
//      notifyListeners();
//    }
//    else{
//      print("...");
//    }
//  }
//  Future<void> deleteProduct(String productId) async{
//    final url= "https://shop-app-acd16.firebaseio.com/products/$productId.json?auth=$tokenId";
//    var existingProductIndex= _items.indexWhere((prod){
//      return prod.id== productId;
//    });
//    var existingProduct= _items[existingProductIndex];
//
//    _items.removeAt(existingProductIndex);
//    notifyListeners();
//    var response= await http.delete(url);
//      if(response.statusCode >= 400){
//        _items.insert(existingProductIndex, existingProduct);
//        notifyListeners();
//        throw HttpException("Could not delete product.");       ///throw "Could not delete product.";
//      }
//      else{
//        existingProduct= null;
//      }
//      //    notifyListeners();
//  }
//}


