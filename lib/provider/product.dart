import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.description,
    this.isFavourite= false,
  });

  Future<void> toggleFavourite(String token, String userId) async{
    final url= "https://shop-app-acd16.firebaseio.com/userFavourites/$userId/$id.json?auth=$token";

    var oldFavourite= isFavourite;
    isFavourite= !isFavourite;
    notifyListeners();
    try{
      var response= await http.put(url, body: json.encode(
        isFavourite,
      ),);
      if(response.statusCode >= 400){
        isFavourite= oldFavourite;
        notifyListeners();
        throw "Could not set favourite";
      }
      else{
        oldFavourite= null;
      }
    }catch(error){
      isFavourite= oldFavourite;
      notifyListeners();
      throw "Could not set favourite";
    }
  }
}
