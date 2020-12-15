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
