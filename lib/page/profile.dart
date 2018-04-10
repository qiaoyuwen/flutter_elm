import 'package:flutter/material.dart';
import '../components/foot_bar.dart';
import '../style/style.dart';
import '../components/head_bar.dart';

class Profile extends StatefulWidget {
  @override
  createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: '我的',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
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