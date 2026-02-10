// lib/core/api_client/interceptors/auth_interceptor.dart

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/api_client/endpoints/api_endpoints.dart';
import 'package:legal_defender/features/auth/data/datasources/auth_local_datasource.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;
  final Dio _dio;

  Completer<String?>? _refreshTokenCompleter;

  AuthInterceptor(
    this._localDataSource,
    @Named('base_dio') this._dio,
  );

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isAuthEndpoint(options.path)) return handler.next(options);

    final accessToken = await _localDataSource.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path.contains(ApiEndpoints.authRefresh) ||
          _isAuthEndpoint(err.requestOptions.path)) {
        await _localDataSource.clearAuthData();
        return handler.next(err);
      }

      final newToken = await _handleTokenRefresh();

      if (newToken != null) {
        return handler.resolve(await _retry(err.requestOptions, newToken));
      } else {
        await _localDataSource.clearAuthData();
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  Future<String?> _handleTokenRefresh() async {
    if (_refreshTokenCompleter != null &&
        !_refreshTokenCompleter!.isCompleted) {
      return _refreshTokenCompleter!.future;
    }

    _refreshTokenCompleter = Completer<String?>();

    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) throw Exception();

      final response = await _dio.post(
        ApiEndpoints.authRefresh,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final access = response.data['access'] as String;
        final refresh = response.data['refresh'] as String? ?? refreshToken;

        await _localDataSource.saveTokens(access: access, refresh: refresh);
        _refreshTokenCompleter!.complete(access);
        return access;
      }
      throw Exception();
    } catch (e) {
      _refreshTokenCompleter!.complete(null);
      return null;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions, String token) async {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      contentType: requestOptions.contentType,
      responseType: requestOptions.responseType,
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/token/') ||
        (path.contains('/users/') && !path.contains('/users/me')) ||
        path.contains('/otp/') ||
        path.contains('/password/');
  }
}
