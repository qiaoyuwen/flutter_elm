import 'package:flutter/material.dart';
import '../components/head_bar.dart';
import '../style/style.dart';
import '../components/drop_down.dart';
import '../components/shop_list.dart';
import '../model/category.dart';
import '../utils/api.dart';
import '../config/config.dart';
import '../model/sub_category.dart';

typedef void _SelectedCategoryCallBack(String categoryId, SubCategory subCategory);
typedef void _SelectedSortTypeCallBack(_SortItem sortItem);

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
  createState() => new FoodState(restaurantCategoryId, title);
}

class FoodState extends State<Food> {
  FoodState(String restaurantCategoryId, String title){
    _restaurantCategoryId = restaurantCategoryId;
    _title = title;
  }

  String _title = '';
  String _restaurantCategoryId = '';
  String _restaurantCategoryIds = '';
  List<Category> _categories = [];
  List<SubCategory> _subCategories = [];
  String _sortByType = '';

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
        title: _title,
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new Column(
        children: <Widget>[
          new _FilterContainer(
            categoryTitle: _title,
            categories: _categories,
            restaurantCategoryId: _restaurantCategoryId,
            selectedCategoryCallBack: _selectedCategoryCallBack,
            selectedSortTypeCallBack: _selectedSortTypeCallBack,
            sortByType: _sortByType,
          ),
          new Expanded(
            child: new ShopList(
              widget.longitude,
              widget.latitude,
              _restaurantCategoryId,
              restaurantCategoryIds: _restaurantCategoryIds,
              sortByType: _sortByType,
            ),
          ),
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  void _selectedCategoryCallBack(String categoryId, SubCategory subCategory) {
    setState(() {
      _title = subCategory.name;
      _restaurantCategoryId = categoryId;
      _restaurantCategoryIds = subCategory.id.toString();
    });
  }

  void _selectedSortTypeCallBack(_SortItem sortItem) {
    setState(() {
      _sortByType = sortItem.id.toString();
    });
  }
}

class _SortItem {
  const _SortItem({
    this.id = 0,
    this.title = '',
    this.icon,
  });

  final int id;
  final String title;
  final Icon icon;
}

const _SortIconSize = 20.0;
const _SortList = [
  const _SortItem(
    id: 0,
    title: '智能排序',
    icon: const Icon(
      Icons.sort,
      size: _SortIconSize,
      color: const Color(0xff3b87c8),
    ),
  ),
  const _SortItem(
    id: 5,
    title: '距离最近',
    icon: const Icon(
      Icons.place,
      size: _SortIconSize,
      color: const Color(0xff2a9bd3),
    ),
  ),
  const _SortItem(
    id: 6,
    title: '销量最高',
    icon: const Icon(
      Icons.whatshot,
      size: _SortIconSize,
      color: const Color(0xfff07373),
    ),
  ),
  const _SortItem(
    id: 1,
    title: '起送价最低',
    icon: const Icon(
      Icons.monetization_on,
      size: _SortIconSize,
      color: const Color(0xffe6b61a),
    ),
  ),
  const _SortItem(
    id: 2,
    title: '配送速度最快',
    icon: const Icon(
      Icons.access_time,
      size: _SortIconSize,
      color: const Color(0xff37c7b7),
    ),
  ),
  const _SortItem(
    id: 3,
    title: '评分最高',
    icon: const Icon(
      Icons.star_border,
      size: _SortIconSize,
      color: const Color(0xffeba53b),
    ),
  ),
];

class _FilterContainer extends StatelessWidget {
  _FilterContainer({
    this.categoryTitle = '',
    this.categories,
    this.restaurantCategoryId,
    this.selectedCategoryCallBack,
    this.selectedSortTypeCallBack,
    this.sortByType = '',
  });

  final String categoryTitle;
  final List<Category> categories;
  final String restaurantCategoryId;
  final _SelectedCategoryCallBack selectedCategoryCallBack;
  final _SelectedSortTypeCallBack selectedSortTypeCallBack;
  final sortByType;

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
              restaurantCategoryId: restaurantCategoryId,
              selectedCategoryCallBack: selectedCategoryCallBack,
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
            content: _buildSortList(context, sortByType),
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

  Widget _buildSortList(BuildContext context, String sortByType) {
    return new Column(
      children: _SortList.map((item) {
        var descRow = new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(item.title)
          ],
        );
        if (sortByType == item.id.toString()) {
          descRow.children.add(
            new Container(
              margin: new EdgeInsets.only(right: 10.0),
              child: new Icon(
                Icons.done,
                color: new Color(0xff3190e8),
              ),
            )
          );
        }

        return new GestureDetector(
          child: new Container(
            height: 50.0,
            color: Style.backgroundColor,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(left: 15.0, right: 10.0),
                  child: item.icon,
                ),
                new Expanded(
                  child: new Container(
                    decoration: new BoxDecoration(
                      border: new Border(
                        bottom: new BorderSide(
                          color: Style.borderColor,
                        ),
                      ),
                    ),
                    child: descRow,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            selectedSortTypeCallBack(item);
          },
        );
      }).toList(),
    );
  }
}

class _CategoryList extends StatefulWidget {
  _CategoryList({
    this.categories,
    this.restaurantCategoryId,
    this.selectedCategoryCallBack,
  });
  final List<Category> categories;
  final String restaurantCategoryId;
  final _SelectedCategoryCallBack selectedCategoryCallBack;

  @override
  createState() => new _CategoryListState(restaurantCategoryId);
}

class _CategoryListState extends State<_CategoryList> {
  _CategoryListState(String restaurantCategoryId){
    _curCategoryId = int.tryParse(restaurantCategoryId);
  }
  int _curCategoryId = 0;
  List<SubCategory> _subCategories = [];

  @override
  Widget build(BuildContext context) {
    widget.categories.forEach((c) {
      if (_curCategoryId == c.id) {
        _subCategories = c.subCategories;
      }
    });
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _buildCategories(),
        ),
        Expanded(
          child: _buildSubCategories(),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return new Container(
      height: 40.0 * widget.categories.length,
      child: new Column(
        children: widget.categories.map((category) {
          return _buildCategory(category);
        }).toList(),
      ),
    );
  }

  Widget _buildCategory(Category category) {
    return new GestureDetector(
      child: new Container(
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
      ),
      onTap: () => _selectCategory(category),
    );
  }

  void _selectCategory(Category category) {
    setState(() {
      _curCategoryId = category.id;
    });
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
      height: 40.0 * widget.categories.length,
      decoration: new BoxDecoration(
        color: Style.backgroundColor,
      ),
      child: new ListView.builder(
        itemCount: _subCategories.length,
        itemBuilder: (context, i) {
          return _buildSubCategory(_subCategories[i]);
        },
      ),
    );
  }

  Widget _buildSubCategory(SubCategory subCategory) {
    return new GestureDetector(
      child: new Container(
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
      ),
      onTap: () {
        widget.selectedCategoryCallBack(_curCategoryId.toString(), subCategory);
        Navigator.pop(context);
      },
    );
  }
}
