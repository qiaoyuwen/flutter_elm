import 'http.dart';

class Api {
  static final String _host = 'http://127.0.0.1:8001';
  static getHotCites() async {
    var uri = Uri.parse('$_host/v1/cities?type=hot');
    return await HttpUtils.httpGet(uri);
  }
}