// lib/features/auth/data/datasources/auth_local_datasource.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// The stream the repository will listen to
  Stream<UserModel?> get userStream;

  Future<void> saveTokens({required String access, required String refresh});
  Future<void> saveUser(UserModel user);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getUser();
  Future<void> clearAuthData();

  /// Dispose method for cleanup
  void dispose();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secure;

  // Secure storage keys - only used by this class
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _userKey = 'cachedUser';

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
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _secure.write(key: _accessTokenKey, value: access),
      _secure.write(key: _refreshTokenKey, value: refresh),
    ]);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _secure.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
    // Push the new user model into the stream
    _userStreamController.add(user);
  }

  @override
  Future<UserModel?> getUser() async {
    final data = await _secure.read(key: _userKey);
    if (data == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(data));
    } catch (e) {
      // If parsing fails, clear corrupted data
      await _secure.delete(key: _userKey);
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await Future.wait([
      _secure.delete(key: _accessTokenKey),
      _secure.delete(key: _refreshTokenKey),
      _secure.delete(key: _userKey),
    ]);
    // Notify listeners that the user is now null (signed out)
    _userStreamController.add(null);
  }

  @override
  Future<String?> getAccessToken() => _secure.read(key: _accessTokenKey);

  @override
  Future<String?> getRefreshToken() => _secure.read(key: _refreshTokenKey);

  @override
  @disposeMethod
  void dispose() {
    _userStreamController.close();
  }
}
