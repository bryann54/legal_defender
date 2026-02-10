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

  Dio get dio => _dio;

  Future<T> _request<T>(Future<Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> get<T>(
          {required String url,
          Map<String, dynamic>? query,
          Options? options}) =>
      _request<T>(
          () => _dio.get(url, queryParameters: query, options: options));

  Future<T> post<T>({required String url, dynamic payload, Options? options}) =>
      _request<T>(() => _dio.post(url, data: payload, options: options));

  Future<T> put<T>({required String url, dynamic payload, Options? options}) =>
      _request<T>(() => _dio.put(url, data: payload, options: options));

  Future<T> patch<T>(
          {required String url, dynamic payload, Options? options}) =>
      _request<T>(() => _dio.patch(url, data: payload, options: options));

  Future<void> delete({required String url, Options? options}) async {
    try {
      await _dio.delete(url, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      final message = data is Map ? (data['message'] ?? data['detail']) : null;

      return switch (e.response?.statusCode) {
        400 => ValidationException(message ?? 'Validation error'),
        401 => UnauthorizedException(message ?? 'Unauthorized'),
        404 => NotFoundException(message ?? 'Resource not found'),
        500 || 502 || 503 => ServerException(message ?? 'Server error'),
        _ => ServerException('Unexpected error: ${e.response?.statusCode}'),
      };
    }

    if (e.type == DioExceptionType.connectionError) {
      return NetworkException('No internet');
    }
    return ServerException(e.message);
  }
}
