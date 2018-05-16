import 'package:flutter/material.dart';
import '../components/head_bar.dart';
import '../style/style.dart';
import '../components/drop_down.dart';
import '../components/shop_list.dart';
import '../model/category.dart';
import '../utils/api.dart';
import '../config/config.dart';
import '../model/sub_category.dart';
import '../model/delivery_mode.dart';
import '../model/activity.dart';
import '../components/button.dart';

typedef void _SelectedCategoryCallBack(String categoryId, SubCategory subCategory);
typedef void _SelectedSortTypeCallBack(_SortItem sortItem);
typedef void _SelectedPropertyFilterCallBack(int id, bool checked);
typedef void _SubmitPropertiesFilterCallBack(String deliveryMode, List<int> supportIds);

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
  List<DeliveryMode> _deliveryModes = [];
  List<Activity> _activities = [];
  String _selectedDeliveryMode = '';
  List<int> _selectedActivities = [];

  @override
  void initState() {
    super.initState();
    getFoodCategory();
    getFoodDelivery();
    getFoodActivity();
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

  getFoodDelivery() async {
    List<DeliveryMode> deliveryModes = await Api.getFoodDelivery(
        latitude: widget.latitude,
        longitude: widget.longitude
    );
    setState(() {
      _deliveryModes = deliveryModes;
    });
  }

  getFoodActivity() async {
    List<Activity> activities = await Api.getFoodActivity(
        latitude: widget.latitude,
        longitude: widget.longitude
    );
    setState(() {
      _activities = activities;
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
          new _FilterBar(
            categoryTitle: _title,
            categories: _categories,
            restaurantCategoryId: _restaurantCategoryId,
            selectedCategoryCallBack: _selectedCategoryCallBack,
            selectedSortTypeCallBack: _selectedSortTypeCallBack,
            sortByType: _sortByType,
            deliveryModes: _deliveryModes,
            activities: _activities,
            selectedDeliveryMode: _selectedDeliveryMode,
            selectedActivities: _selectedActivities,
            submitPropertiesFilterCallBack: _submitPropertiesFilterCallBack,
          ),
          new Expanded(
            child: new ShopList(
              widget.longitude,
              widget.latitude,
              _restaurantCategoryId,
              restaurantCategoryIds: _restaurantCategoryIds,
              sortByType: _sortByType,
              deliveryMode: _selectedDeliveryMode,
              supportsIds: _selectedActivities,
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

  void _submitPropertiesFilterCallBack(String deliveryMode, List<int> supportIds) {
    setState(() {
      _selectedDeliveryMode = deliveryMode;
      _selectedActivities = supportIds;
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

class _FilterBar extends StatelessWidget {
  _FilterBar({
    this.categoryTitle = '',
    this.categories,
    this.restaurantCategoryId,
    this.selectedCategoryCallBack,
    this.selectedSortTypeCallBack,
    this.sortByType = '',
    this.deliveryModes,
    this.activities,
    this.selectedDeliveryMode,
    this.selectedActivities,
    this.submitPropertiesFilterCallBack,
  });

  final String categoryTitle;
  final List<Category> categories;
  final String restaurantCategoryId;
  final _SelectedCategoryCallBack selectedCategoryCallBack;
  final _SelectedSortTypeCallBack selectedSortTypeCallBack;
  final sortByType;
  final List<DeliveryMode> deliveryModes;
  final List<Activity> activities;
  final String selectedDeliveryMode;
  final List<int> selectedActivities;
  final _SubmitPropertiesFilterCallBack submitPropertiesFilterCallBack;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new DropDown(
            text: categoryTitle,
            color: Style.backgroundColor,
            getOffset: () => getOffset(context),
            content: new _CategoryFilter(
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
            content: new _PropertyFilter(
              deliveryModes: deliveryModes,
              activities: activities,
              selectedDelivery: selectedDeliveryMode,
              selectedActivities: selectedActivities,
              submitPropertiesFilterCallBack: submitPropertiesFilterCallBack,
            ),
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

class _CategoryFilter extends StatefulWidget {
  _CategoryFilter({
    this.categories,
    this.restaurantCategoryId,
    this.selectedCategoryCallBack,
  });
  final List<Category> categories;
  final String restaurantCategoryId;
  final _SelectedCategoryCallBack selectedCategoryCallBack;

  @override
  createState() => new _CategoryFilterState(restaurantCategoryId);
}

class _CategoryFilterState extends State<_CategoryFilter> {
  _CategoryFilterState(String restaurantCategoryId){
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

class _PropertyFilter extends StatefulWidget {
  _PropertyFilter({
    this.deliveryModes = const [],
    this.activities = const [],
    this.selectedDelivery = '',
    this.selectedActivities = const [],
    this.submitPropertiesFilterCallBack,
  });

  final List<DeliveryMode> deliveryModes;
  final List<Activity> activities;
  final String selectedDelivery;
  final List<int> selectedActivities;
  final _SubmitPropertiesFilterCallBack submitPropertiesFilterCallBack;

  @override
  State<StatefulWidget> createState() {
    return new _PropertyFilterState(selectedDelivery, selectedActivities);
  }
}

class _PropertyFilterState extends State<_PropertyFilter> {
  _PropertyFilterState(String selectedDelivery, List<int> selectedActivities){
    _selectedDelivery = selectedDelivery;
    _selectedActivities.addAll(selectedActivities);
  }
  String _selectedDelivery = '';
  List<int> _selectedActivities = [];

  final _gPadding = new EdgeInsets.all(10.0);
  final _colCount = 3;

  @override
  Widget build(BuildContext context) {
    var deliveryCol = new Column(
      children: <Widget>[],
    );
    Row deliveryRow;
    for (int i = 0; i < widget.deliveryModes.length; ++i) {
      if (i % _colCount == 0) {
        deliveryRow = new Row(
          children: <Widget>[],
        );
        deliveryCol.children.add(
          new Container(
            margin: new EdgeInsets.only(bottom: 5.0),
            child: deliveryRow,
          )
        );
      }
      int id = widget.deliveryModes[i].id;
      String text = widget.deliveryModes[i].text;
      String color = '0xff${widget.deliveryModes[i].color}';
      String tag = text.substring(0, 1);
      bool checked = _selectedDelivery == id.toString();
      deliveryRow.children.add(
        new Expanded(
          child: new Container(
            margin: new EdgeInsets.only(right: i % _colCount != 2 ? 5.0 : 0.0),
            child: new _CheckedBtn(
              id: id,
              tag: tag,
              tagColor: new Color(int.parse(color)),
              text: text,
              onTap: _deliverySelected,
              checked: checked,
            ),
          ),
        )
      );
    }
    if (deliveryRow != null && deliveryRow.children.length < _colCount) {
      for (int i = deliveryRow.children.length; i < _colCount; i++) {
        deliveryRow.children.add(new Expanded(child: new Container()));
      }
    }
    
    var activityCol = new Column(
      children: <Widget>[],
    );
    Row activityRow;
    for (int i = 0; i < widget.activities.length; ++i) {
      if (i % _colCount == 0) {
        activityRow = new Row(
          children: <Widget>[],
        );
        activityCol.children.add(
          new Container(
            margin: new EdgeInsets.only(bottom: 5.0),
            child: activityRow,
          )
        );
      }
      int id = widget.activities[i].id;
      String text = widget.activities[i].name;
      String color = '0xff${widget.activities[i].iconColor}';
      String tag = widget.activities[i].iconName;
      bool checked = _selectedActivities.contains(id);
      activityRow.children.add(
          new Expanded(
            child: new Container(
              margin: new EdgeInsets.only(right: i % _colCount != 2 ? 5.0 : 0.0),
              child: new _CheckedBtn(
                id: id,
                tag: tag,
                tagColor: new Color(int.parse(color)),
                text: text,
                onTap: _activitySelected,
                checked: checked,
              ),
            ),
          )
      );
    }
    if (activityRow != null && activityRow.children.length < _colCount) {
      for (int i = activityRow.children.length; i < _colCount; i++) {
        activityRow.children.add(new Expanded(child: new Container()));
      }
    }

    int selectedCount = (_selectedDelivery.isEmpty ? 0 : 1) + _selectedActivities.length;
    return new Column(
      children: <Widget>[
        new Container(
          color: Style.backgroundColor,
          padding: _gPadding,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text('配送方式'),
              new Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: deliveryCol,
              ),
              new Container(
                margin: new EdgeInsets.only(top: 5.0),
                child: new Text('商家属性（可以多选）'),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: activityCol,
              ),
            ],
          ),
        ),
        new Container(
          color: Style.emptyBackgroundColor,
          padding: _gPadding,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Container(
                  margin: new EdgeInsets.only(right: 10.0),
                  child: new Button(
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: Style.backgroundColor,
                      borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                    ),
                    text: new Text(
                        '清空',
                        style: new TextStyle(
                          fontSize: 18.0,
                        )
                    ),
                    onTap: _clear,
                  ),
                ),
              ),
              new Expanded(
                child: new Button(
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: new Color(0xff56d176),
                    borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                  ),
                  text: new Text(
                      '确定${selectedCount > 0 ? '($selectedCount)' : ''}',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: new Color(0xffffffff),
                      )
                  ),
                  onTap: _submit,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _deliverySelected(int id, bool checked) {
    setState(() {
      if (checked) {
        _selectedDelivery = id.toString();
      } else {
        _selectedDelivery = '';
      }
    });
  }

  void _activitySelected(int id, bool checked) {
    setState(() {
      if (checked) {
        _selectedActivities.add(id);
      } else {
        _selectedActivities.remove(id);
      }
    });
  }

  void _clear() {
    setState(() {
      _selectedDelivery = '';
      _selectedActivities = [];
    });
  }

  void _submit() {
    Navigator.pop(context);
    widget.submitPropertiesFilterCallBack(_selectedDelivery, _selectedActivities);
  }
}

class _CheckedBtn extends StatelessWidget {
  _CheckedBtn({
    this.id,
    this.tag,
    this.tagColor,
    this.text,
    this.onTap,
    this.checked = false,
  });
  final int id;
  final String tag;
  final Color tagColor;
  final String text;
  final _SelectedPropertyFilterCallBack onTap;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    var descRow = new Row(
      children: <Widget>[],
    );
    if (checked) {
      descRow.children.add(
          new Container(
            width: 25.0,
            height: 25.0,
            child: new Icon(
              Icons.done,
              color: new Color(0xff3190e8),
            ),
          )
      );
    } else {
      descRow.children.add(
          new Container(
            width: 25.0,
            height: 25.0,
            decoration: new BoxDecoration(
              border: new Border.all(
                color: tagColor,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            ),
            child: new Center(
              child: new Text(
                tag,
                style: new TextStyle(
                    color: tagColor
                ),
              ),
            ),
          )
      );
    }
    descRow.children.add(
      new Container(
        margin: new EdgeInsets.only(left: 5.0),
        child: new Text(
          text,
          style: new TextStyle(
            color: checked ? new Color(0xff3190e8) : null,
          ),
        ),
      ),
    );
    return new GestureDetector(
      child: new Container(
        padding: new EdgeInsets.all(7.0),
        decoration: new BoxDecoration(
          border: new Border.all(
            color: Style.borderColor,
          ),
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
        ),
        child: descRow,
      ),
      onTap: _onClick,
    );
  }

  void _onClick() {
    onTap(id, !checked);
  }
}