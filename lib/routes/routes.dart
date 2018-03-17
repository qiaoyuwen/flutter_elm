import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../page/login.dart';
import '../page/city.dart';

class Routes {
  static final router = new Router();

  static void configureRoutes() {
    router.define('/login', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Login();
      },
    ));
    router.define('/city/:id/:name', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new City(
          int.parse(params['id'][0]),
          params['name'][0],
        );
      },
    ));
  }
}