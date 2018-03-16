import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import '../model/city.dart';

class Home extends StatefulWidget {
  @override
  createState() => new HomeState();
}

class HomeState extends State<Home> {
  List<City> _hotCities = [];
  Map<String, List<City>> _citiesGroup = new Map();

  @override
  void initState() {
    super.initState();
    Api.getHotCities().then((List<City> cities) {
      cities.sort((c1, c2) => c1.sort - c2.sort);
      setState(() {
        _hotCities = cities;
      });
    });
    Api.getCitiesGroup().then((Map<String, List<City>> citiesGroup) {
      setState(() {
        _citiesGroup = citiesGroup;
      });
    });
  }

  _goLogin(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    var hotCityColumn = new Container(
      margin: new EdgeInsets.only(bottom: 10.0),
      child: new Column(
        children: <Widget>[],
      ),
    );
    Row lastRow;
    for (var i = 0; i < _hotCities.length; ++i) {
      if (i % 4 == 0) {
        lastRow = new Row(children: <Widget>[],);
        (hotCityColumn.child as Column).children.add(lastRow);
      }
      lastRow.children.add(
        new Expanded(
          child: new GestureDetector(
            child: new Container(
              height: 40.0,
              decoration: new BoxDecoration(
                color: Style.backgroundColor,
                border: new Border(
                  bottom: new BorderSide(
                    color: Style.borderColor,
                  ),
                  right: i % 4 == 3 ? BorderSide.none : new BorderSide(
                    color: Style.borderColor,
                  ),
                ),
              ),
              child: new Center(
                child: new Text(
                  _hotCities[i].name,
                  style: new TextStyle(
                    fontSize: 15.0,
                    color: Style.primaryColor,
                  ),
                ),
              ),
            ),
            onTap: () => this._goLogin(context),
          ),
        ),
      );
    }

    var cityGroupsColumn = new Column(
      children: <Widget>[],
    );
    var keys = _citiesGroup.keys.toList();
    keys.sort((s1, s2) => s1.compareTo(s2));
    for (String key in keys) {
      List<City> cities = _citiesGroup[key];
      var groupColumn = new Column(
        children: <Widget>[],
      );
      for (var i = 0; i < cities.length; ++i) {
        if (i % 4 == 0) {
          lastRow = new Row(children: <Widget>[],);
          groupColumn.children.add(lastRow);
        }
        lastRow.children.add(
          new Expanded(
            child: new GestureDetector(
              child: new Container(
                height: 40.0,
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(
                      color: Style.borderColor,
                    ),
                    right: i % 4 == 3 ? BorderSide.none : new BorderSide(
                      color: Style.borderColor,
                    ),
                  ),
                ),
                child: new Center(
                  child: new Text(
                    cities[i].name,
                    style: Style.textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              onTap: () => this._goLogin(context),
            ),
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

      var columnItem = new Container(
        color: Style.backgroundColor,
        margin: new EdgeInsets.only(bottom: 10.0),
        child: new Column(
          children: <Widget>[
            new Container(
              height: 40.0,
              padding: new EdgeInsets.symmetric(horizontal: Style.gPadding),
              decoration: new BoxDecoration(
                color: Style.backgroundColor,
                border: new Border(
                  bottom: new BorderSide(
                    color: Style.borderColor,
                  ),
                  top: new BorderSide(
                    color: Style.borderColor,
                  ),
                ),
              ),
              child: new Row(
                children: <Widget>[
                  new Text(
                    key,
                    style: Style.textStyle,
                  ),
                ],
              ),
            ),
            groupColumn,
          ],
        ),
      );
      cityGroupsColumn.children.add(columnItem);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'elm.qyw',
        ),
        centerTitle: false,
        actions: <Widget>[
          new GestureDetector(
            onTap: () => this._goLogin(context),
            child: new Container(
              padding: ButtonTheme.of(context).padding,
              child: new Center(
                child: new Text(
                  '登录|注册',
                  style: themeData.primaryTextTheme.title,
                ),
              ),
            ),
          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: Style.gPadding),
            height: 40.0,
            decoration: new BoxDecoration(
              color: Style.backgroundColor,
              border: new Border(
                bottom: new BorderSide(
                  color: Style.borderColor,
                ),
              ),
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  '当前定位城市：',
                  style: Style.textStyle,
                ),
                new Text(
                  '定位不准时，请在城市列表中选择',
                  style: const TextStyle(
                    color: const Color(0xFF9F9F9F),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          new GestureDetector(
            child: new Container(
              padding: new EdgeInsets.symmetric(horizontal: Style.gPadding),
              height: 40.0,
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
            onTap: () => this._goLogin(context),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 10.0),
            padding: new EdgeInsets.symmetric(horizontal: Style.gPadding),
            height: 40.0,
            decoration: new BoxDecoration(
              color: Style.backgroundColor,
              border: new Border(
                bottom: new BorderSide(
                  color: Style.borderColor,
                ),
                top: new BorderSide(
                  color: Style.borderColor,
                ),
              ),
            ),
            child: new Row(
              children: <Widget>[
                new Text(
                  '热门城市',
                  style: Style.textStyle,
                ),
              ],
            ),
          ),
          hotCityColumn,
          cityGroupsColumn,
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}
