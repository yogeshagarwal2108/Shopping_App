import 'package:flutter/material.dart';
import '../widgets/auth_card.dart';
import 'dart:math';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}






//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'dart:math';
//import '../widgets/auth_card.dart';
//
//class AuthScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final deviceSize= MediaQuery.of(context).size;
//
//    return Scaffold(
//      body: Stack(
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: [
//                  Color.fromRGBO(100, 43, 84, 1).withOpacity(0.4),
//                  Color.fromRGBO(50, 284, 34, 1).withOpacity(0.7),
//                ],
//                begin: Alignment.topLeft,
//                end: Alignment.bottomRight,
//                stops: [0,1],
//              ),
//            ),
//          ),
//
//          SingleChildScrollView(
//            child: Container(
//              width: deviceSize.width,
//              height: deviceSize.height,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    width: deviceSize.width * 0.9,
//                    decoration: BoxDecoration(
//                      shape: BoxShape.rectangle,
//                      borderRadius: BorderRadius.circular(20),
//                    color: Theme.of(context).primaryColor,
//                    ),
////                    constraints: BoxConstraints(
////                      minHeight: 200,
////                      minWidth: 300,
////                    ),
//                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                    transform: Matrix4.rotationZ(pi * 8 /180)..translate(3.0),
//                    child: Text("Shop",
//                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, letterSpacing: 1.4, fontFamily: "Anton"), textAlign: TextAlign.center,
//                    ),
//                  ),
//
//                  SizedBox(height: 60,),
//                  Flexible(
//                    flex: deviceSize.width > 600 ? 2 : 1,
//                    child: AuthCard(),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
