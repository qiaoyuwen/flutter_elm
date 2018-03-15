import 'dart:io';
import 'dart:convert';

class HttpUtils {
  static final _httpClient = new HttpClient();

  static httpGet(Uri uri) async {
    var request = await _httpClient.getUrl(uri);
    return _httpRequest(request);
  }

  static httpPost(Uri uri) async {
    var request = await _httpClient.postUrl(uri);
    return _httpRequest(request);
  }

  static _httpRequest(HttpClientRequest request) async {
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    return responseBody;
  }
}
