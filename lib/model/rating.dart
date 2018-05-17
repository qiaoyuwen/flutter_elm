import 'item_rating.dart';

class Rating {
  Rating.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        avatar = json['avatar'],
        highlights = json['highlights'],
        ratedAt = json['rated_at'],
        ratingStar = json['rating_star'],
        ratingText = json['rating_text'],
        tags = json['tags'],
        timeSpentDesc = json['time_spent_desc'],
        username = json['username'],
        itemRatings = (json['item_ratings'] as List).map((item) => new ItemRating.fromJson(item)).toList();

  String id;
  String avatar;
  List<dynamic> highlights;
  String ratedAt;
  int ratingStar;
  String ratingText;
  List<dynamic> tags;
  String timeSpentDesc;
  String username;
  List<ItemRating> itemRatings;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'avatar': avatar,
    'highlights': highlights,
    'rated_at': ratedAt,
    'rating_star': ratingStar,
    'tags': tags,
    'time_spent_desc': timeSpentDesc,
    'username': username,
  };
}