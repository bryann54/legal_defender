// lib/features/account/domain/repositories/account_repository.dart

import 'package:legal_defender/common/helpers/base_usecase.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:legal_defender/features/account/domain/entities/user_profile.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, NoParams>> changeLanguage(String languageCode);
  Future<Either<Failure, void>> deleteAccount();
}
