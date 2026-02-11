// lib/features/account/presentation/bloc/account_bloc.dart

import 'dart:async';

import 'package:legal_defender/common/helpers/base_usecase.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/account/domain/entities/user_profile.dart';
import 'package:legal_defender/features/account/domain/usecases/change_language_usecase.dart';
import 'package:legal_defender/features/account/domain/usecases/delete_account_usecase.dart';
import 'package:legal_defender/features/account/domain/usecases/get_profile_usecase.dart';
import 'package:legal_defender/features/account/domain/usecases/update_profile_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetProfileUsecase _getProfile;
  final UpdateProfileUsecase _updateProfile;
  final ChangeLanguageUsecase _changeLanguage;
  final DeleteAccountUsecase _deleteAccount;

  AccountBloc(
    this._getProfile,
    this._updateProfile,
    this._changeLanguage,
    this._deleteAccount,
  ) : super(const AccountState()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<ClearErrorEvent>((event, emit) {
      emit(state.copyWith(status: AccountStatus.initial, errorMessage: null));
    });
  }

  Future<void> _onFetchProfile(
      FetchProfileEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(status: AccountStatus.loading));
    final result = await _getProfile(NoParams());
    result.fold(
      (f) => emit(state.copyWith(
          status: AccountStatus.error, errorMessage: _mapFailure(f))),
      (p) => emit(state.copyWith(status: AccountStatus.loaded, profile: p)),
    );
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(status: AccountStatus.updating));
    final result = await _updateProfile(event.updatedData);
    result.fold(
      (f) => emit(state.copyWith(
          status: AccountStatus.error, errorMessage: _mapFailure(f))),
      (p) => emit(state.copyWith(
          status: AccountStatus.updated,
          profile: p,
          successMessage: 'Profile Updated')),
    );
  }

  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event, Emitter<AccountState> emit) async {
    final result = await _changeLanguage(event.langCode);
    result.fold(
      (f) => emit(state.copyWith(
          status: AccountStatus.error, errorMessage: _mapFailure(f))),
      (_) => emit(state.copyWith(currentLang: event.langCode)),
    );
  }

  Future<void> _onDeleteAccount(
      DeleteAccountEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(status: AccountStatus.deleting));
    final result = await _deleteAccount(NoParams());
    result.fold(
      (f) => emit(state.copyWith(
          status: AccountStatus.error, errorMessage: _mapFailure(f))),
      (_) => emit(state.copyWith(status: AccountStatus.deleted)),
    );
  }

  String _mapFailure(Failure f) {
    if (f is NetworkFailure) return "No internet connection";
    if (f is UnauthorizedFailure) return "Session expired";
    if (f is ValidationFailure) return f.error;
    return "Something went wrong";
  }
}
