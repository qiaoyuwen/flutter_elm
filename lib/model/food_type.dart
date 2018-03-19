class FoodType {
  FoodType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        isInServing = json['is_in_serving'],
        link = json['link'],
        imageUrl = json['image_url'],
        iconUrl = json['icon_url'],
        titleColor = json['title_color'],
        version = json['__v'];

  int id;
  String title;
  String description;
  bool isInServing;
  String link;
  String imageUrl;
  String iconUrl;
  String titleColor;
  int version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': title,
    'abbr': description,
    'is_in_serving': isInServing,
    'link': link,
    'image_url': imageUrl,
    'icon_url': iconUrl,
    'title_olor': titleColor,
    '__v': version,
  };
}