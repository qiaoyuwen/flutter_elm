import 'package:flutter/material.dart';
import '../components/head_bar.dart';
import '../style/style.dart';

class Food extends StatefulWidget {
  Food({
    String title,
    String geoHash,
    String restaurantCategoryId,
  })  : title = title,
        geoHash = geoHash,
        restaurantCategoryId = restaurantCategoryId;

  final String title;
  final String geoHash;
  final String restaurantCategoryId;

  @override
  createState() => new FoodState();
}

class FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: widget.title,
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new Container(),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}
