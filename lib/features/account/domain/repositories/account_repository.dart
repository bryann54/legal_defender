import 'package:legal_defender/common/helpers/base_usecase.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AccountRepository {
  Future<Either<Failure, NoParams>> changeLanguage(String languageCode);
}
