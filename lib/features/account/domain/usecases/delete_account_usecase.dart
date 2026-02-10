// lib/features/account/domain/usecases/delete_account_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/common/helpers/base_usecase.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/account/domain/repositories/account_repository.dart';

@lazySingleton
class DeleteAccountUsecase implements UseCase<void, NoParams> {
  final AccountRepository _repository;

  DeleteAccountUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.deleteAccount();
  }
}
