import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String _userId;
  String _tokenId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth{
    return token!= null;
  }

  String get token{
    if(_expiryDate!= null && _expiryDate.isAfter(DateTime.now())){
      return _tokenId;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> authenticate(String email, String password, String urlSegment) async{
    final url= "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCiiSuQEHU6rd0OSzIQhgpsgh0mr8ECiI4";

    try{
      var response= await http.post(url, body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }));

      var responseData= json.decode(response.body);
      if(responseData["error"] != null){
        print(responseData["error"]["message"]);
        throw HttpException(responseData["error"]["message"]);
      }

      _tokenId= responseData["idToken"];
      _expiryDate= DateTime.now().add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _userId= responseData["localId"];
      autoLogout();
      notifyListeners();

      final sharedPrefs= await SharedPreferences.getInstance();
      var userData= json.encode({
        "tokenId": _tokenId,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });
      sharedPrefs.setString("userData", userData);
    }catch(error){
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async{
    return authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async{
    return authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async{
    final sharedPrefs= await SharedPreferences.getInstance();
    if(!sharedPrefs.containsKey("userData")){
      return false;
    }
    var extractedUserData= json.decode(sharedPrefs.getString("userData")) as Map<String, dynamic>;
    var expiryDate= DateTime.parse(extractedUserData["expiryDate"]);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _tokenId= extractedUserData["tokenId"];
    _userId= extractedUserData["userId"];
    _expiryDate= expiryDate;
    autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async{
    _tokenId= null;
    _userId= null;
    _expiryDate= null;
    if(_authTimer!= null){
      _authTimer.cancel();
      _authTimer= null;
    }
    final sharedPrefs= await SharedPreferences.getInstance();
//    sharedPrefs.remove("userData");
    sharedPrefs.clear();
    notifyListeners();
  }

  void autoLogout(){
    if(_authTimer!= null){
      _authTimer.cancel();
    }
    var timeToExpire= _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer= Timer(Duration(seconds: timeToExpire), logout);
    notifyListeners();
  }
}







//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:convert';
//import '../models/http_exception.dart';
//import 'dart:async';
//
//class Auth with ChangeNotifier{
//  String _tokenId;
//  String _userId;
//  DateTime _expiryDate;
//  Timer _authTimer;
//
//  bool isAuth(){
//    if(token!= null){
//      return true;
//    }
//    return false;
//  }
//
//  String get token{
//    if(_tokenId!= null && _expiryDate!= null && _expiryDate.isAfter(DateTime.now())){
//      return _tokenId;
//    }
//    return null;
//  }
//
//  String get userId{
//    return _userId;
//  }
//
//  Future<void> _authenticate(String email, String password, String urlSegment) async{
//    final url= "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCiiSuQEHU6rd0OSzIQhgpsgh0mr8ECiI4";
//
//    try{
//      final response= await http.post(url, body: json.encode({
//        "email": email,
//        "password": password,
//        "returnSecureToken": true,
//      }),);
//
//      if(json.decode(response.body)["error"]!= null){
//        throw HttpException(json.decode(response.body)["error"]["message"]);
//      }
//
//      _tokenId= json.decode(response.body)["idToken"];
//      _expiryDate= DateTime.now().add(Duration(seconds: int.parse(json.decode(response.body)["expiresIn"])));
//      _userId= json.decode(response.body)["localId"];
//      autoLogout();
//      notifyListeners();
//
//      var sharedPrefs= await SharedPreferences.getInstance();
//      String userData= json.encode({
//        "tokenId": _tokenId,
//        "userId": _userId,
//        "expiryDate": _expiryDate.toIso8601String(),
//      });
//      sharedPrefs.setString("userData", userData);
//    }catch(error){
//      print(error);
//      throw error;
//    }
//  }
//
//  Future<void> signUp(email, password) async{
//    return _authenticate(email, password, "signUp");
//  }
//
//  Future<void> login(email, password) async{
//    return _authenticate(email, password, "signInWithPassword");
//  }
//
//  Future<void> tryAutoLogin() async{
//    var sharedPrefs= await SharedPreferences.getInstance();
//    if(!sharedPrefs.containsKey("userData")){
//      return false;
//    }
//
//    var userData= json.decode(sharedPrefs.get("userData")) as Map<String, dynamic>;
//    var expiryDate= DateTime.parse(userData["expiryDate"]);
//    if(expiryDate.isBefore(DateTime.now())){
//      return false;
//    }
//    _tokenId= userData["tokenId"];
//    _userId= userData["userId"];
//    _expiryDate= expiryDate;
//    autoLogout();
//    notifyListeners();
//    return true;
//  }
//
//  Future<void> logout() async{
//    _tokenId= null;
//    _userId= null;
//    _expiryDate= null;
//    _authTimer.cancel();
//    _authTimer= null;
//    notifyListeners();
//    var sharedPrefs= await SharedPreferences.getInstance();
////    sharedPrefs.remove("userData");
//    sharedPrefs.clear();
//  }
//
//  void autoLogout(){
//    if(_authTimer!= null){
//      _authTimer.cancel();
//    }
//    var timeToExpire= _expiryDate.difference(DateTime.now()).inSeconds;
//    _authTimer= Timer(Duration(seconds: timeToExpire), logout);
//    notifyListeners();
//  }
//}
