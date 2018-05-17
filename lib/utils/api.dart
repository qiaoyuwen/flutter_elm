import 'http.dart';
import '../model/city.dart';
import '../model/place.dart';
import '../model/food_type.dart';
import '../model/restaurant.dart';
import '../model/category.dart';
import '../model/delivery_mode.dart';
import '../model/activity.dart';
import '../model/menu.dart';
import '../model/rating.dart';
import '../model/rating_score.dart';
import '../model/rating_tag.dart';

class Api {
  static final String _host = 'http://cangdu.org:8001';

  static getGuessCity() async {
    City city;
    var uri = Uri.parse('$_host/v1/cities?type=guess');
    try {
      var data = await HttpUtils.httpGet(uri);
      city = new City.fromJson(data);
    } catch (e) {
      print('getGuessCity error: $e');
    }
    return city;
  }

  static getHotCities() async {
    var cities = const [];
    var uri = Uri.parse('$_host/v1/cities?type=hot');
    try {
      var data = (await HttpUtils.httpGet(uri)) as List;
      cities = data.map((item) {
        return new City.fromJson(item);
      }).toList();
    } catch (e) {
      print('getHotCites error: $e');
    }
    return cities;
  }

  static getCitiesGroup() async {
    var citiesGroup = new Map<String, List<City>>();
    var uri = Uri.parse('$_host/v1/cities?type=group');
    try {
      var data = (await HttpUtils.httpGet(uri)) as Map<String, dynamic>;
      for (String key in data.keys) {
        var group = data[key];
        if (group is List) {
          citiesGroup[key] = group.map((item) {
            return new City.fromJson(item);
          }).toList();
        }
      }
    } catch (e) {
      print('getCitesGroup error: $e');
    }
    return citiesGroup;
  }

  static getCityById(int id) async {
    City city;
    try {
      var uri = Uri.parse('$_host/v1/cities/${id.toString()}');
      var data = await HttpUtils.httpGet(uri);
      city = new City.fromJson(data);
    } catch (e) {
      print('getCityById error: $e');
    }
    return city;
  }

  static searchPlace(int cityId, String query) async {
    List<Place> places = [];
    try {
      var uri = Uri
          .parse('$_host/v1/pois?type=search&city_id=$cityId&keyword=$query');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        places = data.map((item) {
          return new Place.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('searchPlace error: $e');
    }
    return places;
  }

  static getPlace(String geohash) async {
    Place place;
    try {
      var uri = Uri.parse('$_host/v2/pois/$geohash');
      var data = await HttpUtils.httpGet(uri);
      place = new Place.fromJson(data);
    } catch (e) {
      print('getPlace error: $e');
    }
    return place;
  }

  static getFoodTypes(String geohash) async {
    List<FoodType> foodTypes = [];
    try {
      var uri =
          Uri.parse('$_host/v2/index_entry?geohash=$geohash&group_type=1&${Uri
          .encodeComponent('flags[]')}=F');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        foodTypes = data.map((item) {
          return new FoodType.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('getFoodTypes error: $e');
    }
    return foodTypes;
  }

  static getRestaurants(
    num latitude,
    num longitude,
    int offset, {
    String restaurantCategoryId = '',
    String restaurantCategoryIds = '',
    String orderBy = '',
    String deliveryMode = '',
    List<int> supportIds = const [],
    int limit = 20,
  }) async {
    List<Restaurant> restaurants = [];
    try {
      String url =
          '$_host/shopping/restaurants?latitude=$latitude&longitude=$longitude&offset=$offset&limit=$limit';
      url += '&${Uri.encodeComponent('extras[]')}=activities';
      url += '&keyword=';
      url += '&restaurant_category_id=$restaurantCategoryId';
      url += '&${Uri.encodeComponent(
          'restaurant_category_ids[]')}=$restaurantCategoryIds';
      url += '&order_by=$orderBy';

      String supportStr = '';
      for (var support in supportIds) {
        supportStr += '&${Uri.encodeComponent('support_ids[]')}=$support';
      }
      url +=
          '&${Uri.encodeComponent('delivery_mode[]')}=${deliveryMode + supportStr}';
      var uri = Uri.parse(url);
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        restaurants = data.map((item) {
          return new Restaurant.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('getRestaurants error: $e');
    }
    return restaurants;
  }

  static getAuthCode() async {
    var code = '';
    try {
      var uri = Uri.parse('$_host/v1/captchas');
      var data = await HttpUtils.httpPost(uri);
      code = data['code'];
    } catch (e) {
      print('getAuthCode error: $e');
    }
    return code;
  }

  static accountLogin(String username, String password, String authCode) async {
    var data;
    try {
      var uri = Uri.parse('$_host/v2/login');
      data = await HttpUtils.httpPostJson(
        uri,
        jsonBody: {
          'username': username,
          'password': password,
          'captcha_code': authCode,
        },
      );
    } catch (e) {
      print('accountLogin error: $e');
    }
    return data;
  }

  static searchRestaurant(String geoHash, String keyword) async {
    List<Restaurant> result = [];
    try {
      var uri = Uri.parse('$_host/v4/restaurants?${Uri.encodeComponent(
          'extras[]')}=restaurant_activity&geohash=$geoHash&keyword=$keyword&type=search');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new Restaurant.fromJson(item)).toList();
      }
    } catch (e) {
      print('searchRestaurant error: $e');
    }
    return result;
  }

  static getFoodCategory({num latitude, num longitude}) async {
    List<Category> result = [];
    try {
      var uri = Uri.parse('$_host/shopping/v2/restaurant/category?latitude=$latitude&longitude=$longitude');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new Category.fromJson(item)).toList();
      }
    } catch (e) {
      print('getFoodCategory error: $e');
    }
    return result;
  }

  static getFoodDelivery({num latitude, num longitude}) async {
    List<DeliveryMode> result = [];
    try {
      var uri = Uri.parse('$_host/shopping/v1/restaurants/delivery_modes?latitude=$latitude&longitude=$longitude&kw=');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new DeliveryMode.fromJson(item)).toList();
      }
    } catch (e) {
      print('getFoodDelivery error: $e');
    }
    return result;
  }

  static getFoodActivity({num latitude, num longitude}) async {
    List<Activity> result = [];
    try {
      var uri = Uri.parse('$_host/shopping/v1/restaurants/activity_attributes?latitude=$latitude&longitude=$longitude&kw=');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new Activity.fromJson(item)).toList();
      }
    } catch (e) {
      print('getFoodActivity error: $e');
    }
    return result;
  }

  static getShopById({
    String shopId,
    num latitude,
    num longitude,
  }) async {
    Restaurant result;
    try {
      String extrasEncode = Uri.encodeComponent('extras[]');
      String url = '$_host/shopping/restaurant/$shopId?latitude=$latitude&longitude=$longitude';
      url += '&$extrasEncode=activities&$extrasEncode=album&$extrasEncode=license&$extrasEncode=identification&$extrasEncode=statistics';
      var uri = Uri.parse(url);
      var data = await HttpUtils.httpGet(uri);
      result = new Restaurant.fromJson(data);
    } catch (e) {
      print('getShopById error: $e');
    }
    return result;
  }

  static getMenus(String shopId) async {
    List<Menu> result = [];
    try {
      var uri = Uri.parse('$_host/shopping/v2/menu?restaurant_id=$shopId');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new Menu.fromJson(item)).toList();
      }
    } catch (e) {
      print('getMenu error: $e');
    }
    return result;
  }

  static getRatings({
    String shopId,
    int offset,
    String tagName = '',
  }) async {
    List<Rating> result = [];
    try {
      var uri = Uri.parse('$_host/ugc/v2/restaurants/$shopId/ratings?has_content=true&offset=$offset&limit=10&tag_name=$tagName');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new Rating.fromJson(item)).toList();
      }
    } catch (e) {
      print('getRatings error: $e');
    }
    return result;
  }

  static getRatingScore(String shopId) async {
    RatingScore result;
    try {
      var uri = Uri.parse('$_host/ugc/v2/restaurants/$shopId/ratings/scores');
      var data = await HttpUtils.httpGet(uri);
      result = new RatingScore.fromJson(data);
    } catch (e) {
      print('getRatingScores error: $e');
    }
    return result;
  }

  static getRatingTags(String shopId) async {
    List<RatingTag> result = [];
    try {
      var uri = Uri.parse('$_host/ugc/v2/restaurants/$shopId/ratings/tags');
      var data = await HttpUtils.httpGet(uri);
      if (data is List) {
        result = data.map((item) => new RatingTag.fromJson(item)).toList();
      }
    } catch (e) {
      print('getRatingTags error: $e');
    }
    return result;
  }
}
