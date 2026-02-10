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

  Future<T> get<T>(
          {required String url,
          Map<String, dynamic>? query,
          Options? options}) =>
      _request(() => _dio.get(url, queryParameters: query, options: options));

  Future<T> post<T>({required String url, dynamic payload, Options? options}) =>
      _request(() => _dio.post(url, data: payload, options: options));

  Future<T> patch<T>(
          {required String url, dynamic payload, Options? options}) =>
      _request(() => _dio.patch(url, data: payload, options: options));

  Future<T> delete<T>({required String url, Options? options}) =>
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
    String? message;

    // Production-grade unwrapping of backend error maps
    if (data is Map) {
      final errorContent =
          data['non_field_errors'] ?? data['detail'] ?? data['message'] ?? data;
      if (errorContent is List && errorContent.isNotEmpty) {
        message = errorContent.first.toString();
      } else if (errorContent is Map) {
        message = errorContent.values.first.toString();
      } else {
        message = errorContent.toString();
      }
    }

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkException('Check your internet connection');
    }

    return switch (e.response?.statusCode) {
      400 => ValidationException(message ?? 'Invalid request'),
      401 => UnauthorizedException(message ?? 'Session expired'),
      404 => NotFoundException(message ?? 'Resource not found'),
      _ => ServerException(message ?? 'Something went wrong'),
    };
  }
}
