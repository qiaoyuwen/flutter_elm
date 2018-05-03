import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../style/style.dart';
import '../components/rating_star.dart';
import '../config/config.dart';

class UiUtils {
  static final _shopPadding = new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0);
  static final _shopHeight = 100.0;

  static Widget buildRestaurant(Restaurant restaurant) {
    var detailRow = new Row(
      children: <Widget>[],
    );
    if (restaurant.isPremium) {
      detailRow.children.add(
        new Container(
          margin: new EdgeInsets.only(right: 5.0),
          color: new Color(0xFFFFd930),
          child: new Text(
            '品牌',
            style: Style.textStyle,
          ),
        ),
      );
    }
    detailRow.children.add(new Expanded(
      child: new Text(
        restaurant.name,
        style: Style.textStyle,
        overflow: TextOverflow.ellipsis,
      ),
    ));
    var supportsRow = new Row(
      children: <Widget>[],
    );
    for (var support in restaurant.supports) {
      supportsRow.children.add(new Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: new BoxDecoration(
          border: new Border.all(
            color: Style.borderColor,
            width: 0.5,
          ),
        ),
        child: new Text(
          support.iconName,
          style: new TextStyle(
            color: const Color(0xFF999999),
            fontSize: 10.0,
          ),
        ),
      ));
    }
    var ratingRow = new Row(
      children: <Widget>[
        new RatingStar(restaurant.rating),
        new Text(
          '月售${restaurant.recentOrderNum}单',
          style: new TextStyle(
            color: const Color(0xFF999999),
            fontSize: 10.0,
          ),
        ),
      ],
    );
    var ratingDescRow = new Row(
      children: <Widget>[],
    );
    if (restaurant.deliveryMode != null) {
      ratingDescRow.children.add(
        new Container(
          padding: new EdgeInsets.symmetric(horizontal: 2.0),
          decoration: new BoxDecoration(
            color: Style.primaryColor,
            border: new Border.all(
              color: Style.primaryColor,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
          ),
          child: new Text(
            restaurant.deliveryMode.text,
            style: new TextStyle(
              color: Style.backgroundColor,
              fontSize: 10.0,
            ),
          ),
        ),
      );
    }
    if (zhunshi(restaurant)) {
      ratingDescRow.children.add(
        new Container(
          margin: new EdgeInsets.only(left: 2.0),
          padding: new EdgeInsets.symmetric(horizontal: 2.0),
          decoration: new BoxDecoration(
            color: Style.backgroundColor,
            border: new Border.all(
              color: Style.primaryColor,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
          ),
          child: new Text(
            '准时达',
            style: new TextStyle(
              color: Style.primaryColor,
              fontSize: 10.0,
            ),
          ),
        ),
      );
    }
    var distanceRow = new Row(
      children: <Widget>[],
    );
    num distance = num.parse(restaurant.distance, (value) {
      return null;
    });
    if (distance != null) {
      distanceRow.children.add(
        new Text(
          '${distance > 1000
              ? '${(distance / 1000).toStringAsFixed(2)}km'
              : '${distance}m'}' +
              ' / ',
          style: new TextStyle(
            color: const Color(0xFF999999),
            fontSize: 12.0,
          ),
        ),
      );
    } else {
      distanceRow.children.add(
        new Text(
          '${restaurant.distance} / ',
          style: new TextStyle(
            color: const Color(0xFF999999),
            fontSize: 12.0,
          ),
        ),
      );
    }
    distanceRow.children.add(
      new Text(
        '${restaurant.orderLeadTime}',
        style: new TextStyle(
          color: Style.primaryColor,
          fontSize: 12.0,
        ),
      ),
    );
    return new Container(
      height: _shopHeight,
      padding: _shopPadding,
      decoration: new BoxDecoration(
        color: Style.backgroundColor,
        border: new Border(
          bottom: new BorderSide(
            color: Style.borderColor,
          ),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: new Image.network(
              '${Config.ImgBaseUrl}${restaurant.imagePath}',
              width: 80.0,
              height: 80.0,
              fit: BoxFit.fill,
            ),
          ),
          new Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: detailRow,
                    ),
                    supportsRow,
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ratingRow, ratingDescRow],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      '¥${restaurant.floatMinimumOrderAmount}起送 / ${restaurant
                          .piecewiseAgentFee['tips']}',
                      style: new TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    distanceRow,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static bool zhunshi(Restaurant r) {
    if (r.supports != null && r.supports.length > 0) {
      for (var s in r.supports) {
        if (s.iconName == '准') {
          return true;
        }
      }
    }
    return false;
  }
}