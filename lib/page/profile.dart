import 'package:flutter/material.dart';
import '../components/foot_bar.dart';
import '../style/style.dart';
import '../components/head_bar.dart';
import '../store/store.dart';
import '../routes/routes.dart';
import '../config//config.dart';

class Profile extends StatefulWidget {
  @override
  createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding);
  final _gTopMargin = new EdgeInsets.only(top: 10.0);
  final _personPadding =
      new EdgeInsets.symmetric(horizontal: Style.gPadding, vertical: 10.0);
  final _personColor = Style.backgroundColor;
  final _infoDataPadding = new EdgeInsets.all(Style.gPadding);

  String _username = '登录/注册';
  String _mobile = '暂无绑定手机号';
  int _balance = 0;
  int _count = 0;
  int _pointNumber = 0;
  String _avatar = '';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    var user = store.state.user;
    if (user != null) {
      setState(() {
        _username = user.username;
        _mobile = '暂无绑定手机号';
        if (user.mobile != null && user.mobile.isNotEmpty) {
          _mobile = user.mobile;
        }
        _balance = user.balance;
        _count = user.giftAmount;
        _pointNumber = user.point;
        _avatar = user.avatar;
      });
    } else {
      setState(() {
        _username = '登录/注册';
        _mobile = '暂无绑定手机号';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: '我的',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
        bottom: _buildPersonDetail(),
      ),
      body: new Column(
        children: <Widget>[
          _buildInfoData(),
          _buildOperatorBlock(
            children: <Widget>[
              _buildOperatorItem(
                icon: Icons.shopping_cart,
                iconColor: Style.primaryColor,
                text: '我的订单',
              ),
              _buildOperatorItem(
                icon: Icons.card_giftcard,
                iconColor: new Color(0xfffc7b53),
                text: '积分商城',
              ),
              _buildOperatorItem(
                icon: Icons.card_membership,
                iconColor: new Color(0xffffc636),
                text: '饿了么会员卡',
              ),
            ],
          ),
          _buildOperatorBlock(
            children: <Widget>[
              _buildOperatorItem(
                icon: Icons.business_center,
                iconColor: Style.primaryColor,
                text: '服务中心',
              ),
              _buildOperatorItem(
                icon: Icons.get_app,
                iconColor: Style.primaryColor,
                text: '下载饿了么APP',
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: new FootBar(
        currentIndex: 3,
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  PreferredSizeWidget _buildPersonDetail() {
    List<Widget> children = [];
    if (_avatar.isNotEmpty) {
      children.add(
        new CircleAvatar(
          backgroundImage: new NetworkImage('${Config.ImgBaseUrl}$_avatar'),
          radius: 30.0,
        )
      );
    } else {
      children.add(
        new Icon(
          Icons.account_circle,
          color: _personColor,
          size: 60.0,
        )
      );
    }
    children.addAll([
      new Expanded(
        child: new Padding(
          padding: new EdgeInsets.only(left: 5.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                _username,
                style: new TextStyle(
                  fontSize: 20.0,
                  color: _personColor,
                ),
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.smartphone,
                    color: _personColor,
                    size: 20.0,
                  ),
                  new Text(
                    _mobile,
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: _personColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      new Icon(
        Icons.arrow_forward_ios,
        color: _personColor,
        size: 15.0,
      ),
    ]);
    return new PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: new GestureDetector(
        onTap: () {
          String path;
          if (store.state.user == null) {
            path = '/login';
          } else {
            path = '/profile/login';
          }
          Routes.router.navigateTo(context, path);
        },
        child: new Container(
          color: Style.primaryColor,
          padding: _personPadding,
          child: new Row(
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoData() {
    return new Container(
      color: Style.backgroundColor,
      child: new Row(
        children: <Widget>[
          _buildInfoDataSingle(
            count: _balance.toStringAsFixed(2),
            countColor: new Color(0xffff9900),
            unit: '元',
            desc: '我的余额',
          ),
          _buildInfoDataSingle(
            count: '$_count',
            countColor: new Color(0xffff5f3e),
            unit: '个',
            desc: '我的优惠',
          ),
          _buildInfoDataSingle(
            count: '$_pointNumber',
            countColor: new Color(0xff6ac20b),
            unit: '分',
            desc: '我的积分',
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDataSingle({
    String count,
    Color countColor = Colors.black,
    String unit,
    String desc,
    bool showBorder = true,
  }) {
    return new Expanded(
      child: new Container(
        padding: _infoDataPadding,
        decoration: showBorder
            ? new BoxDecoration(
                border: new Border(
                  right: new BorderSide(
                    color: Style.borderColor,
                  ),
                ),
              )
            : null,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  count,
                  style: new TextStyle(
                    fontSize: 25.0,
                    color: countColor,
                  ),
                ),
                new Text(unit)
              ],
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 5.0),
              child: new Text(
                desc,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorBlock({
    List<Widget> children = const [],
  }) {
    return new Container(
      margin: _gTopMargin,
      color: Style.backgroundColor,
      child: new Column(
        children: children,
      ),
    );
  }

  Widget _buildOperatorItem({
    IconData icon,
    Color iconColor,
    String text,
  }) {
    return new Container(
      padding: _gPadding.copyWith(top: 10.0, bottom: 10.0),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            color: Style.borderColor,
          ),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Row(
              children: <Widget>[
                new Icon(
                  icon,
                  color: iconColor,
                  size: 18.0,
                ),
                new Padding(
                  padding: new EdgeInsets.only(left: 5.0),
                  child: new Text(
                    text,
                    style: new TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Icon(
            Icons.arrow_forward_ios,
            color: new Color(0xffbbbbbb),
            size: 15.0,
          ),
        ],
      ),
    );
  }
}
