import 'http.dart';
import '../model/city.dart';
import '../model/place.dart';

class Api {
  static final String _host = 'http://169.254.247.17:8001';

  static getGuessCity() async {
    City city;
    var uri = Uri.parse('$_host/v1/cities?type=guess');
    try {
      var data = await HttpUtils.httpGetJson(uri);
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
      var data = (await HttpUtils.httpGetJson(uri)) as List;
      cities = data.map((item){
        return new City.fromJson(item);
      }).toList();
    } catch (e) {
      print('getHotCites error: $e');
    }
    return cities;
  }

  static getCitiesGroup() async {
    var citiesGroup = new Map<String, List>();
    var uri = Uri.parse('$_host/v1/cities?type=group');
    try {
      var data = (await HttpUtils.httpGetJson(uri)) as Map<String, List>;
      for (String key in data.keys) {
        citiesGroup[key] = data[key].map((item){
          return new City.fromJson(item);
        }).toList();
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
      var data = await HttpUtils.httpGetJson(uri);
      city = new City.fromJson(data);
    } catch (e) {
      print('getCityById error: $e');
    }
    return city;
  }

  static searchPlace(int cityId, String query) async {
    List<Place> places = [];
    try {
      var uri = Uri.parse('$_host/v1/pois?type=search&city_id=$cityId&keyword=$query');
      var data = await HttpUtils.httpGetJson(uri);
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
}