// lib/core/di/register_modules.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModules {
  @preResolve
  Future<SharedPreferences> prefs() async =>
      await SharedPreferences.getInstance();

  @Named('BaseUrl')
  String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://fallback-url.com';

  // ADD THE @Named ANNOTATION HERE
  @Named('base_dio')
  @lazySingleton
  Dio dio(@Named('BaseUrl') String url) => Dio(
        BaseOptions(
          baseUrl: url,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
