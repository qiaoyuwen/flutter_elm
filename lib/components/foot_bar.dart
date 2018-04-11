import 'package:flutter/material.dart';
import '../style/style.dart';
import '../routes/routes.dart';
import '../store/store.dart';

class FootBar extends StatelessWidget {
  FootBar({int currentIndex = 0}) : currentIndex = currentIndex;

  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      onTap: (index) => go(context, index),
      currentIndex: currentIndex,
      fixedColor: Style.primaryColor,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(
            Icons.store,
          ),
          title: new Text('外卖'),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(
            Icons.location_searching,
          ),
          title: new Text('搜索'),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(
            Icons.shopping_cart,
          ),
          title: new Text('订单'),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(
            Icons.person,
          ),
          title: new Text('我的'),
        ),
      ],
    );
  }

  go(BuildContext context, int index) {
    if (index == currentIndex) return;
    String geoHash = store.state.geoHash;
    if (geoHash.isEmpty) {
      geoHash = '0,0';
    }
    String path = '';
    switch(index) {
      case 0:
        path = '/msite/$geoHash';
        break;
      case 1:
        path = '/search/$geoHash';
        break;
      case 2:
        path = '/order';
        break;
      case 3:
        path = '/profile';
        break;
    }
    if (path.length > 0) {
      print('go to: $path');
      Routes.router.navigateTo(context, path);
    }
  }
}