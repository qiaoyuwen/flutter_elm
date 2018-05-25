import 'package:flutter/material.dart';
import 'dart:math' as Math;
import '../model/restaurant.dart';
import '../utils/api.dart';
import '../model/menu.dart';
import '../model/rating.dart';
import '../model/rating_score.dart';
import '../model/rating_tag.dart';
import '../model/food.dart';
import '../config/config.dart';
import '../components/head_bar.dart';
import '../style/style.dart';
import '../utils/utils.dart';

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
            fit: BoxFit.fitWidth,
          ),
        ),
        new Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          child: new Scaffold(
            backgroundColor: new Color(0x00000000),
            appBar: _buildAppbar(),
            body: new Container(
              width: double.infinity,
              height: double.infinity,
              color: Style.backgroundColor,
              child: new DefaultTabController(
                length: 2,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                            color: new Color(0xffebebeb),
                          ),
                        ),
                      ),
                      child: new TabBar(
                        labelColor: new Color(0xff3190e8),
                        unselectedLabelColor: new Color(0xff666666),
                        indicatorColor: new Color(0xff3190e8),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: new TextStyle(
                          fontSize: 16.0,
                        ),
                        tabs: <Widget>[
                          new Tab(text: '商品',),
                          new Tab(text: '评价',),
                        ],
                      ),
                    ),
                    new Expanded(
                      child: new TabBarView(
                        children: <Widget>[
                          _buildMenus(),
                          new Text('tangjingjun'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: new BottomAppBar(
              hasNotch: true,
              child: new Row(
                children: <Widget>[
                  new Icon(Icons.menu),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppbar() {
    return new HeadBar(
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
    );
  }

  Widget _buildMenus() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildMenuTypes(),
        new Expanded(
          child: _buildMenuFoods(),
        ),
      ],
    );
  }

  Widget _buildMenuTypes() {
    return new Container(
      width: 100.0,
      color: new Color(0xfff5f5f5),
      child: new SizedBox.expand(
        child: new ListView.builder(
          itemCount: _menus == null ? 0 : _menus.length,
          itemBuilder: (BuildContext context, int i) {
            Menu menu = _menus[i];
            Row menuRow = new Row(
              children: <Widget>[],
            );
            if (menu.iconUrl != null && menu.iconUrl.isNotEmpty) {
              menuRow.children.add(
                new Container(
                  margin: new EdgeInsets.only(right: 10.0),
                  child: new Image.network(
                    Utils.getImgPath(menu.iconUrl),
                    width: 15.0,
                    height: 15.0,
                  ),
                ),
              );
            }
            menuRow.children.add(
              new Expanded(
                child: new Text(
                  menu.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            );
            return new Container(
              height: 60.0,
              padding: new EdgeInsets.symmetric(horizontal: 10.0),
              decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(
                      color: new Color(0xffebebeb),
                    ),
                  )
              ),
              child: menuRow,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuFoods() {
    return new SizedBox.expand(
      child: new ListView.builder(
        itemCount: _menus == null ? 0 : _menus.length,
        itemBuilder: (BuildContext context, int i) {
          Menu menu = _menus[i];
          Column col = new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[],
          );
          col.children.add(
            new Container(
              height: 50.0,
              padding: new EdgeInsets.symmetric(horizontal: 10.0),
              color: new Color(0xfff5f5f5),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.only(right: 5.0),
                          child: new Text(
                            menu.name,
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        new Expanded(
                          child: new Text(
                            menu.description,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 10.0,
                              color: new Color(0xff999999),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Icon(
                    Icons.more_horiz,
                    color: new Color(0xff999999),
                    size: 20.0,
                  )
                ],
              ),
            ),
          );
          for (var food in menu.foods) {
            var foodStack = new Stack(
              children: <Widget>[],
            );
            foodStack.children.add(_buildFood(food));
            if (food.attributes.length > 0) {
              Map<String, dynamic> attr = _getNewAttrTag(food);
              if (attr != null) {
                foodStack.children.add(
                    new Positioned(
                      top: -20.0,
                      left: -20.0,
                      child: new Transform.rotate(
                        angle: -Math.pi / 4,
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          color: new Color(0xff4cd964),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                '新品',
                                style: new TextStyle(
                                  color: Style.backgroundColor,
                                  fontSize: 9.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                );
              }
            }
            col.children.add(foodStack);
          }
          return col;
        },
      ),
    );
  }

  Widget _buildFood(Food food) {
    List<dynamic> tags = _getAttrTagExceptNew(food);
    var tagRow = new Row(
      children: <Widget>[],
    );
    for (Map<String, dynamic> tag in tags) {
      String color = tag['icon_color'];
      String name = tag['icon_name'];
      tagRow.children.add(
        new Container(
          margin: new EdgeInsets.only(left: 3.0),
          padding: new EdgeInsets.symmetric(horizontal: 2.0),
          decoration: new BoxDecoration(
            border: new Border.all(
              color: new Color(int.parse('0xff$color')),
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          ),
          child: new Text(
            name,
            style: new TextStyle(
              fontSize: 8.0,
              color: new Color(int.parse('0xff$color')),
            ),
          ),
        ),
      );
    }

    return new Container(
      height: 120.0,
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0).copyWith(bottom: 5.0),
      decoration: new BoxDecoration(
          color: Style.backgroundColor,
          border: new Border(
            bottom: new BorderSide(
              color: new Color(0xffebebeb),
            ),
          )
      ),
      child: new SizedBox.expand(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.only(right: 10.0),
              width: 40.0,
              height: 40.0,
              child: new Image.network(
                '${Config.ImgBaseUrl}${food.imagePath}',
              ),
            ),
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          food.name,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      tagRow,
                    ],
                  ),
                  new Text(
                    food.description,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      fontSize: 11.0,
                      color: new Color(0xff999999),
                    ),
                  ),
                  new Text(
                    '月售${food.monthSales}份  好评率${food.satisfyRate}%',
                    style: new TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  food.activity == null ? new Container() : new Row(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.symmetric(horizontal: 2.0),
                        decoration: new BoxDecoration(
                          border: new Border.all(
                            color: new Color(int.parse('0xff${food.activity['icon_color']}')),
                          ),
                          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                        ),
                        child: new Text(
                          food.activity['image_text'],
                          style: new TextStyle(
                            fontSize: 8.0,
                            color: new Color(int.parse('0xff${food.activity['image_text_color']}')),
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                            '￥',
                            style: new TextStyle(
                              fontSize: 10.0,
                              color: new Color(0xffff6600),
                            ),
                          ),
                          new Text(
                            '${food.specFoods[0].price}',
                            style: new TextStyle(
                              color: new Color(0xffff6600),
                            ),
                          ),
                          food.specifications.length == 0 ? new Container() : new Container(
                            margin: new EdgeInsets.only(left: 5.0),
                            child: new Text(
                              '起',
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: new Color(0xff666666),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Map<String, dynamic> _getNewAttrTag(Food food) {
    int index = food.attributes.indexWhere((attr) {
      String name = attr['icon_name'];
      if (name == '新') {
        return true;
      }
      return false;
    });
    if (index == -1) {
      return null;
    }
    return food.attributes[index];
  }

  List<dynamic> _getAttrTagExceptNew(Food food) {
    return food.attributes.skipWhile((attr) {
      String name = attr['icon_name'];
      if (name == '新') {
        return true;
      }
      return false;
    }).toList();
  }
}