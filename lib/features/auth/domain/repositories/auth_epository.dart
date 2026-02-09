// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';
import 'dart:io';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    File? profileImage,
  );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword);
  Future<Either<Failure, void>> verifyOtp(String email, String otp);
  Future<Either<Failure, void>> sendOtp(String email);
}
