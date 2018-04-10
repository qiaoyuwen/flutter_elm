import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import '../model/city.dart';
import '../model/place.dart';
import '../utils/local_storage.dart';
import '../routes/routes.dart';
import '../components/head_bar.dart';

class CityPage extends StatefulWidget {
  CityPage(int id)
      : id = id,
        assert(id != null);
  final int id;

  @override
  createState() => new CityState();
}

class CityState extends State<CityPage> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding, vertical: 10.0);
  final _gMargin = new EdgeInsets.only(bottom: 10.0);
  final _textStyle = Style.textStyle;
  final _tipTextStyle = new TextStyle(
    color: const Color(0xFF9F9F9F),
    fontSize: 12.0,
  );
  final _topBottomBorder = new Border(
    top: new BorderSide(
      color: Style.borderColor,
    ),
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
  );

  final _bottomBorder = new Border(
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
  );

  City _city;
  List<Place> _searchPlaces = [];
  List<Place> _historyPlaces = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    Api.getCityById(widget.id).then((City city) {
      setState(() {
        _city = city;
      });
    });
    LocalStorage.getPlaceHistory().then((List<Place> history) {
      _historyPlaces = history.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: _city != null ? _city.name : '',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new Column(
        children: <Widget>[
          _buildSearchContainer(),
          new Expanded(
            child: _buildResultLists(),
          ),
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  _searchPlace(String query) {
    setState(() {
      _query = query;
    });
    if (query.length != 0) {
      Api.searchPlace(_city.id, query).then((List<Place> places) {
        setState(() {
          _searchPlaces = places;
        });
      });
    }
  }

  Widget _buildSearchContainer() {
    return new Container(
      margin: _gMargin,
      padding: _gPadding,
      decoration: new BoxDecoration(
        color: Style.backgroundColor,
        border: _topBottomBorder,
      ),
      child: new Container(
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
            hintText: '输入学校、商务楼、地址',
            hintStyle: _textStyle,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _searchPlace(value);
          },
        ),
      ),
    );
  }

  Widget _buildResultLists() {
    bool showHistory = _query.length == 0;
    int itemCount = showHistory ? _historyPlaces.length : _searchPlaces.length;
    if (showHistory && _historyPlaces.length > 0) {
      itemCount += 1;
    }
    return new ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, i) {
        Place place;
        if ((showHistory && i < _historyPlaces.length) || !showHistory) {
          place = showHistory ? _historyPlaces[i] : _searchPlaces[i];
          return new GestureDetector(
            child: new Container(
              padding: _gPadding,
              decoration: new BoxDecoration(
                color: Style.backgroundColor,
                border: i == 0 ? _topBottomBorder : _bottomBorder,
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    place.name,
                    style: _textStyle,
                  ),
                  new Text(
                    place.address,
                    style: _tipTextStyle,
                  ),
                ],
              ),
            ),
            onTap: () => _selectPlace(context, place),
          );
        } else {
          return new GestureDetector(
            child: new Container(
              padding: _gPadding,
              decoration: new BoxDecoration(
                color: Style.backgroundColor,
                border: _bottomBorder,
              ),
              child: new Center(
                child: new Text(
                  '清除所有',
                  style: _textStyle,
                ),
              ),
            ),
            onTap: _clearHistory,
          );
        }
      },
    );
  }

  ///点击搜索结果进入下一页面时进行判断是否已经有一样的历史记录
  ///如果没有则新增，如果有则不做重复储存，判断完成后进入下一页
  _selectPlace(BuildContext context, Place place) async {
    List<Place> history = await LocalStorage.getPlaceHistory();
    bool find = false;
    for(var item in history) {
      if (item.geohash == place.geohash) {
        find = true;
        break;
      }
    }
    if (!find) {
      history.add(place);
      LocalStorage.setPlaceHistory(history);
    }
    Routes.router.navigateTo(context, '/msite/${place.geohash}');
  }

  _clearHistory() {
    setState(() {
      _historyPlaces = [];
      LocalStorage.setPlaceHistory(_historyPlaces);
    });
  }
}
