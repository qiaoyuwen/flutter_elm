import 'http.dart';
import '../model/city.dart';

class Api {
  static final String _host = 'http://169.254.50.16:8001';
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
      print('getHotCites error: $e');
    }
    return citiesGroup;
  }
}