
abstract class IHttpClient {
  Future<HttpResponse> get(String url, {Map<String, dynamic>? queryParameters});
  Future<HttpResponse> post(String url,
      {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters});
}

class HttpResponse {
  final dynamic data;
  final int statusCode;

  HttpResponse({
    required this.data,
    required this.statusCode,
  });
}