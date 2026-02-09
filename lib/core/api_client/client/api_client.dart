// lib/core/api_client/client/api_client.dart

import 'package:legal_defender/core/api_client/client/loggin_interceptor.dart';
import 'package:legal_defender/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiClient {
  final Dio _dio;

  // Constructor is annotated with @Named so injectable can find it
  ApiClient(
    @Named('BaseUrl') String baseUrl,
  ) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            contentType: Headers.jsonContentType,
          ),
        ) {
    // Add interceptors here once at initialization
    _dio.interceptors.add(DioLogInterceptors(printBody: kDebugMode));
    // AuthInterceptor will be added later when we have a token
    // _dio.interceptors.add(AuthInterceptor(authToken));
  }

  // A generic internal method to make a request and handle errors
  Future<T> _request<T>(Future<Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      return response.data as T;
    } on DioException catch (e) {
      // Pass the DioException to a single, centralized error handler
      _handleDioError(e);
      // Re-throw to propagate the custom exception to the repository layer
      rethrow;
    }
  }

  // GET request method for fetching data
  Future<T> get<T>({
    required String url,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _request<T>(
        () => _dio.get(url, queryParameters: query, options: options));
  }

  // POST request method for creating data
  Future<T> post<T>({
    required String url,
    dynamic payload,
    Options? options,
  }) async {
    return _request<T>(() => _dio.post(url, data: payload, options: options));
  }

  // PUT request method for updating data
  Future<T> put<T>({
    required String url,
    required dynamic payload,
    Options? options,
  }) async {
    return _request<T>(() => _dio.put(url, data: payload, options: options));
  }

  // PATCH request method for partial updates
  Future<T> patch<T>({
    required String url,
    required dynamic payload,
    Options? options,
  }) async {
    return _request<T>(() => _dio.patch(url, data: payload, options: options));
  }

  // DELETE request method for deleting data
  Future<void> delete({
    required String url,
    Options? options,
  }) async {
    // We expect a successful DELETE to return void, but errors should still be handled.
    try {
      await _dio.delete(url, options: options);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Centralized error handling logic
  void _handleDioError(DioException e) {
    if (e.response != null) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }
}
