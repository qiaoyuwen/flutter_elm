import 'spec_food.dart';

class Food {
  Food.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        activity = json['activity'],
        attributes = json['attributes'],
        attrs = json['attrs'],
        categoryId = json['category_id'],
        description = json['description'],
        displayTimes = json['display_times'],
        imagePath = json['image_path'],
        isEssential = json['is_essential'],
        isFeatured = json['is_featured'],
        itemId = json['item_id'],
        monthSales = json['month_sales'],
        name = json['name'],
        pinyinName = json['pinyin_name'],
        rating = json['rating'],
        ratingCount = json['rating_count'],
        restaurantId = json['restaurant_id'],
        satisfyCount = json['satisfy_count'],
        satisfyRate = json['satisfy_rate'],
        serverUtc = json['server_utc'],
        specifications = json['specifications'],
        tips = json['tips'],
        version = json['__v'],
        specFoods = (json['specfoods'] as List).map((item) => new SpecFood.fromJson(item)).toList();

  String id;
  Map<String, dynamic> activity;
  List<dynamic> attributes;
  List<dynamic> attrs;
  int categoryId;
  String description;
  List<dynamic> displayTimes;
  String imagePath;
  bool isEssential;
  int isFeatured;
  int itemId;
  int monthSales;
  String name;
  String pinyinName;
  num rating;
  int ratingCount;
  int restaurantId;
  int satisfyCount;
  int satisfyRate;
  String serverUtc;
  List<dynamic> specifications;
  String tips;
  int version;
  List<SpecFood> specFoods;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'activity': activity,
    'attributes': attributes,
    'attrs': attrs,
    'category_id': categoryId,
    'description': description,
    'display_times': displayTimes,
    'image_path': imagePath,
    'is_essential': isEssential,
    'is_featured': isFeatured,
    'item_id': itemId,
    'month_sales': monthSales,
    'name': name,
    'pinyin_name': pinyinName,
    'rating': rating,
    'rating_count': ratingCount,
    'restaurant_id': restaurantId,
    'satisfy_count': satisfyCount,
    'satisfy_rate': satisfyRate,
    'server_utc': serverUtc,
    'specifications': specifications,
    'tips': tips,
    '__v': version,
  };
}