// lib/features/account/data/datasources/account_local_datasource.dart

import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/storage/storage_preference_manager.dart';
import '../models/user_profile_model.dart';

@lazySingleton
class AccountLocalDatasource {
  final SharedPreferencesManager _prefs;

  AccountLocalDatasource(this._prefs);

  // --- PROFILE MANAGEMENT (SharedPreferences for non-sensitive data) ---

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

  // --- SETTINGS (SharedPreferences) ---

  Future<void> cacheLanguage(String code) async =>
      await _prefs.putString(SharedPreferencesManager.language, code);

  String getLanguage() =>
      _prefs.getString(SharedPreferencesManager.language) ?? 'en';

  Future<void> clearAllData() async {
    // Clear only non-sensitive data
    // Tokens are managed by AuthLocalDataSource
    await _prefs.clearKey(SharedPreferencesManager.user);
  }
}
