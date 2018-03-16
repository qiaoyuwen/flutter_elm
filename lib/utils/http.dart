import 'dart:io';
import 'dart:convert';

class HttpUtils {
  static final _httpClient = new HttpClient();

  static httpGetJson(Uri uri) async {
    var request = await _httpClient.getUrl(uri);
    return _httpRequest(request);
  }

  static httpPostJson(Uri uri) async {
    var request = await _httpClient.postUrl(uri);
    return _httpRequest(request);
  }

  static _httpRequest(HttpClientRequest request) async {
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      return data;
    } else {
      return null;
    }
  }
}
