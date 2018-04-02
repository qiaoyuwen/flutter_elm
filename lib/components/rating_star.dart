import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  RatingStar(num rating) : _rating = rating;
  final num _rating;
  final Color _color = const Color(0xFFFF6000);
  final num _size = 13.0;

  @override
  Widget build(BuildContext context) {
    var starsRow = new Row(
      children: <Widget>[],
    );
    var starCount = _rating.floor();
    var halfCount = (_rating % 1).ceil();
    var emptyCount = 5 - starCount - halfCount;
    var iconList = [];
    for (var i = 0; i < starCount; i++) {
      iconList.add(Icons.star);
    }
    for (var i = 0; i < halfCount; i++) {
      iconList.add(Icons.star_half);
    }
    for (var i = 0; i < emptyCount; i++) {
      iconList.add(Icons.star_border);
    }
    for (var icon in iconList) {
      starsRow.children.add(
        new Icon(
          icon,
          size: _size,
          color: _color,
        )
      );
    }
    return new Row(
      children: <Widget>[
        starsRow,
        new Container(
          margin: new EdgeInsets.symmetric(horizontal: 5.0),
          child: new Text(
            _rating.toString(),
            style: new TextStyle(
              color: const Color(0xFFFF6000),
              fontSize: 13.0,
            ),
          ),
        ),
      ],
    );
  }
}
