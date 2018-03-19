import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import '../model/city.dart';
import '../routes/routes.dart';
import '../components/component_utils.dart';

class Home extends StatefulWidget {
  @override
  createState() => new HomeState();
}

class HomeState extends State<Home> {
  final _lineHeight = 40.0;
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding);
  final _gMargin = new EdgeInsets.only(bottom: 10.0);
  final _btnPadding = new EdgeInsets.symmetric(horizontal: 5.0);
  final _textStyle = Style.textStyle;
  final _tipTextStyle = new TextStyle(
    color: const Color(0xFF9F9F9F),
    fontSize: 12.0,
  );
  final _hotTextStyle = new TextStyle(
    color: Style.primaryColor,
    fontSize: Style.fontSize,
  );
  final _bottomBorder = new Border(
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
  );

  final _bottomRightBorder = new Border(
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
    right: new BorderSide(
      color: Style.borderColor,
    ),
  );

  List<City> _hotCities = [];
  Map<String, List<City>> _citiesGroup = new Map();
  List<String> _citiesGroupKeys = [];
  City _guessCity;

  @override
  void initState() {
    super.initState();
    Api.getHotCities().then((List<City> cities) {
      cities.sort((c1, c2) => c1.sort - c2.sort);
      setState(() {
        _hotCities = cities;
      });
    });

    /*Api.getCitiesGroup().then((Map<String, List<City>> citiesGroup) {
      setState(() {
        _citiesGroupKeys = citiesGroup.keys.toList();
        _citiesGroupKeys.sort((s1, s2) => s1.compareTo(s2));
        _citiesGroup = citiesGroup;
      });
    });*/

    Api.getGuessCity().then((City city) {
      setState(() {
        _guessCity = city;
      });
    });
  }

  _goCity(BuildContext context, City city) {
    Routes.router.navigateTo(context, '/city/${city.id.toString()}');
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
      title: 'elm.qyw',
      centerTitle: false,
    );
  }

  Widget _buildBody() {
    return new ListView.builder(
      itemCount: 2 + _citiesGroupKeys.length,
      itemBuilder: (context, i) {
        if (i == 0) {
          return _buildCityLocation();
        } else if (i == 1) {
          return _buildHotCityBlock();
        } else {
          return _buildCityGroupBlock(i - 2);
        }
      },
    );
  }

  Widget _buildBlockContainer(Widget child) {
    return new Container(
      margin: _gMargin,
      color: Style.backgroundColor,
      child: child,
    );
  }

  Widget _buildRowContainer(Widget child) {
    return new Container(
      padding: _gPadding,
      height: _lineHeight,
      decoration: new BoxDecoration(
        border: _bottomBorder,
      ),
      child: child,
    );
  }

  Widget _buildCityLocation() {
    return _buildBlockContainer(
      new Column(
        children: <Widget>[
          _buildRowContainer(
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  '当前定位城市：',
                  style: _textStyle,
                ),
                new Text(
                  '定位不准时，请在城市列表中选择',
                  style: _tipTextStyle,
                ),
              ],
            ),
          ),
          new GestureDetector(
            child: _buildRowContainer(
              new Row(
                children: <Widget>[
                  new Text(
                    _guessCity == null ? '' : _guessCity.name,
                    style: _hotTextStyle,
                  ),
                  new Expanded(
                    child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        color: const Color(0xFF999999),
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (_guessCity != null) {
                this._goCity(context, _guessCity);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHotCityBlock() {
    return _buildBlockContainer(
      new Column(
        children: <Widget>[
          _buildRowContainer(
            new Row(
              children: <Widget>[
                new Text(
                  '热门城市',
                  style: Style.textStyle,
                ),
              ],
            ),
          ),
          _buildHotCities(),
        ],
      ),
    );
  }

  Widget _buildHotCities() {
    var hotCityColumn = new Column(
      children: <Widget>[],
    );
    Row lastRow;
    for (var i = 0; i < _hotCities.length; ++i) {
      if (i % 4 == 0) {
        lastRow = new Row(children: <Widget>[],);
        hotCityColumn.children.add(lastRow);
      }
      lastRow.children.add(
        new Expanded(
          child: _buildCityBtn(i, _hotCities[i], true),
        ),
      );
      if (i == _hotCities.length - 1 && lastRow.children.length < 4) {
        lastRow.children.add(
          new Expanded(
            flex: 4 - lastRow.children.length,
            child: new Container(),
          ),
        );
      }
    }
    return hotCityColumn;
  }

  Widget _buildCityBtn(int index, City city, isHot) {
    return new GestureDetector(
      child: new Container(
        height: _lineHeight,
        decoration: new BoxDecoration(
          border: index % 4 == 3 ? _bottomBorder : _bottomRightBorder,
        ),
        child: new Container(
          padding: _btnPadding,
          alignment: Alignment.center,
          child: new Text(
            city.name,
            style: isHot ? _hotTextStyle : _textStyle,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ),
      onTap: () => this._goCity(context, city),
    );
  }

  Widget _buildCityGroupBlock(int index) {
    return _buildBlockContainer(
      new Column(
        children: <Widget>[
          _buildRowContainer(
            new Row(
              children: <Widget>[
                new Text(
                  _citiesGroupKeys[index],
                  style: Style.textStyle,
                ),
              ],
            ),
          ),
          _buildCityGroup(index),
        ],
      ),
    );
  }

  Widget _buildCityGroup(int index) {
    var groupColumn = new Column(
      children: <Widget>[],
    );
    Row lastRow;
    var cities = _citiesGroup[_citiesGroupKeys[index]];
    for (var i = 0; i < cities.length; ++i) {
      if (i % 4 == 0) {
        lastRow = new Row(children: <Widget>[],);
        groupColumn.children.add(lastRow);
      }
      lastRow.children.add(
        new Expanded(
          child: _buildCityBtn(i, cities[i], false),
        ),
      );
      if (i == cities.length - 1 && lastRow.children.length < 4) {
        lastRow.children.add(
          new Expanded(
            flex: 4 - lastRow.children.length,
            child: new Container(),
          ),
        );
      }
    }
    return groupColumn;
  }
}
