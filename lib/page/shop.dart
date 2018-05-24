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
}