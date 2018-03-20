import 'package:flutter/material.dart';
import '../components/component_utils.dart';
import '../style/style.dart';
import '../components/carousel.dart';
import '../model/food_type.dart';
import '../model/place.dart';
import '../utils/api.dart';
import '../config/config.dart';
import '../model/restaurant.dart';
import '../config/config.dart';

class MSite extends StatefulWidget {
  MSite(num longitude, num latitude)
      : longitude = longitude,
        latitude = latitude,
        assert(longitude != null),
        assert(latitude != null);

  final num longitude;
  final num latitude;

  @override
  createState() => new MSiteState();
}

class MSiteState extends State<MSite> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding);
  final _shopPadding = new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0);
  final _shopHeight = 100.0;
  final _gMargin = new EdgeInsets.only(bottom: 10.0);

  Place _place;
  List<FoodType> _foodTypes = [];
  List<Restaurant> _restaurants = [];
  final _foodTypePageSize = 8;

  @override
  void initState() {
    super.initState();
    String geohash = '${widget.longitude.toString()},${widget.latitude.toString()}';
    Api.getPlace(geohash).then((Place place) {
      setState((){
        _place = place;
      });
    });
    Api.getFoodTypes(geohash).then((List<FoodType> foodTypes){
      setState((){
        _foodTypes = foodTypes;
      });
    });
    Api.getRestaurants(widget.latitude, widget.longitude, 0).then((List<Restaurant> restaurants) {
      setState((){
        _restaurants = restaurants;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ComponentUtils.buildAppBar(
      context: context,
      title: _place != null ? _place.name : '',
      centerTitle: true,
      leading: new IconButton(
        icon: new Icon(Icons.search),
        color: Style.backgroundColor,
        onPressed: _goSearch,
      ),
    );
  }

  _goSearch() {

  }

  Widget _buildBody() {
    return new ListView.builder(
      itemCount: 2 + _restaurants.length,
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
        } else {
          return _buildRestaurant(_restaurants[i - 2]);
        }
      },
    );
  }

  Widget _buildRestaurant(Restaurant restaurant) {
    var detailRow = new Row(
      children: <Widget>[],
    );
    if (restaurant.isPremium) {
      detailRow.children.add(
        new Container(
          margin: new EdgeInsets.only(right: 5.0),
          color: new Color(0xFFFFd930),
          child: new Text(
            '品牌',
            style: Style.textStyle,
          ),
        ),
      );
    }
    detailRow.children.add(
      new Text(
        restaurant.name,
        style: Style.textStyle,
      )
    );
    var supportsRow = new Row(
      children: <Widget>[],
    );
    for (var support in restaurant.supports) {
      supportsRow.children.add(
        new Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: new BoxDecoration(
            border: new Border.all(
              color: Style.borderColor,
              width: 0.5,
            ),
          ),
          child: new Text(
            support.iconName,
            style: new TextStyle(
              color: const Color(0xFF999999),
              fontSize: 10.0,
            ),
          ),
        )
      );
    }
    return new Container(
      height: _shopHeight,
      padding: _shopPadding,
      decoration: new BoxDecoration(
        color: Style.backgroundColor,
        border: new Border(
          bottom: new BorderSide(
            color: Style.borderColor,
          ),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: new Image.network(
              '${Config.ImgBaseUrl}${restaurant.imagePath}',
              width: 80.0,
              height: 80.0,
              fit: BoxFit.fill,
            ),
          ),
          new Expanded(
            child: new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    detailRow,
                    supportsRow,
                  ],
                ),
                new Row(),
                new Row(),
              ],
            ),
          ),
        ],
      ),
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
      lastRow.children.add(
        new Expanded(
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
        )
      );
      if (i == foodTypes.length - 1 && lastRow.children.length != _foodTypePageSize / 2) {
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
}
