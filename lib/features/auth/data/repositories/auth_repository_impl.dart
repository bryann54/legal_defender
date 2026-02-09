// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/errors/exceptions.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/auth/data/datasources/auth_remoteDataSource.dart';
import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';
import 'package:legal_defender/features/auth/domain/repositories/auth_epository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges
      .map((userModel) => userModel?.toEntity());

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel =
          await _remoteDataSource.signInWithEmailAndPassword(email, password);
      return Right(userModel.toEntity());
    } on ServerException {
      return const Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    File? profileImage,
  ) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
        firstName,
        lastName,
        profileImage,
      );
      return Right(userModel.toEntity());
    } on ServerException {
      return const Left(ServerFailure());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.authStateChanges.first;
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await _remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otp) async {
    try {
      await _remoteDataSource.verifyOtp(email, otp);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String email) async {
    try {
      await _remoteDataSource.sendOtp(email);
      return const Right(null);
    } catch (e) {
      return Left(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    return Left(GeneralFailure(error: "Google Sign-In not implemented"));
  }
}
