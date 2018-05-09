import 'sub_category.dart';

class Category {
  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        count = json['count'],
        imageUrl = json['image_url'],
        level = json['level'],
        ids = (json['ids'] as List).map((item) => item as int).toList(),
        subCategories = (json['sub_categories'] as List).map((item) => new SubCategory.fromJson(item)).toList(),
        version = json['__v'];

  int id;
  String name;
  int count;
  String imageUrl;
  List<SubCategory> subCategories;
  int level;
  List<int> ids;
  int version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'count': count,
    'image_url': imageUrl,
    'sub_categories': subCategories,
    'level': level,
    'ids': ids,
    'version': version,
  };
}