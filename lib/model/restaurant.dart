import 'support.dart';
import 'delivery_mode.dart';

class Restaurant {
  Restaurant.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        location = json['location'],
        address = json['address'],
        phone = json['phone'],
        category = json['category'],
        supports = (json['supports'] as List).map((item) => new Support.fromJson(item)).toList(),
        status = json['status'],
        recentOrderNum = json['recent_order_num'],
        ratingCount = json['rating_count'],
        rating = json['rating'],
        promotionInfo = json['promotion_info'],
        piecewiseAgentFee = json['piecewise_agent_fee'],
        openingHours = json['opening_hours'],
        license = json['license'],
        isNew = json['is_new'],
        isPremium = json['is_premium'],
        imagePath = json['image_path'],
        floatMinimumOrderAmount = json['float_minimum_order_amount'],
        floatDeliveryFee = json['float_delivery_fee'],
        distance = json['distance'],
        orderLeadTime = json['order_lead_time'],
        description = json['description'],
        deliveryMode = new DeliveryMode.fromJson(json['delivery_mode']),
        activities = json['activities'],
        version = json['__v'];

  int id;
  String name;
  num longitude;
  num latitude;
  List<num> location;
  String address;
  String phone;
  String category;
  List<Support> supports;
  int status;
  int recentOrderNum;
  int ratingCount;
  num rating;
  String promotionInfo;
  Map<String, String> piecewiseAgentFee;
  List<String> openingHours;
  Map<String, String> license;
  bool isNew;
  bool isPremium;
  String imagePath;
  num floatMinimumOrderAmount;
  num floatDeliveryFee;
  String distance;
  String orderLeadTime;
  String description;
  DeliveryMode deliveryMode;
  List<dynamic> activities;
  int version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'longitude': longitude,
    'latitude': latitude,
    'location': location,
    'address': address,
    'phone': phone,
    'category': category,
    'supports': supports,
    'status': status,
    'recent_order_num': recentOrderNum,
    'rating_count': ratingCount,
    'rating': rating,
    'promotion_info': promotionInfo,
    'piecewise_agent_fee': piecewiseAgentFee,
    'opening_hours': openingHours,
    'license': license,
    'is_new': isNew,
    'is_premium': isPremium,
    'image_path': imagePath,
    'float_minimum_order_amount': floatMinimumOrderAmount,
    'float_delivery_fee': floatDeliveryFee,
    'distance': distance,
    'order_lead_time': orderLeadTime,
    'description': description,
    'delivery_mode': deliveryMode,
    'activities': activities,
    '__v': version,
  };
}