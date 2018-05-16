import 'package:flutter/material.dart';
import '../style/style.dart';

class Button extends StatelessWidget {
  Button(
      {double width,
      double height,
      Widget text,
      Color bgColor,
      Decoration decoration,
      GestureTapCallback onTap})
      : width = width,
        height = height,
        text = text,
        decoration = decoration,
        onTap = onTap;
  final double width;
  final double height;
  final Widget text;
  final Decoration decoration;
  final GestureTapCallback onTap;

  final _defaultDecoration = new BoxDecoration(
    color: Style.primaryColor,
    borderRadius: new BorderRadius.all(
      new Radius.circular(5.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        width: width,
        height: height,
        decoration: decoration == null ? _defaultDecoration : decoration,
        child: new Center(
          child: text,
        ),
      ),
      onTap: onTap,
    );
  }
}
