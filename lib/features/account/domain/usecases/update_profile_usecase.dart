import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/common/helpers/base_usecase.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/account/domain/entities/user_profile.dart';
import 'package:legal_defender/features/account/domain/repositories/account_repository.dart';

@lazySingleton
class UpdateProfileUsecase
    implements UseCase<UserProfile, Map<String, dynamic>> {
  final AccountRepository _repository;
  UpdateProfileUsecase(this._repository);

  @override
  Future<Either<Failure, UserProfile>> call(Map<String, dynamic> params) async {
    return await _repository.updateProfile(params);
  }
}
