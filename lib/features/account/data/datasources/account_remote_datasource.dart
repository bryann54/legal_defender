// lib/features/account/data/datasources/account_remote_datasource.dart

import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/api_client/client/api_client.dart';
import 'package:legal_defender/core/api_client/endpoints/api_endpoints.dart';
import '../models/user_profile_model.dart';

abstract class AccountRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data);
  Future<void> deleteAccount();
}

@LazySingleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiClient _apiClient;

  AccountRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      url: ApiEndpoints.userProfile,
      options: ApiClient.protected,
    );
    return UserProfileModel.fromJson(response);
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      url: ApiEndpoints.userUpdate,
      payload: data,
      options: ApiClient.protected,
    );
    return UserProfileModel.fromJson(response);
  }

  @override
  Future<void> deleteAccount() async {
    await _apiClient.delete(
      url: ApiEndpoints.userDelete,
      options: ApiClient.protected,
    );
  }
}
