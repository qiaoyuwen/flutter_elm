import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../utils/api.dart';
import '../model/menu.dart';
import '../model/rating.dart';
import '../model/rating_score.dart';
import '../model/rating_tag.dart';

class Shop extends StatefulWidget {
  Shop({
    this.shopId,
    this.latitude,
    this.longitude,
  }) : geoHash = '$longitude,$latitude';
  final String shopId;
  final num latitude;
  final num longitude;
  final String geoHash;

  @override
  State<StatefulWidget> createState() {
    return new ShopState();
  }
}

class ShopState extends State<Shop> {

  Restaurant _restaurant;
  List<Menu> _menus;
  List<Rating> _ratings;
  int _ratingOffset = 0;
  RatingScore _ratingScore;
  List<RatingTag> _ratingTags;

  @override
  void initState() {
    super.initState();
    getShop();
    getMenus();
    getRatings();
    getRatingScore();
    getRatingTags();
  }

  getShop() async {
    Restaurant restaurant = await Api.getShopById(
      shopId: widget.shopId,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
    setState(() {
      _restaurant = restaurant;
    });
  }

  getMenus() async {
    List<Menu> menus = await Api.getMenus(widget.shopId);
    setState(() {
      _menus = menus;
    });
  }

  getRatings() async {
    List<Rating> ratings = await Api.getRatings(
      shopId: widget.shopId,
      offset: _ratingOffset,
    );
    setState(() {
      _ratings = ratings;
    });
  }

  getRatingScore() async {
    RatingScore ratingScore = await Api.getRatingScore(widget.shopId);
    setState(() {
      _ratingScore = ratingScore;
    });
  }

  getRatingTags() async {
    List<RatingTag> ratingTags = await Api.getRatingTags(widget.shopId);
    print(ratingTags);
    setState(() {
      _ratingTags = ratingTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_restaurant == null) {
      return new Container();
    }
    return new Stack(
      children: <Widget>[
        new Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          child: new Container(),
        ),
      ],
    );
  }
}