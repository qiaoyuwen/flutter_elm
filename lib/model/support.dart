class Support {
  Support.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['_id'],
        name = json['name'],
        iconName = json['icon_name'],
        iconColor = json['icon_color'],
        description = json['description'];

  int id;
  String uid;
  String name;
  String iconName;
  String iconColor;
  String description;

  Map<String, dynamic> toJson() => {
    'id': id,
    '_id': uid,
    'name': name,
    'icon_name': iconName,
    'icon_color': iconColor,
    'description': description,
  };
}
