import 'package:flutter/material.dart';

class City extends StatefulWidget {
  City(int id, String name)
      : id = id,
        name = name,
        assert(id != null),
        assert(name != null);
  final int id;
  final String name;

  @override
  createState() => new CityState();
}

class CityState extends State<City> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: new Text(widget.name),
      ),
      body: new Container(),
    );
  }
}
