// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/api_client/client/api_client.dart';
import 'package:legal_defender/core/api_client/endpoints/api_endpoints.dart';
import 'package:legal_defender/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(Map<String, dynamic> userData);
  Future<void> requestOtp(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _client.post<Map<String, dynamic>>(
      url: ApiEndpoints.authLogin,
      payload: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> register(Map<String, dynamic> userData) async {
    final response = await _client.post<Map<String, dynamic>>(
      url: ApiEndpoints.authRegister,
      payload: userData,
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> requestOtp(String email) async {
    await _client.post(url: ApiEndpoints.authOtp, payload: {'email': email});
  }
}
