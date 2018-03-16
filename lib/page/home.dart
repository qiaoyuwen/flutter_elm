import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import 'dart:io';
import 'dart:convert';
import '../model/city.dart';

class Home extends StatefulWidget {
  @override
  createState() => new HomeState();
}

class HomeState extends State<Home> {
  List<City> _hotCities = [];

  @override
  void initState() {
    super.initState();
    Api.getHotCites().then((cities) {
      if (!mounted) return;
      setState(() {
        _hotCities = cities;
      });
    });
  }

  _goLogin(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    var hotCityColumn = new Column();
    for (var i = 0; i < _hotCities.length; ++i) {

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
      body: new Column(
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
          new MaterialButton(
            padding: new EdgeInsets.all(0.0),
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
            onPressed: () => this._goLogin(context),
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
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}
