// lib/features/account/data/datasources/account_local_datasource.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/storage/storage_preference_manager.dart';
import '../models/user_profile_model.dart';

@lazySingleton
class AccountLocalDatasource {
  final SharedPreferencesManager _prefs;
  final FlutterSecureStorage _secureStorage;
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  AccountLocalDatasource(
    this._prefs,
    this._secureStorage,
  );
  // --- TOKEN MANAGEMENT (Secure) ---
  Future<void> saveTokens(
      {required String access, required String refresh}) async {
    await _secureStorage.write(key: _accessTokenKey, value: access);
    await _secureStorage.write(key: _refreshTokenKey, value: refresh);
  }

  Future<String?> getAccessToken() async =>
      await _secureStorage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() async =>
      await _secureStorage.read(key: _refreshTokenKey);

  // --- PROFILE MANAGEMENT (Preferences) ---

  Future<void> cacheUserProfile(UserProfileModel user) async {
    await _prefs.putString(
      SharedPreferencesManager.user,
      jsonEncode(user.toJson()),
    );
  }

  UserProfileModel? getCachedProfile() {
    final jsonStr = _prefs.getString(SharedPreferencesManager.user);
    if (jsonStr == null) return null;
    try {
      return UserProfileModel.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  // --- SETTINGS (Preferences) ---

  Future<void> cacheLanguage(String code) async =>
      await _prefs.putString(SharedPreferencesManager.language, code);

  String getLanguage() =>
      _prefs.getString(SharedPreferencesManager.language) ?? 'en';

  Future<void> clearAllData() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _prefs.clearKey(SharedPreferencesManager.user);
  }
}
