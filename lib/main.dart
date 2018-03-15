import 'package:flutter/material.dart';
import 'style/style.dart';
import 'page/home.dart';
import 'page/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Home(),
      theme: new ThemeData(
        primaryColor: Style.primaryColor,
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new Login(),
      },
    );
  }
}
