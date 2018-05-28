import 'package:flutter/material.dart';
import '../style/style.dart';

typedef void OnTopCallback(String result);

class AlphabetBar extends StatelessWidget {
  AlphabetBar({
    Key key,
    this.onTap,
  }) : super(key: key);
  final OnTopCallback onTap;
  final _letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  final _textStyle = new TextStyle(
    color: Style.primaryColor,
    fontSize: 12.0,
  );
  final _padding = new EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0);

  @override
  build(BuildContext context) {
    var column = new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );
    for (var letter in _letters) {
      column.children.add(
        new GestureDetector(
          child: new Padding(
            padding: _padding,
            child: new Text(
              letter,
              style: _textStyle,
            ),
          ),
          onTap: () => onTap(letter),
        )
      );
    }
    return column;
  }
}