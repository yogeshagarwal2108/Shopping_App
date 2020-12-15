import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity
  });
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _items= {};

  Map<String, CartItem> get items{
    return {..._items};
  }

  double get totalAmount{
    double total= 0.0;
    _items.forEach((key, product){
      total+= product.quantity * product.price;
    });
    return total;
  }

  void removeItem(productId){
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(productId){
    if(!_items.containsKey(productId)){
      return;
    }
    else{
      if(_items[productId].quantity > 1){
        _items.update(productId, (existingProduct)=> CartItem(
            id: existingProduct.id,
            title: existingProduct.title,
            price: existingProduct.price,
            quantity: existingProduct.quantity - 1),
        );
      }
      else{
        _items.remove(productId);
      }
    }

    notifyListeners();
  }

  void clear(){
    _items= {};
    notifyListeners();
  }

  void addCartItem(String productId, String title, double price){
    if(_items.containsKey(productId)){
      _items.update(productId, (existingProduct)=> CartItem(
          id: existingProduct.id,
          title: existingProduct.title,
          price: existingProduct.price,
          quantity: existingProduct.quantity+1)
      );
    }
    else{
      _items.putIfAbsent(productId, ()=> CartItem(id: DateTime.now().toString(), title: title, price: price, quantity: 1));
    }

    notifyListeners();
  }
}
