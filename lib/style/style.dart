import 'package:flutter/material.dart';

class Style {
  static final fontSize = 15.0;
  static final primaryColor = const Color(0xFF3190e8);
  static final backgroundColor = const Color(0xFFFFFFFF);
  static final emptyBackgroundColor = const Color(0xFFF5F5F5);
  static final borderColor = const Color(0xFFE4E4E4);
  static final gPadding =  16.0;
  static final textStyle = new TextStyle(
    color: const Color(0xFF333333),
    fontSize: fontSize,
  );

  static BoxDecoration testDecoration(Color color) {
    return new BoxDecoration(
      border: new Border.all(color: color),
    );
  }
}