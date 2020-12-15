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
