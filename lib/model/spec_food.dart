class SpecFood {
  SpecFood.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        checkoutMode = json['checkout_mode'],
        foodId = json['food_id'],
        isEssential = json['is_essential'],
        itemId = json['item_id'],
        name = json['name'],
        originalPrice = json['original_price'],
        packingFee = json['packing_fee'],
        pinyinName = json['pinyin_name'],
        price = json['price'],
        promotionStock = json['promotion_stock'],
        recentPopularity = json['recent_popularity'],
        recentRating = json['recent_rating'],
        restaurantId = json['restaurant_id'],
        skuId = json['sku_id'],
        soldOut = json['sold_out'],
        specs = json['specs'],
        specsName = json['specs_name'],
        stock = json['stock'];

  String id;
  int checkoutMode;
  int foodId;
  bool isEssential;
  int itemId;
  String name;
  int originalPrice;
  num packingFee;
  String pinyinName;
  int price;
  int promotionStock;
  int recentPopularity;
  num recentRating;
  int restaurantId;
  int skuId;
  bool soldOut;
  List<dynamic> specs;
  String specsName;
  int stock;


  Map<String, dynamic> toJson() => {
    '_id': id,
    'checkout_mode': checkoutMode,
    'food_id': foodId,
    'is_essential': isEssential,
    'item_id': itemId,
    'name': name,
    'original_price': originalPrice,
    'packing_fee': packingFee,
    'pinyin_name': pinyinName,
    'price': price,
    'promotion_stock': promotionStock,
    'recent_popularity': recentPopularity,
    'recent_rating': recentRating,
    'restaurant_id': restaurantId,
    'sku_id': skuId,
    'sold_out': soldOut,
    'specs': specs,
    'specs_name': specsName,
    'stock': stock,
  };
}