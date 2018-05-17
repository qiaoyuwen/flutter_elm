import 'food.dart';

class Menu {
  Menu.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        iconUrl = json['icon_url'],
        restaurantId = json['restaurant_id'],
        isSelected = json['is_selected'],
        type = json['type'],
        version = json['__v'],
        foods = (json['foods'] as List).map((item) => new Food.fromJson(item)).toList();

  int id;
  String name;
  String description;
  String iconUrl;
  int restaurantId;
  bool isSelected;
  int type;
  int version;
  List<Food> foods;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon_url': iconUrl,
    'restaurant_id': restaurantId,
    'is_selected': isSelected,
    'type': type,
    '__v': version,
  };
}