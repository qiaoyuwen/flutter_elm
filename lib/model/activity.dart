class Activity {
  Activity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        iconName = json['icon_name'],
        iconColor = json['icon_color'],
        description = json['description'],
        rankingWeight = json['ranking_weight'],
        version = json['__v'];

  int id;
  String name;
  String iconName;
  String iconColor;
  String description;
  int rankingWeight;
  int version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon_name': iconName,
    'icon_color': iconColor,
    'description': description,
    'ranking_weight': rankingWeight,
    '__v': version,
  };
}