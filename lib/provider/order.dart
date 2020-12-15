import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem{
  final String id;
  final double totalPrice;
  final List<CartItem> cartItems;
  final DateTime date;

  OrderItem({this.id, this.totalPrice, this.cartItems, this.date});
}

class Order with ChangeNotifier{
  List<OrderItem> _orders= [];

  List<OrderItem> get orders{
    return [..._orders];
  }

  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orders);

  Future<void> addOrders(List<CartItem> cartProducts, double totalAmount) async{
    final url= "https://shop-app-acd16.firebaseio.com/orders/$userId.json?auth=$authToken";

    var response= await http.post(url, body: json.encode({
      "price": totalAmount,
      "date": DateTime.now().toIso8601String(),
      "products": cartProducts.map((prod)=> {
        "id": prod.id,
        "title": prod.title,
        "price": prod.price,
        "quantity": prod.quantity,
      }).toList(),
    }),);

    _orders.insert(0, OrderItem(id: json.decode(response.body)["name"], totalPrice: totalAmount, cartItems: cartProducts, date: DateTime.now()));
  }

  Future<void> fetchAndSetOrder() async{
    final url= "https://shop-app-acd16.firebaseio.com/orders/$userId.json?auth=$authToken";
    List<OrderItem> loadedOrder= [];

    var response= await http.get(url);
    var extractedData= (json.decode(response.body)) as Map<String, dynamic>;
    if(extractedData== null){
      return;
    }

    extractedData.forEach((orderId, orderData){
      loadedOrder.add(OrderItem(
        id: orderId,
        totalPrice: orderData["price"],
        date: DateTime.parse(orderData["date"]),
        cartItems: (orderData["products"] as List<dynamic>).map((item)=> CartItem(
          id: item["id"],
          title: item["title"],
          price: item["price"],
          quantity: item["quantity"],
        )).toList(),
      ));
    });

    _orders= loadedOrder.reversed.toList();
    notifyListeners();
  }
}





//import 'package:flutter/material.dart';
//import './cart.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//
//class OrderItem{
//  final String id;
//  final double totalAmount;
//  final List<CartItem> cartProducts;
//  final DateTime date;
//
//  OrderItem({
//    @required this.id,
//    @required this.cartProducts,
//    @required this.totalAmount,
//    @required this.date
//  });
//}
//
//class Order with ChangeNotifier{
//
//  List<OrderItem> _order= [];
//
//  List<OrderItem> get order{
//    return [..._order];
//  }
//
//  final String tokenId;
//  final String userId;
//  Order(this.tokenId, this.userId, this._order);
//
//  Future<void> addOrder(double totalAmount, List<CartItem> products) async{
//    var url= "https://shop-app-acd16.firebaseio.com/orders/$userId.json?auth=$tokenId";
//    var date= DateTime.now();
//
//    var response= await http.post(url, body: json.encode({
//      "amount": totalAmount,
//      "date": date.toIso8601String(),
//      "products": products.map((cartProd)=> {
//        "id": cartProd.id,
//        "title": cartProd.title,
//        "price": cartProd.price,
//        "quantity": cartProd.quantity,
//      }).toList(),
//    }),);
//
//    _order.insert(0, OrderItem(id: json.decode(response.body)["name"], cartProducts: products, totalAmount: totalAmount, date: date));
//  }
//
//  Future<void> fetchAndSetOrder() async{
//    var url= "https://shop-app-acd16.firebaseio.com/orders/$userId.json?auth=$tokenId";
//    var response= await http.get(url);
//    var extractedData= json.decode(response.body) as Map<String, dynamic>;
//    List<OrderItem> loadedOrder= [];
//
//    if(extractedData== null){
//      return;
//    }
//    extractedData.forEach((orderId, orderData){
//      loadedOrder.add(OrderItem(
//        id: orderId,
//        date: DateTime.parse(orderData["date"]),
//        totalAmount: orderData["amount"],
//        cartProducts: (orderData["products"] as List<dynamic>).map((item)=> CartItem(
//          id: item["id"],
//          title: item["title"],
//          price: item["price"],
//          quantity: item["quantity"],
//        )).toList(),
//      ));
//    });
//
//    _order= loadedOrder.reversed.toList();
//    notifyListeners();
//  }
//}
