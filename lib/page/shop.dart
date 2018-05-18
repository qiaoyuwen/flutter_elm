import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../utils/api.dart';
import '../model/menu.dart';
import '../model/rating.dart';
import '../model/rating_score.dart';
import '../model/rating_tag.dart';
import '../config/config.dart';
import '../components/head_bar.dart';
import '../style/style.dart';

class Shop extends StatefulWidget {
  Shop({
    this.shopId,
    this.latitude,
    this.longitude,
  }) : geoHash = '$longitude,$latitude';
  final String shopId;
  final num latitude;
  final num longitude;
  final String geoHash;

  @override
  State<StatefulWidget> createState() {
    return new ShopState();
  }
}

class ShopState extends State<Shop> {

  Restaurant _restaurant;
  List<Menu> _menus;
  List<Rating> _ratings;
  int _ratingOffset = 0;
  RatingScore _ratingScore;
  List<RatingTag> _ratingTags;

  @override
  void initState() {
    super.initState();
    _getShop();
    _getMenus();
    _getRatings();
    _getRatingScore();
    _getRatingTags();
  }

  _getShop() async {
    Restaurant restaurant = await Api.getShopById(
      shopId: widget.shopId,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
    setState(() {
      _restaurant = restaurant;
    });
  }

  _getMenus() async {
    List<Menu> menus = await Api.getMenus(widget.shopId);
    setState(() {
      _menus = menus;
    });
  }

  _getRatings() async {
    List<Rating> ratings = await Api.getRatings(
      shopId: widget.shopId,
      offset: _ratingOffset,
    );
    setState(() {
      _ratings = ratings;
    });
  }

  _getRatingScore() async {
    RatingScore ratingScore = await Api.getRatingScore(widget.shopId);
    setState(() {
      _ratingScore = ratingScore;
    });
  }

  _getRatingTags() async {
    List<RatingTag> ratingTags = await Api.getRatingTags(widget.shopId);
    setState(() {
      _ratingTags = ratingTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_restaurant == null) {
      return new Center(
        child: new Text('Loading...'),
      );
    }
    return new Stack(
      children: <Widget>[
        new Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          child: new Image.network(
            '${Config.ImgBaseUrl}${_restaurant.imagePath}',
            alignment: Alignment.topLeft,
          ),
        ),
        new Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          child: new Scaffold(
            backgroundColor: new Color(0x00000000),
            appBar: new HeadBar(
              leadingType: HeadBarLeadingType.goBack,
              showUser: false,
              backgroundColor: new Color(0x6e776789),
              bottom: new PreferredSize(
                preferredSize: new Size.fromHeight(80.0),
                child: new Container(
                  height: 80.0,
                  padding: new EdgeInsets.all(10.0).copyWith(top: 0.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Container(
                        margin: new EdgeInsets.only(right: 10.0),
                        child: new Image.network(
                          '${Config.ImgBaseUrl}${_restaurant.imagePath}',
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              _restaurant.name,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Text(
                              '商家配送／${_restaurant.orderLeadTime}分钟送达／配送费¥${_restaurant.floatDeliveryFee}',
                              style: new TextStyle(
                                fontSize: 11.0,
                                color: Colors.white,
                              ),
                            ),
                            new Text(
                              '公告：${_restaurant.promotionInfo.isEmpty ? '欢迎光临，用餐高峰期请提前下单，谢谢。' : _restaurant.promotionInfo}',
                              style: new TextStyle(
                                fontSize: 11.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 30.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: new Container(
              color: Style.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }
}