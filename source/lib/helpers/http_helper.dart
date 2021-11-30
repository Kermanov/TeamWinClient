import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpClientFactory {
  static Client getClient() {
    var httpClient =
        HttpClientWithInterceptor.build(interceptors: [AuthInterceptor()])
          ..badCertificateCallback =
              // TODO: Use real certificate.
              (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }
}

class HttpHelper {
  Client _httpClient = HttpClientFactory.getClient();

  static String _addUrlParameters(String url, Map<String, dynamic> parameters) {
    if (parameters != null) {
      url += "?";
      for (var parameter in parameters.entries) {
        url += "&" + parameter.key + "=" + parameter.value.toString();
      }
    }
    return url;
  }

  Future<Response> get(String url,
      {Map<String, String> headers, Map<String, dynamic> parameters}) async {
    var finalUrl = _addUrlParameters(url, parameters);
    return await _httpClient.get(Uri.parse(finalUrl), headers: headers);
  }

  Future<Response> post(String url,
      {Map<String, String> headers,
      String body,
      Map<String, dynamic> parameters}) async {
    var finalUrl = _addUrlParameters(url, parameters);
    return await _httpClient.post(Uri.parse(finalUrl),
        headers: headers, body: body);
  }

  Future<Response> delete(String url,
      {Map<String, String> headers, Map<String, dynamic> parameters}) async {
    var finalUrl = _addUrlParameters(url, parameters);
    return await _httpClient.delete(Uri.parse(finalUrl), headers: headers);
  }
}

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    var accessToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (accessToken != null) {
      data.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";
    }
    data.headers[HttpHeaders.contentTypeHeader] = "application/json";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
