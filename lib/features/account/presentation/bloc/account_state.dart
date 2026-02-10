// lib/features/account/presentation/bloc/account_state.dart

part of 'account_bloc.dart';

enum AccountStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  deleting,
  deleted,
  error,
}

class AccountState extends Equatable {
  final AccountStatus status;
  final UserProfile? profile;
  final String? errorMessage;
  final String? successMessage;
  final String currentLang;

  const AccountState({
    this.status = AccountStatus.initial,
    this.profile,
    this.errorMessage,
    this.successMessage,
    this.currentLang = 'en',
  });

  AccountState copyWith({
    AccountStatus? status,
    UserProfile? profile,
    String? errorMessage,
    String? successMessage,
    String? currentLang,
  }) {
    return AccountState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      successMessage: successMessage,
      currentLang: currentLang ?? this.currentLang,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        errorMessage,
        successMessage,
        currentLang,
      ];
}
