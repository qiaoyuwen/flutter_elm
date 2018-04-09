import 'package:flutter/material.dart';
import '../style/style.dart';

class Button extends StatelessWidget {
  Button(
      {double width,
      double height,
      String text = '',
      GestureTapCallback onTap})
      : width = width,
        height = height,
        text = text,
        onTap = onTap;
  final double width;
  final double height;
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
          color: Style.primaryColor,
          borderRadius: new BorderRadius.all(
            new Radius.circular(5.0),
          ),
        ),
        child: new Center(
          child: new Text(
            text,
            style: new TextStyle(
              fontSize: 18.0,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
