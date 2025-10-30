import 'package:dio/dio.dart';
import 'package:pokedex/core/network/http_client.dart';

class DioHttpClient implements IHttpClient {
  final Dio _dio;

  DioHttpClient({required String baseUrl}) : _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 15),),);

  @override
  Future<HttpResponse> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return HttpResponse(data: response.data, statusCode: response.statusCode!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HttpResponse> post(String url, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(url, data: data, queryParameters: queryParameters);
      return HttpResponse(data: response.data, statusCode: response.statusCode!);
    } catch (e) {
      rethrow;
    }
  }
}