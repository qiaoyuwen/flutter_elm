import 'package:flutter/material.dart';
import 'dart:convert';
import '../style/style.dart';
import '../components/carousel.dart';
import '../model/food_type.dart';
import '../model/place.dart';
import '../utils/api.dart';
import '../config/config.dart';
import '../model/restaurant.dart';
import '../components/shop_item.dart';
import '../components/foot_bar.dart';
import '../components/head_bar.dart';
import '../routes/routes.dart';

class MSite extends StatefulWidget {
  MSite(num longitude, num latitude)
      : longitude = longitude,
        latitude = latitude,
        geoHash = '$longitude,$latitude',
        assert(longitude != null),
        assert(latitude != null);

  final num longitude;
  final num latitude;
  final String geoHash;

  @override
  createState() => new MSiteState();
}

class MSiteState extends State<MSite> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding);
  final _gMargin = new EdgeInsets.only(bottom: 10.0);
  final _restaurantLimit = 10;

  Place _place;
  List<FoodType> _foodTypes = [];
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  bool _loadingFinish = false;
  int _offset = 0;
  final _foodTypePageSize = 8;

  @override
  void initState() {
    super.initState();
    getPlace();
    getFoodTypes();
    getRestaurants();
  }

  getPlace() async {
    Place place = await Api.getPlace(widget.geoHash);
    setState(() {
      _place = place;
    });
  }

  getFoodTypes() async {
    List<FoodType> foodTypes = await Api.getFoodTypes(widget.geoHash);
    setState(() {
      _foodTypes = foodTypes;
    });
  }

  getRestaurants() async {
    print('loading restaurants');
    _isLoading = true;
    List<Restaurant> restaurants = await Api.getRestaurants(
        widget.latitude, widget.longitude, _offset,
        limit: _restaurantLimit);
    if (restaurants.length < _restaurantLimit) {
      _loadingFinish = true;
    }
    setState(() {
      _restaurants.addAll(restaurants);
    });
    print('loading finish');
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: _place != null ? _place.name : '',
        leadingType: HeadBarLeadingType.search,
        titleOnTap: _goHome,
      ),
      body: _buildBody(),
      bottomNavigationBar: new FootBar(
        currentIndex: 0,
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  _goHome() {
    Routes.router.navigateTo(context, '/home');
  }

  Widget _buildBody() {
    var itemCount = 2 + _restaurants.length;
    if (_loadingFinish) {
      itemCount += 1;
    }
    return new ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i == 0) {
          return new Container(
            margin: _gMargin,
            child: new Carousel(
              height: 200.0,
              pages: _buildFoodTypePages(),
              autoPlay: false,
            ),
          );
        } else if (i == 1) {
          return new Container(
            height: 40.0,
            padding: _gPadding,
            decoration: new BoxDecoration(
              color: Style.backgroundColor,
              border: new Border(
                top: new BorderSide(
                  color: Style.borderColor,
                ),
              ),
            ),
            child: new Row(
              children: <Widget>[
                new Text(
                  '附近商家',
                  style: Style.textStyle,
                ),
              ],
            ),
          );
        } else if (_loadingFinish && i == itemCount - 1) {
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
          if (!_loadingFinish && !_isLoading && i >= _restaurants.length - 2) {
            _offset += _restaurantLimit;
            getRestaurants();
          }
          return new ShopItem(_restaurants[i - 2]);
        }
      },
    );
  }

  List<Widget> _buildFoodTypePages() {
    var pages = <Widget>[];
    for (var i = 0; i < _foodTypes.length; i += _foodTypePageSize) {
      int start = i;
      int end = i + _foodTypePageSize;
      end = end < _foodTypes.length ? end : _foodTypes.length;
      var page = _buildFoodTypePage(_foodTypes.sublist(start, end));
      pages.add(page);
    }

    return pages;
  }

  Widget _buildFoodTypePage(List<FoodType> foodTypes) {
    var columnChildren = <Widget>[];
    Row lastRow;
    for (var i = 0; i < foodTypes.length; ++i) {
      var foodType = foodTypes[i];
      if (i == 0 || i == _foodTypePageSize / 2) {
        var container = new Container(
          margin: new EdgeInsets.only(top: 10.0),
          child: new Row(
            children: <Widget>[],
          ),
        );
        lastRow = container.child;
        columnChildren.add(container);
      }
      lastRow.children.add(new Expanded(
        child: new GestureDetector(
          child: new Container(
            child: new Column(
              children: <Widget>[
                new Image.network(
                  '${Config.ImgCdnUrl}${foodType.imageUrl}',
                  height: 50.0,
                ),
                new Text(
                  foodType.title,
                  style: Style.textStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          onTap: () => _goFood(foodType),
        ),
      ));
      if (i == foodTypes.length - 1 &&
          lastRow.children.length != _foodTypePageSize / 2) {
        lastRow.children.add(
          new Expanded(
            flex: (_foodTypePageSize / 2 - lastRow.children.length).floor(),
            child: new Container(),
          ),
        );
      }
    }
    return new Column(
      children: columnChildren,
    );
  }

  void _goFood(FoodType foodType) {
    Routes.router.navigateTo(
        context,
        '/food/${_getCategoryId(foodType.link)}/${foodType.title}/${widget
            .geoHash}');
  }

  // 解码url地址，获取restaurant_category_id
  String _getCategoryId(url) {
    String params = url.split('=')[1];
    String urlData =
        Uri.decodeComponent(params.replaceFirst('&target_name', ''));
    if (urlData.contains('restaurant_category_id')) {
      var data = json.decode(urlData);
      return data['restaurant_category_id']['id'].toString();
    } else {
      return '';
    }
  }
}
