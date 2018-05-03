import 'package:flutter/material.dart';
import '../style/style.dart';

class DropDown extends StatefulWidget {
  DropDown({
    String text,
    Color color,
    Decoration decoration,
  })  : text = text,
        color = color,
        decoration = decoration;
  final String text;
  final Color color;
  final Decoration decoration;

  @override
  createState() => new DropDownState();
}

class DropDownState extends State<DropDown> {
  final _gPadding = new EdgeInsets.symmetric(vertical: 10.0);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: _gPadding,
      color: widget.color,
      decoration: widget.decoration,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(widget.text),
          new Container(
            child: new Icon(
              Icons.arrow_drop_down,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }
}
