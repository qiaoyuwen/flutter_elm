import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../page/home.dart';
import '../page/login.dart';
import '../page/city.dart';
import '../page/msite.dart';
import '../page/search.dart';
import '../page/order.dart';
import '../page/profile.dart';
import '../page/food.dart';

class Routes {
  static final router = new Router();

  static void configureRoutes() {
    router.define('/home', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Home();
      },
    ));
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
    router.define('/search/:geohash', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Search(params['geohash'][0]);
      },
    ));
    router.define('/order', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Order();
      },
    ));
    router.define('/profile', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Profile();
      },
    ));
    router.define('/food/:categoryId/:title/:geohash', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return new Food(
          title: params['title'][0],
          restaurantCategoryId: params['categoryId'][0],
          geoHash: params['geohash'][0],
        );
      },
    ));
  }
}