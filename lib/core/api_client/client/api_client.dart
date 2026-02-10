// lib/core/api_client/client/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/api_client/interceptors/auth_interceptor.dart';
import 'package:legal_defender/core/api_client/interceptors/logging_interceptor.dart';
import 'package:legal_defender/core/errors/exceptions.dart';

@lazySingleton
class ApiClient {
  final Dio _dio;

  // Static helpers to fix the "getter not defined" error
  static Options get protected => Options(headers: {'requiresToken': true});
  static Options get open => Options(headers: {'requiresToken': false});

  ApiClient(
    @Named('BaseUrl') String baseUrl,
    AuthInterceptor authInterceptor,
  ) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            contentType: Headers.jsonContentType,
          ),
        ) {
    _dio.interceptors.addAll([
      DioLogInterceptor(printBody: kDebugMode),
      authInterceptor,
    ]);
  }

  // GET
  Future<T> get<T>({
    required String url,
    Map<String, dynamic>? query,
    Options? options,
  }) =>
      _request(() => _dio.get(url, queryParameters: query, options: options));

  // POST
  Future<T> post<T>({
    required String url,
    dynamic payload,
    Options? options,
  }) =>
      _request(() => _dio.post(url, data: payload, options: options));

  // PATCH (Added)
  Future<T> patch<T>({
    required String url,
    dynamic payload,
    Options? options,
  }) =>
      _request(() => _dio.patch(url, data: payload, options: options));

  // PUT
  Future<T> put<T>({
    required String url,
    dynamic payload,
    Options? options,
  }) =>
      _request(() => _dio.put(url, data: payload, options: options));

  // DELETE
  Future<T> delete<T>({
    required String url,
    Options? options,
  }) =>
      _request(() => _dio.delete(url, options: options));

  Future<T> _request<T>(Future<Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    final data = e.response?.data;
    final message = data is Map ? (data['message'] ?? data['detail']) : null;

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkException('Check your internet connection');
    }

    return switch (e.response?.statusCode) {
      400 => ValidationException(message ?? 'Invalid request'),
      401 => UnauthorizedException(message ?? 'Session expired'),
      404 => NotFoundException(message ?? 'Not found'),
      _ => ServerException(message ?? 'Something went wrong'),
    };
  }
}