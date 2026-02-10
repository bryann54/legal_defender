// lib/features/auth/data/datasources/auth_local_datasource.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  // The stream the repository will listen to
  Stream<UserModel?> get userStream;

  Future<void> saveTokens({required String access, required String refresh});
  Future<void> saveUser(UserModel user);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getUser();
  Future<void> clearAuthData();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secure;
  static const _userKey = 'cached_user';

  // Controller to broadcast user changes
  final _userStreamController = StreamController<UserModel?>.broadcast();

  AuthLocalDataSourceImpl(this._secure) {
    // Initialize the stream with the currently cached user on startup
    _init();
  }

  Future<void> _init() async {
    final user = await getUser();
    _userStreamController.add(user);
  }

  @override
  Stream<UserModel?> get userStream => _userStreamController.stream;

  @override
  Future<void> saveTokens(
      {required String access, required String refresh}) async {
    await _secure.write(key: 'accessToken', value: access);
    await _secure.write(key: 'refreshToken', value: refresh);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _secure.write(key: _userKey, value: jsonEncode(user.toJson()));
    // Push the new user model into the stream
    _userStreamController.add(user);
  }

  @override
  Future<UserModel?> getUser() async {
    final data = await _secure.read(key: _userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  @override
  Future<void> clearAuthData() async {
    await _secure.deleteAll();
    // Notify listeners that the user is now null (signed out)
    _userStreamController.add(null);
  }

  @override
  Future<String?> getAccessToken() => _secure.read(key: 'accessToken');

  @override
  Future<String?> getRefreshToken() => _secure.read(key: 'refreshToken');

  // Clean up the controller when the app disposes of this singleton
  @disposeMethod
  void dispose() {
    _userStreamController.close();
  }
}
