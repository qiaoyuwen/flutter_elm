import 'package:flutter/material.dart';
import '../style/style.dart';

class UiUtils {
  static AlertDialog getSimpleAlert(String title, String content) {
    return new AlertDialog(
      title: new Text(
        title,
        style: Style.textStyle,
      ),
      content: new Text(
        content,
        style: Style.textStyle,
      ),
      actions: <Widget>[

      ],
    );
  }
}