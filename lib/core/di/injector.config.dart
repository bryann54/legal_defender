// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/account/data/datasources/account_local_datasource.dart'
    as _i29;
import '../../features/account/data/repositories/account_repository_impl.dart'
    as _i857;
import '../../features/account/domain/repositories/account_repository.dart'
    as _i1067;
import '../../features/account/domain/usecases/change_language_usecase.dart'
    as _i993;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/auth/data/datasources/auth_remoteDataSource.dart'
    as _i167;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_epository.dart' as _i626;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../api_client/client/api_client.dart' as _i671;
import '../api_client/client/dio_client.dart' as _i758;
import '../api_client/client_provider.dart' as _i546;
import '../storage/storage_preference_manager.dart' as _i934;
import 'module_injector.dart' as _i759;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModules = _$RegisterModules();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModules.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModules.secureStorage);
    gh.factory<String>(
      () => registerModules.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.factory<String>(
      () => registerModules.apiKey,
      instanceName: 'ApiKey',
    );
    gh.lazySingleton<_i934.SharedPreferencesManager>(
        () => _i934.SharedPreferencesManager(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i29.AccountLocalDatasource>(() =>
        _i29.AccountLocalDatasource(gh<_i934.SharedPreferencesManager>()));
    gh.lazySingleton<_i671.ApiClient>(
        () => _i671.ApiClient(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i361.Dio>(
        () => registerModules.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i1067.AccountRepository>(
        () => _i857.AccountRepositoryImpl(gh<_i29.AccountLocalDatasource>()));
    gh.lazySingleton<_i167.AuthRemoteDataSource>(
        () => _i167.AuthRemoteDataSourceImpl(
              gh<_i671.ApiClient>(),
              gh<_i558.FlutterSecureStorage>(),
            ));
    gh.lazySingleton<_i758.DioClient>(() => _i758.DioClient(
          gh<_i361.Dio>(),
          gh<String>(instanceName: 'ApiKey'),
        ));
    gh.lazySingleton<_i626.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i167.AuthRemoteDataSource>()));
    gh.lazySingleton<_i546.ClientProvider>(
        () => _i546.ClientProvider(gh<_i758.DioClient>()));
    gh.lazySingleton<_i993.ChangeLanguageUsecase>(
        () => _i993.ChangeLanguageUsecase(gh<_i1067.AccountRepository>()));
    gh.lazySingleton<_i46.SignInWithEmailAndPasswordUseCase>(() =>
        _i46.SignInWithEmailAndPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignUpWithEmailAndPasswordUseCase>(() =>
        _i46.SignUpWithEmailAndPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignOutUseCase>(
        () => _i46.SignOutUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.GetAuthStateChangesUseCase>(
        () => _i46.GetAuthStateChangesUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.ResetPasswordUseCase>(
        () => _i46.ResetPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.ChangePasswordUseCase>(
        () => _i46.ChangePasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.VerifyOtpUseCase>(
        () => _i46.VerifyOtpUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SendOtpUseCase>(
        () => _i46.SendOtpUseCase(gh<_i626.AuthRepository>()));
    gh.factory<_i708.AccountBloc>(
        () => _i708.AccountBloc(gh<_i993.ChangeLanguageUsecase>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          signInWithEmailAndPassword:
              gh<_i46.SignInWithEmailAndPasswordUseCase>(),
          signUpWithEmailAndPassword:
              gh<_i46.SignUpWithEmailAndPasswordUseCase>(),
          signOutUseCase: gh<_i46.SignOutUseCase>(),
          getAuthStateChanges: gh<_i46.GetAuthStateChangesUseCase>(),
          resetPasswordUseCase: gh<_i46.ResetPasswordUseCase>(),
          changePasswordUseCase: gh<_i46.ChangePasswordUseCase>(),
          verifyOtpUseCase: gh<_i46.VerifyOtpUseCase>(),
          sendOtpUseCase: gh<_i46.SendOtpUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModules extends _i759.RegisterModules {}
