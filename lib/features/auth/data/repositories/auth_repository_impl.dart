// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/errors/exceptions.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:legal_defender/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';
import 'package:legal_defender/features/auth/domain/repositories/auth_epository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Stream<UserEntity?> get authStateChanges =>
      _local.userStream.map((model) => model?.toEntity());

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      final userModel = await _remote.login(email, password);

      // 1. Save Tokens Immediately
      final access = userModel.access;
      final refresh = userModel.refresh;

      if (access != null && refresh != null) {
        await _local.saveTokens(access: access, refresh: refresh);
      } else {
        throw ServerException('Authentication failed: No tokens received');
      }

      // 2. Save User Data (Even if partial)
      await _local.saveUser(userModel);

      return Right(userModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(error: e.message));
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      return Left(
          GeneralFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      Map<String, dynamic> params) async {
    try {
      // 1. Call API to register
      final userModel = await _remote.register(params);

      // 2. Extract and save tokens from API response
   if (userModel.access != null && userModel.refresh != null) {
        await _local.saveTokens(
          access: userModel.access!,
          refresh: userModel.refresh!,
        );
   await _local.saveUser(userModel);
        return Right(userModel.toEntity());
      }
      // 3. Save user data
      await _local.saveUser(userModel);

      return Right(userModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(error: e.message));
    } on NetworkException catch (e) {
      return Left(GeneralFailure(error: e.message ?? 'Network error'));
    } on ServerException catch (e) {
      return Left(GeneralFailure(error: e.message ?? 'Server error'));
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Clear all auth data from secure storage
      await _local.clearAuthData();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await _local.getUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final refreshToken = await _local.getRefreshToken();
      if (refreshToken == null) {
        return const Left(UnauthorizedFailure());
      }

      // This is handled by AuthInterceptor automatically
      // But we can implement it here if needed for manual refresh
      return Right(refreshToken);
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      String email, String otp, String newPassword) async {
    // TODO: Implement when backend endpoint is ready
    return const Right(null);
  }
}
