// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/account/data/datasources/account_local_datasource.dart'
    as _i29;
import '../../features/account/data/datasources/account_remote_datasource.dart'
    as _i302;
import '../../features/account/data/repositories/account_repository_impl.dart'
    as _i857;
import '../../features/account/domain/repositories/account_repository.dart'
    as _i1067;
import '../../features/account/domain/usecases/change_language_usecase.dart'
    as _i993;
import '../../features/account/domain/usecases/delete_account_usecase.dart'
    as _i949;
import '../../features/account/domain/usecases/get_profile_usecase.dart'
    as _i682;
import '../../features/account/domain/usecases/update_profile_usecase.dart'
    as _i23;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_epository.dart' as _i626;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../api_client/client/api_client.dart' as _i671;
import '../api_client/interceptors/auth_interceptor.dart' as _i878;
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
      () => registerModules.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModules.secureStorage);
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<String>(
      () => registerModules.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.lazySingleton<_i934.SharedPreferencesManager>(
        () => _i934.SharedPreferencesManager(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i29.AccountLocalDatasource>(() =>
        _i29.AccountLocalDatasource(gh<_i934.SharedPreferencesManager>()));
    gh.lazySingleton<_i878.AuthInterceptor>(() => _i878.AuthInterceptor(
          gh<_i992.AuthLocalDataSource>(),
          gh<String>(instanceName: 'BaseUrl'),
        ));
    gh.lazySingleton<_i671.ApiClient>(() => _i671.ApiClient(
          gh<String>(instanceName: 'BaseUrl'),
          gh<_i878.AuthInterceptor>(),
        ));
    gh.lazySingleton<_i302.AccountRemoteDataSource>(
        () => _i302.AccountRemoteDataSourceImpl(gh<_i671.ApiClient>()));
    gh.lazySingleton<_i1067.AccountRepository>(
        () => _i857.AccountRepositoryImpl(
              gh<_i302.AccountRemoteDataSource>(),
              gh<_i29.AccountLocalDatasource>(),
            ));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(gh<_i671.ApiClient>()));
    gh.lazySingleton<_i626.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i161.AuthRemoteDataSource>(),
          gh<_i992.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i23.UpdateProfileUsecase>(
        () => _i23.UpdateProfileUsecase(gh<_i1067.AccountRepository>()));
    gh.lazySingleton<_i993.ChangeLanguageUsecase>(
        () => _i993.ChangeLanguageUsecase(gh<_i1067.AccountRepository>()));
    gh.lazySingleton<_i682.GetProfileUsecase>(
        () => _i682.GetProfileUsecase(gh<_i1067.AccountRepository>()));
    gh.lazySingleton<_i949.DeleteAccountUsecase>(
        () => _i949.DeleteAccountUsecase(gh<_i1067.AccountRepository>()));
    gh.factory<_i708.AccountBloc>(() => _i708.AccountBloc(
          gh<_i682.GetProfileUsecase>(),
          gh<_i23.UpdateProfileUsecase>(),
          gh<_i993.ChangeLanguageUsecase>(),
          gh<_i949.DeleteAccountUsecase>(),
        ));
    gh.lazySingleton<_i46.SignInUseCase>(
        () => _i46.SignInUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignUpUseCase>(
        () => _i46.SignUpUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignOutUseCase>(
        () => _i46.SignOutUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.GetAuthStateUseCase>(
        () => _i46.GetAuthStateUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.ResetPasswordUseCase>(
        () => _i46.ResetPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.GetCurrentUserUseCase>(
        () => _i46.GetCurrentUserUseCase(gh<_i626.AuthRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          signInUseCase: gh<_i46.SignInUseCase>(),
          signUpUseCase: gh<_i46.SignUpUseCase>(),
          signOutUseCase: gh<_i46.SignOutUseCase>(),
          getAuthStateUseCase: gh<_i46.GetAuthStateUseCase>(),
          resetPasswordUseCase: gh<_i46.ResetPasswordUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModules extends _i759.RegisterModules {}
