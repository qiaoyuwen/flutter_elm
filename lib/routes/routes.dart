import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../page/login.dart';
import '../page/city.dart';
import '../page/msite.dart';

class Routes {
  static final router = new Router();

  static void configureRoutes() {
    router.define('/login', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Login();
      },
    ));
    router.define('/city/:id', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new CityPage(int.parse(params['id'][0]));
      },
    ));
    router.define('/msite/:geohash', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        var splits = params['geohash'][0].split(',');
        return new MSite(num.parse(splits[0]), num.parse(splits[1]));
      },
    ));
  }
}