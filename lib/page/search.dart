import 'package:flutter/material.dart';
import '../style/style.dart';
import '../components/foot_bar.dart';
import '../components/button.dart';
import '../components/head_bar.dart';
import '../model/restaurant.dart';
import '../utils/local_storage.dart';
import '../utils/api.dart';
import '../config/config.dart';

class Search extends StatefulWidget {
  Search(String geoHash)
      : geoHash = geoHash,
        assert(geoHash != null);
  final String geoHash;

  @override
  createState() => new SearchState();
}

class SearchState extends State<Search> {
  final _gPadding =
      new EdgeInsets.symmetric(horizontal: Style.gPadding, vertical: 10.0);
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
  final _iconColor = new Color(0xff999999);
  final _payTextColor = new Color(0xffff6000);
  final _bottomBorder = new Border(
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
  );

  String _searchValue = '';
  List<Restaurant> _restaurants = [];
  List<String> _history = [];
  bool _showHistory = true;
  bool _emptyResult = false;

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  _getHistory() async {
    var history = await LocalStorage.getSearchHistory();
    setState(() {
      _history = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    var itemCount =
        2 + (_showHistory ? _history.length + 1 : (_restaurants.isEmpty ? 1 : _restaurants.length));
    return new Scaffold(
      appBar: new HeadBar(
        title: '搜索周边',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _buildSearchContainer();
          } else if (i == 1) {
            if ((_showHistory && _history.isEmpty) || _restaurants.isEmpty) {
              return new Container();
            } else {
              return new Container(
                padding: _gPadding,
                decoration: new BoxDecoration(
                  color: Style.backgroundColor,
                  border: _bottomBorder,
                ),
                child: new Text(
                  _showHistory ? '搜索历史' : '商家',
                  style: Style.textStyle,
                ),
              );
            }
          } else {
            var index = i - 2;
            if (_showHistory) {
              if (index == _history.length) {
                if (_history.isEmpty) {
                  return new Container();
                } else {
                  return new GestureDetector(
                    child: new Container(
                      color: Style.backgroundColor,
                      padding: _gPadding,
                      child: new Center(
                        child: new Text(
                          '清空搜索历史',
                          style: new TextStyle(color: Style.primaryColor),
                        ),
                      ),
                    ),
                    onTap: _clearHistory,
                  );
                }
              } else {
                return _buildHistoryItem(index);
              }
            } else {
              if (_restaurants.isEmpty) {
                return new Container(
                  color: Style.backgroundColor,
                  padding: _gPadding,
                  child: new Center(
                    child: new Text('很抱歉！无搜索结果'),
                  ),
                );
              } else {
                return _buildRestaurantItem(index);
              }
            }
          }
        },
      ),
      bottomNavigationBar: new FootBar(
        currentIndex: 1,
      ),
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
                controller: new TextEditingController(text: _searchValue)
                  ..selection = new TextSelection(
                      baseOffset: _searchValue.length,
                      extentOffset: _searchValue.length),
                decoration: new InputDecoration(
                  hintText: '请输入商家或美食的名称',
                  hintStyle: _textStyle,
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  _searchValue = val;
                  if (_searchValue.isEmpty) {
                    _showHistory = true;
                    _getHistory();
                  }
                },
              ),
            ),
          ),
          new Button(
            width: 60.0,
            height: 46.0,
            text: '搜索',
            onTap: _search,
          )
        ],
      ),
    );
  }

  _search() async {
    if (_searchValue.isEmpty) {
      return;
    }
    // 隐藏搜索历史
    var showHistory = false;
    // 查询结果
    var restaurants = await Api.searchRestaurant(widget.geoHash, _searchValue);
    var emptyResult = restaurants.isEmpty;
    // 如果不存在此次搜索历史则新增
    List<String> history = await LocalStorage.getSearchHistory();
    if (!history.contains(_searchValue)) {
      history.add(_searchValue);
      LocalStorage.setSearchHistory(history);
    }

    setState(() {
      _showHistory = showHistory;
      _restaurants = restaurants;
      _emptyResult = emptyResult;
    });
  }

  Widget _buildHistoryItem(int index) {
    String history = _history[index];
    return new GestureDetector(
      child: new Container(
        padding: _gPadding,
        decoration: new BoxDecoration(
          color: Style.backgroundColor,
          border: _bottomBorder,
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(history),
            new GestureDetector(
              child: new Icon(
                Icons.delete_forever,
                color: _iconColor,
              ),
              onTap: () => _removeHistory(history),
            ),
          ],
        ),
      ),
      onTap: () {
        _searchValue = history;
        _search();
      },
    );
  }

  Widget _buildRestaurantItem(int index) {
    Restaurant restaurant = _restaurants[index];
    return new Container(
      padding: _gPadding,
      decoration: new BoxDecoration(
        color: Style.backgroundColor,
        border: _bottomBorder,
      ),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: new Image.network(
              '${Config.ImgBaseUrl}${restaurant.imagePath}',
              width: 60.0,
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        restaurant.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    new Container(
                      padding: new EdgeInsets.symmetric(horizontal: 1.0),
                      margin: new EdgeInsets.only(left: 5.0),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                          color: _payTextColor,
                        ),
                      ),
                      child: new Text(
                        '支付',
                        style: new TextStyle(
                          color: _payTextColor,
                          fontSize: 8.0,
                        ),
                      ),
                    ),
                  ],
                ),
                new Text('月售 ${restaurant.recentOrderNum} 单'),
                new Text(
                    '${restaurant.floatMinimumOrderAmount} 元起送 / 距离 ${restaurant
                        .distance}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeHistory(String value) {
    _history.remove(value);
    LocalStorage.setSearchHistory(_history);
    setState(() {});
  }

  void _clearHistory() {
    List<String> history = [];
    LocalStorage.setSearchHistory(history);
    setState(() {
      _history = history;
    });
  }
}
