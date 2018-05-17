class ItemRating {
  ItemRating.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        foodId = json['food_id'],
        foodName = json['food_name'],
        imageHash = json['image_hash'],
        isValid = json['is_valid'];

  String id;
  int foodId;
  String foodName;
  String imageHash;
  int isValid;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'food_id': foodId,
    'food_name': foodName,
    'image_hash': imageHash,
    'is_valid': isValid,
  };
}