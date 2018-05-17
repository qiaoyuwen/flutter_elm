class RatingScore {
  RatingScore.fromJson(Map<String, dynamic> json)
      : compareRating = json['compare_rating'],
        deliverTime = json['deliver_time'],
        foodScore = json['food_score'],
        orderRatingAmount = json['order_rating_amount'],
        overallScore = json['overall_score'],
        serviceScore = json['service_score'];

  num compareRating;
  int deliverTime;
  num foodScore;
  int orderRatingAmount;
  num overallScore;
  num serviceScore;

  Map<String, dynamic> toJson() => {
    'compare_rating': compareRating,
    'deliver_time': deliverTime,
    'food_score': foodScore,
    'order_rating_amount': orderRatingAmount,
    'overall_score': overallScore,
    'service_score': serviceScore,
  };
}