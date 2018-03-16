import 'http.dart';
import '../model/city.dart';

class Api {
  static final String _host = 'http://169.254.38.143:8001';
  static getHotCites() async {
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
}