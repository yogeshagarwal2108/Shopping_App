import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final Color color;
  final int value;
  Badge({this.child, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          top: 7,
          right: 7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color!= null ? color : Theme.of(context).primaryColor,
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            padding: EdgeInsets.all(2),
            child: Text("$value", textAlign: TextAlign.center,),
          ),
        ),
      ],
    );
  }
}





//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//
//class Badge extends StatelessWidget {
//
//  final Widget child;
//  final String value;
//  final Color color;
//
//  Badge({Key key, @required this.child, @required this.value, this.color}): super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    print("value : "+value.toString());
//
//    return Stack(
//      alignment: Alignment.center,
//      children: <Widget>[
//        child,
//        Positioned(
//          right: 8,
//          top: 8,
//          child: Container(
//            padding: EdgeInsets.all(2),
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(10),
//              color: color!= null ? color : Theme.of(context).primaryColor,
//            ),
//            constraints: BoxConstraints(
//              minHeight: 15,
//              minWidth: 15,
//            ),
//            child: Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
//          ),
//        ),
//      ],
//    );
//  }
//}
