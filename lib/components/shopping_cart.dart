import 'package:flutter/material.dart';
import '../style/style.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ShoppingCartState();
  }
}

class ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          new Container(
            height: 50.0,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Container(
                    padding: new EdgeInsets.symmetric(vertical: 5.0).copyWith(left: 100.0),
                    color: new Color(0xff3d3d3f),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          '￥0.00',
                          style: new TextStyle(
                            fontSize: 17.0,
                            color: Style.backgroundColor,
                          ),
                        ),
                        new Text(
                          ' 配送费￥5',
                          style: new TextStyle(
                            fontSize: 10.0,
                            color: Style.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: new Container(
                    color: new Color(0xff535356),
                    child: new Center(
                      child: new Text(
                        '还差￥20起送',
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Style.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          new Positioned(
            top: -15.0,
            left: 30.0,
            child: new Container(
              padding: new EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                color: new Color(0xff3d3d3f),
                shape: BoxShape.circle,
                border: new Border.all(
                  color: new Color(0xff444444),
                  width: 5.0,
                ),
              ),
              child: new Center(
                child: new Icon(
                  Icons.shopping_cart,
                  color: Style.backgroundColor,
                  size: 36.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}