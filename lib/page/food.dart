import 'package:flutter/material.dart';
import '../components/head_bar.dart';
import '../style/style.dart';
import '../components/drop_down.dart';
import '../components/shop_list.dart';
import '../model/category.dart';
import '../utils/api.dart';
import '../config/config.dart';
import '../model/sub_category.dart';

class Food extends StatefulWidget {
  Food({
    String title,
    num longitude,
    num latitude,
    String restaurantCategoryId,
  })  : title = title,
        longitude = longitude,
        latitude = latitude,
        geoHash = '$longitude,$latitude',
        restaurantCategoryId = restaurantCategoryId;

  final String title;
  final num longitude;
  final num latitude;
  final String geoHash;
  final String restaurantCategoryId;

  @override
  createState() => new FoodState();
}

class FoodState extends State<Food> {

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    getFoodCategory();
  }

  getFoodCategory() async {
    List<Category> categories = await Api.getFoodCategory(
        latitude: widget.latitude,
        longitude: widget.longitude
    );
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: widget.title,
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new Column(
        children: <Widget>[
          new _FilterContainer(
            categoryTitle: widget.title,
            categories: _categories,
            restaurantCategoryId: widget.restaurantCategoryId,
          ),
//          new Expanded(
//            child: new ShopList(widget.longitude, widget.latitude, widget.restaurantCategoryId),
//          ),
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}

class _FilterContainer extends StatelessWidget {
  _FilterContainer({
    this.categoryTitle = '',
    this.categories,
    this.restaurantCategoryId,
  });

  final String categoryTitle;
  final List<Category> categories;
  final String restaurantCategoryId;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new DropDown(
            text: categoryTitle,
            color: Style.backgroundColor,
            getOffset: () => getOffset(context),
            content: new _CategoryList(
              categories: categories,
              restaurantCategoryId: restaurantCategoryId
            ),
          ),
        ),
        new Expanded(
          child: new DropDown(
            text: '排序',
            decoration: new BoxDecoration(
              color: Style.backgroundColor,
              border: new Border(
                left: new BorderSide(color: Style.borderColor),
                right: new BorderSide(color: Style.borderColor),
              ),
            ),
            getOffset: () => getOffset(context),
            content: new Container(),
          ),
        ),
        new Expanded(
          child: new DropDown(
            text: '筛选',
            color: Style.backgroundColor,
            getOffset: () => getOffset(context),
            content: new Container(),
          ),
        ),
      ],
    );
  }

  Offset getOffset(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    return renderBox.localToGlobal(renderBox.size.bottomLeft(Offset.zero), ancestor: overlay);
  }
}

class _CategoryList extends StatefulWidget {
  _CategoryList({
    this.categories,
    this.restaurantCategoryId,
  });
  final List<Category> categories;
  final String restaurantCategoryId;

  @override
  createState() => new _CategoryListState();
}

class _CategoryListState extends State<_CategoryList> {
  int _curCategoryId = 0;
  List<SubCategory> _subCategories = [];

  @override
  Widget build(BuildContext context) {
    _curCategoryId = int.tryParse(widget.restaurantCategoryId);
    widget.categories.forEach((c) {
      if (_curCategoryId == c.id) {
        _subCategories = c.subCategories;
      }
    });
    return new Container(
      height: 40.0 * widget.categories.length,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _buildCategories(),
          ),
          Expanded(
            child: _buildSubCategories(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return new Column(
      children: widget.categories.map((category) {
        return _buildCategory(category);
      }).toList(),
    );
  }

  Widget _buildCategory(Category category) {
    return new Container(
      height: 40.0,
      padding: new EdgeInsets.all(10.0),
      color: category.id == _curCategoryId ? Style.backgroundColor : new Color(0xfff1f1f1),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(right: 7.0),
                child: new Image.network(
                  _getImgPath(category.imageUrl),
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              new Text(category.name),
            ],
          ),
          new Row(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.symmetric(horizontal: 4.0),
                margin: new EdgeInsets.only(right: 5.0),
                decoration: new BoxDecoration(
                  color: new Color(0xffcccccc),
                  borderRadius: new BorderRadius.all(
                    new Radius.circular(10.0),
                  ),
                ),
                child: new Text(
                  '${category.count}',
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              new Icon(
                Icons.arrow_forward_ios,
                color: new Color(0xffbbbbbb),
                size: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //传递过来的图片地址需要处理后才能正常使用
  String _getImgPath(String path) {
    String suffix;
    if (path == null || path.isEmpty) {
      return 'http://test.fe.ptdev.cn/elm/elmlogo.jpeg';
    }
    if (path.indexOf('jpeg') != -1) {
      suffix = '.jpeg';
    } else {
      suffix = '.png';
    }
    String url = '/' + path.substring(0, 1) + '/' + path.substring(1, 3) + '/' + path.substring(3) + suffix;
    return '${Config.ImgCdnUrl}$url';
  }

  Widget _buildSubCategories() {
    return new Container(
      color: Style.backgroundColor,
      child: new Column(
        children: _subCategories.map((sc){
          return _buildSubCategory(sc);
        }).toList(),
      ),
    );
  }

  Widget _buildSubCategory(SubCategory subCategory) {
    return new Container(
      height: 40.0,
      padding: new EdgeInsets.only(left: 10.0, top: 10.0),
      child: new Container(
        padding: new EdgeInsets.only(right: 10.0, bottom: 10.0),
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(
              color: Style.borderColor,
            )
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              subCategory.name,
            ),
            new Text(
              '${subCategory.count}',
            ),
          ],
        ),
      ),
    );
  }
}
