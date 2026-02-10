// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<Either<Failure, UserEntity>> signIn(String email, String password);

  Future<Either<Failure, UserEntity>> signUp(Map<String, dynamic> params);

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, String>> refreshToken();
}
