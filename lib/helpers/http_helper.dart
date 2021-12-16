import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpClientFactory {
  static Client getClient() {
    // TODO: Use SSL pinning.
    var httpClient =
        HttpClientWithInterceptor.build(interceptors: [AuthInterceptor()]);
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
      {Map<String, String> headers,
      Map<String, dynamic> parameters,
      int attempts = 1}) {
    var finalUrl = _addUrlParameters(url, parameters);
    return tryPerformRequest(
        () => _httpClient.get(Uri.parse(finalUrl), headers: headers), attempts);
  }

  Future<Response> post(String url,
      {Map<String, String> headers,
      String body,
      Map<String, dynamic> parameters,
      int attempts = 1}) {
    var finalUrl = _addUrlParameters(url, parameters);
    return tryPerformRequest(
        () =>
            _httpClient.post(Uri.parse(finalUrl), headers: headers, body: body),
        attempts);
  }

  Future<Response> put(String url,
      {Map<String, String> headers,
      String body,
      Map<String, dynamic> parameters,
      int attempts = 1}) {
    var finalUrl = _addUrlParameters(url, parameters);
    return tryPerformRequest(
        () =>
            _httpClient.put(Uri.parse(finalUrl), headers: headers, body: body),
        attempts);
  }

  Future<Response> delete(String url,
      {Map<String, String> headers,
      Map<String, dynamic> parameters,
      int attempts = 1}) {
    var finalUrl = _addUrlParameters(url, parameters);
    return tryPerformRequest(
        () => _httpClient.delete(Uri.parse(finalUrl), headers: headers),
        attempts);
  }

  Future<Response> tryPerformRequest(Future<Response> func(),
      [int attempts = 1]) async {
    attempts = attempts < 1 ? 1 : attempts;
    Response response;
    int attemptsMade = 0;
    while (!isSuccessfulResponse(response) && attemptsMade < attempts) {
      response = await func.call();
      ++attemptsMade;
    }
    return response;
  }

  bool isSuccessfulResponse(Response response) {
    return response != null &&
        response.statusCode >= 200 &&
        response.statusCode <= 299;
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
