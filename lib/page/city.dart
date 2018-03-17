import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import '../model/city.dart';

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
  final _topBottomBorder = new Border(
    top: new BorderSide(
      color: Style.borderColor,
    ),
    bottom: new BorderSide(
      color: Style.borderColor,
    ),
  );

  City city;

  @override
  void initState() {
    super.initState();
    Api.getCityById(widget.id).then((City city) {
      setState(() {
        this.city = city;
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
          city != null ? city.name : '',
        ),
      ),
      body: new Column(
        children: <Widget>[
          _buildSearchContainer(),
        ],
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
        ),
      ),
    );
  }

  Widget _buildResultLists() {
    return new ListView.builder(
      itemBuilder: null,
    );
  }
}
