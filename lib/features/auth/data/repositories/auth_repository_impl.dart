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
      // Backend returns tokens inside the user model or response
      await _local.saveTokens(access: '...', refresh: '...');
      await _local.saveUser(userModel);
      return Right(userModel.toEntity());
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      Map<String, dynamic> params) async {
    try {
      final userModel = await _remote.register(params);
      await _local.saveUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _local.clearAuthData();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    final user = await _local.getUser();
    return Right(user?.toEntity());
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    // Logic for refreshing via remote and saving to local
    return const Right("new_token");
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      String email, String otp, String newPassword) async {
    // implementation...
    return const Right(null);
  }
}
