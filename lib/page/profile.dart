import 'package:flutter/material.dart';
import '../components/foot_bar.dart';
import '../style/style.dart';

class Profile extends StatefulWidget {
  @override
  createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: new Text('我的'),
        centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
        ],
      ),
      bottomNavigationBar: new FootBar(currentIndex: 3,),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}