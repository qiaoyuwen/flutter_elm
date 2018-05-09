class SubCategory {
  SubCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        count = json['count'],
        imageUrl = json['imageUrl'],
        level = json['level'],
        _id = json['_id'];

  int id;
  String name;
  int count;
  String imageUrl;
  int level;
  String _id;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'count': count,
    'imageUrl': imageUrl,
    'level': level,
    '_id': _id,
  };
}