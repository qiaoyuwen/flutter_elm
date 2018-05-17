import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  Shop(this.geoHash, this.shopId,);
  final String geoHash;
  final String shopId;

  @override
  State<StatefulWidget> createState() {
    return new ShopState();
  }
}

class ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}