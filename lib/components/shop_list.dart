import 'dart:async';

import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../components/shop_item.dart';
import '../style/style.dart';
import '../utils/api.dart';

class ShopList extends StatefulWidget {
  ShopList(num longitude, num latitude, String restaurantCategoryId,
      {String restaurantCategoryIds = '', String sortByType = '', String deliveryMode = '', List<int> supportsIds = const []})
      : longitude = longitude,
        latitude = latitude,
        geoHash = '$longitude,$latitude',
        restaurantCategoryId = restaurantCategoryId,
        restaurantCategoryIds = restaurantCategoryIds,
        sortByType = sortByType,
        deliveryMode = deliveryMode,
        supportsIds = supportsIds,
        assert(longitude != null),
        assert(latitude != null);

  final num longitude;
  final num latitude;
  final String geoHash;
  final String restaurantCategoryId;
  final String restaurantCategoryIds;
  final String sortByType;
  final String deliveryMode;
  final List<int> supportsIds;

  @override
  State<StatefulWidget> createState() {
    return new ShopListState();
  }
}

class ShopListState extends State<ShopList> {
  final _restaurantLimit = 10;

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  bool _loadingFinish = false;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    getRestaurants();
  }

  @override
  void didUpdateWidget(ShopList old) {
    super.didUpdateWidget(old);
    _restaurants = [];
    _offset = 0;
    getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    var itemCount = _restaurants.length;
    if (_loadingFinish) {
      itemCount += 1;
    }
    return new ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, i) {
          if (_loadingFinish && i == itemCount - 1) {
            return new Container(
              height: 50.0,
              color: Style.backgroundColor,
              child: new Center(
                child: new Text(
                  '没有更多了',
                  style: Style.textStyle,
                ),
              ),
            );
          } else {
            if (!_loadingFinish &&
                !_isLoading &&
                i >= _restaurants.length - 2) {
              _offset += _restaurantLimit;
              getRestaurants();
            }
            return new ShopItem(_restaurants[i]);
          }
        });
  }

  getRestaurants() async {
    _isLoading = true;
    List<Restaurant> restaurants = await Api.getRestaurants(
      widget.latitude,
      widget.longitude,
      _offset,
      limit: _restaurantLimit,
      restaurantCategoryId: widget.restaurantCategoryId,
      restaurantCategoryIds: widget.restaurantCategoryIds,
      orderBy: widget.sortByType,
      deliveryMode: widget.deliveryMode,
      supportIds: widget.supportsIds,
    );
    if (restaurants.length < _restaurantLimit) {
      _loadingFinish = true;
    }
    setState(() {
      _restaurants.addAll(restaurants);
    });
    _isLoading = false;
  }
}
