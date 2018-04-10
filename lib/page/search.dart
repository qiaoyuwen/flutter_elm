import 'package:flutter/material.dart';
import '../style/style.dart';
import '../components/foot_bar.dart';
import '../components/button.dart';
import '../components/head_bar.dart';

class Search extends StatefulWidget {
  Search(String  geoHash)
      : geoHash = geoHash,
        assert(geoHash != null);
  final String geoHash;

  @override
  createState() => new SearchState();
}

class SearchState extends State<Search> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding, vertical: 10.0);
  final _gMargin = new EdgeInsets.only(bottom: 10.0);
  final _textStyle = Style.textStyle;
  final _topBottomBorder = new Border(
    top: new BorderSide(
      color: Style.borderColor,
    ),
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: '搜索周边',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new Column(
        children: <Widget>[
          _buildSearchContainer(),
        ],
      ),
      bottomNavigationBar: new FootBar(currentIndex: 1,),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  Widget _buildSearchContainer() {
    return new Container(
      margin: _gMargin,
      padding: _gPadding,
      decoration: new BoxDecoration(
        color: Style.backgroundColor,
        border: _topBottomBorder,
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              margin: new EdgeInsets.only(right: 10.0),
              padding: new EdgeInsets.symmetric(horizontal: 10.0),
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Style.borderColor,
                ),
                borderRadius: new BorderRadius.all(
                  new Radius.circular(5.0),
                ),
              ),
              child: new TextField(
                decoration: new InputDecoration(
                  hintText: '请输入商家或美食的名称',
                  hintStyle: _textStyle,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          new Button(
            width: 60.0,
            height: 46.0,
            text: '搜索',
            onTap: search,
          )
        ],
      ),
    );
  }

  void search() {

  }
}