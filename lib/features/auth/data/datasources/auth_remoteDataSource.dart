// lib/features/auth/data/datasources/auth_remoteDataSource.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/api_client/client/api_client.dart';
import 'package:legal_defender/core/errors/exceptions.dart';
import 'package:legal_defender/features/auth/data/models/user_model.dart';
import 'package:legal_defender/core/api_client/endpoints/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password,
      String firstName, String lastName, File? profileImage);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> verifyOtp(String email, String otp);
  Future<void> sendOtp(String email);
  Future<bool> hasValidToken();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  @override
  Stream<UserModel?> get authStateChanges async* {
    final token = await _secureStorage.read(key: 'accessToken');
    if (token != null && token.isNotEmpty) {
      // Token exists, try to get user data from secure storage
      final userId = await _secureStorage.read(key: 'userId');
      final email = await _secureStorage.read(key: 'userEmail');
      final firstName = await _secureStorage.read(key: 'userFirstName');
      final lastName = await _secureStorage.read(key: 'userLastName');

      if (userId != null && email != null) {
        yield UserModel(
          id: userId,
          email: email,
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          profileImageUrl: null,
        );
      } else {
        // Token exists but no user data, still consider authenticated
        // The user data will be populated on next login
        yield UserModel(
          id: 'temp',
          email: email ?? '',
          firstName: '',
          lastName: '',
          profileImageUrl: null,
        );
      }
    } else {
      yield null;
    }
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await _secureStorage.read(key: 'accessToken');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        url: ApiEndpoints.authLogin,
        payload: {
          'username': email,
          'password': password,
        },
      );

      // Extract token and user data from response
      final token = response['token'] as String?;
      final userId = response['user_id']?.toString();
      final userEmail = response['email'] as String?;
      final fullname = response['fullname'] as String?;

      if (token != null && token.isNotEmpty) {
        // Store token and user data
        await _secureStorage.write(key: 'accessToken', value: token);

        if (userId != null) {
          await _secureStorage.write(key: 'userId', value: userId);
        }
        if (userEmail != null) {
          await _secureStorage.write(key: 'userEmail', value: userEmail);
        }
        if (fullname != null) {
          await _secureStorage.write(key: 'userFullname', value: fullname);
        }
      }

      // Create user model from response
      return UserModel.fromJson(response);
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(String email, String password,
      String firstName, String lastName, File? profileImage) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        if (firstName.isNotEmpty) 'first_name': firstName,
        if (lastName.isNotEmpty) 'last_name': lastName,
        if (profileImage != null)
          'profile_image': await MultipartFile.fromFile(profileImage.path),
      });

      final response = await _apiClient.post<Map<String, dynamic>>(
        url: ApiEndpoints.authRegister,
        payload: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // Extract token and user data from response
      final token = response['token'] as String?;
      final userId = response['user_id']?.toString();
      final userEmail = response['email'] as String?;

      if (token != null && token.isNotEmpty) {
        await _secureStorage.write(key: 'accessToken', value: token);

        if (userId != null) {
          await _secureStorage.write(key: 'userId', value: userId);
        }
        if (userEmail != null) {
          await _secureStorage.write(key: 'userEmail', value: userEmail);
        }
      }

      return UserModel.fromJson(response);
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Clear all stored data
      await _secureStorage.delete(key: 'accessToken');
      await _secureStorage.delete(key: 'userId');
      await _secureStorage.delete(key: 'userEmail');
      await _secureStorage.delete(key: 'userFullname');
    } on Exception {
      throw ServerException();
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _apiClient.post<void>(
        url: ApiEndpoints.authOtp,
        payload: {'email': email},
      );
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await _apiClient.post<void>(
        url: ApiEndpoints.authChangePassword,
        payload: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      await _apiClient.post<void>(
        url: ApiEndpoints.authOtpVerify,
        payload: {'email': email, 'otp': otp},
      );
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      await _apiClient.post<void>(
        url: ApiEndpoints.authOtp,
        payload: {'email': email},
      );
    } on ServerException {
      throw ServerException();
    }
  }
}
