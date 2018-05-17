class RatingTag {
  RatingTag.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        count = json['count'],
        name = json['name'],
        unsatisfied = json['unsatisfied'];

  String id;
  int count;
  String name;
  bool unsatisfied;

  Map<String, dynamic> toJson() => {
    'id': id,
    'count': count,
    'name': name,
    'unsatisfied': unsatisfied,
  };
}