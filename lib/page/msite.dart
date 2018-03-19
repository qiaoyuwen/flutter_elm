import 'package:flutter/material.dart';
import '../components/component_utils.dart';
import '../style/style.dart';
import '../components/carousel.dart';
import '../model/food_type.dart';
import '../model/place.dart';
import '../utils/api.dart';
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
  Place _place;
  List<FoodType> _foodTypes = [];
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
      itemCount: 1,
      itemBuilder: (context, i) {
        return new Carousel(
          height: 200.0,
          pages: _buildFoodTypePages(),
          autoPlay: false,
        );
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
