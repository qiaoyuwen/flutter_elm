import 'package:flutter/material.dart';
import '../style/style.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    String title,
    String content,
  })  : title = title,
        content = content;

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(
        title,
        style: Style.textStyle,
      ),
      content: new Text(
        content,
        style: Style.textStyle,
      ),
      actions: <Widget>[],
    );
  }
}
