// lib/features/auth/domain/usecases/auth_usecases.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';
import 'package:legal_defender/features/auth/domain/repositories/auth_epository.dart';

@lazySingleton
class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
      String email, String password) async {
    return await repository.signIn(email, password);
  }
}

@lazySingleton
class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(Map<String, dynamic> params) async {
    return await repository.signUp(params);
  }
}

@lazySingleton
class SignOutUseCase {
  final AuthRepository repository;
  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}

@lazySingleton
class GetAuthStateUseCase {
  final AuthRepository repository;
  GetAuthStateUseCase(this.repository);

  Stream<UserEntity?> call() => repository.authStateChanges;
}

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String email,
    String otp,
    String newPassword,
  ) async {
    return await repository.resetPassword(email, otp, newPassword);
  }
}

@lazySingleton
class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
