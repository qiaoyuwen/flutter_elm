import 'package:flutter/material.dart';
import 'style/style.dart';
import 'page/home.dart';
import 'routes/routes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    //配置路由
    Routes.configureRoutes();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Home(),
      theme: new ThemeData(
        primaryColor: Style.primaryColor,
      ),
    );
  }
}
