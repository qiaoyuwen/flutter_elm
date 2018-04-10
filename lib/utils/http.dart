import 'dart:io';
import 'dart:convert';

class HttpUtils {
  static final _httpClient = new HttpClient();
  static final List<Cookie> _cookies = [];

  static httpGet(Uri uri) async {
    HttpClientRequest request = await _httpClient.getUrl(uri);
    request.cookies.addAll(_cookies);
    return _httpRequest(request);
  }

  static httpPost(Uri uri) async {
    HttpClientRequest request = await _httpClient.postUrl(uri);
    request.cookies.addAll(_cookies);
    return _httpRequest(request);
  }

  static httpPostJson(
    Uri uri, {
    Map<String, dynamic> jsonBody = const {},
  }) async {
    final String requestBody = json.encode(jsonBody);
    HttpClientRequest request = await _httpClient.postUrl(uri)
      ..headers.add(HttpHeaders.ACCEPT, ContentType.JSON)
      ..headers.contentType = ContentType.JSON
      ..headers.contentLength = requestBody.length
      ..headers.chunkedTransferEncoding = false;
    request.cookies.addAll(_cookies);
    if (jsonBody != null) {
      request.write(requestBody);
    }
    return _httpRequest(request);
  }

  static _httpRequest(HttpClientRequest request) async {
    HttpClientResponse response = await request.close();
    if (response.headers.contentType.toString() != ContentType.JSON.toString()) {
      throw new UnsupportedError('Server returned an unsupported content type: '
          '${response.headers.contentType} from ${request.uri}');
    }
    if (response.statusCode == HttpStatus.OK) {
      if (response.cookies.isNotEmpty) {
        _cookies.clear();
        _cookies.addAll(response.cookies);
      }
      var json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      return data;
    } else {
      return null;
    }
  }
}
