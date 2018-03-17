import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import '../model/city.dart';
import '../model/place.dart';

class CityPage extends StatefulWidget {
  CityPage(int id)
      : id = id,
        assert(id != null);
  final int id;

  @override
  createState() => new CityState();
}

class CityState extends State<CityPage> {
  final _lineHeight = 60.0;
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
  String _query = '';

  @override
  void initState() {
    super.initState();
    Api.getCityById(widget.id).then((City city) {
      setState(() {
        _city = city;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: new Text(
          _city != null ? _city.name : '',
        ),
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
    return new ListView.builder(
      itemCount: _searchPlaces.length,
      itemBuilder: (context, i) {
        var place = _searchPlaces[i];
        return new Container(
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
        );
      },
    );
  }
}
