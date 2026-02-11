// lib/features/account/data/repositories/account_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/common/helpers/base_usecase.dart';
import 'package:legal_defender/core/errors/exceptions.dart';
import 'package:legal_defender/core/errors/failures.dart';
import '../datasources/account_local_datasource.dart';
import '../datasources/account_remote_datasource.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/account_repository.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remote;
  final AccountLocalDatasource _local;

  AccountRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      // 1. Try to fetch fresh data
      final remoteProfile = await _remote.getProfile();
      // 2. Update local cache immediately
      await _local.cacheUserProfile(remoteProfile);
      return Right(remoteProfile);
    } on NetworkException {
      // 3. Fallback to cache if network is down
      final localProfile = _local.getCachedProfile();
      if (localProfile != null) return Right(localProfile);
      return Left(NetworkFailure());
    } on Exception catch (e) {
      // 4. Handle other API/Server errors
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
      Map<String, dynamic> data) async {
    try {
      final profile = await _remote.updateProfile(data);
      // Sync cache with updated data
      await _local.cacheUserProfile(profile);
      return Right(profile);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, NoParams>> changeLanguage(String code) async {
    try {
      await _local.cacheLanguage(code);
      return Right(NoParams());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _remote.deleteAccount();
      // Use the blended clearAllData to wipe tokens and profile
      await _local.clearAllData();
      return const Right(null);
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Exception e) {
    if (e is UnauthorizedException) return const UnauthorizedFailure();
    if (e is ValidationException) return ValidationFailure(error: e.message);
    if (e is NotFoundException) return NotFoundFailure(error: e.message);
    if (e is NetworkException) return const NetworkFailure();
    if (e is ServerException) return const ServerFailure();

    return GeneralFailure(error: e.toString());
  }
}
