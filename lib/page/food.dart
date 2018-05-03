import 'package:flutter/material.dart';
import '../components/head_bar.dart';
import '../style/style.dart';
import '../components/drop_down.dart';

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
      body: new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _buildSortContainer();
          }
        },
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  Widget _buildSortContainer() {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new DropDown(
            text: widget.title,
            color: Style.backgroundColor,
          ),
        ),
        new Expanded(
          child: new DropDown(
            text: '排序',
            decoration: new BoxDecoration(
              color: Style.backgroundColor,
              border: new Border(
                left: new BorderSide(color: Style.borderColor),
                right: new BorderSide(color: Style.borderColor),
              ),
            ),
          ),
        ),
        new Expanded(
          child: new DropDown(
            text: '筛选',
            color: Style.backgroundColor,
          ),
        ),
      ],
    );
  }
}
