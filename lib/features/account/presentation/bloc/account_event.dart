// lib/features/account/presentation/bloc/account_event.dart

part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends AccountEvent {
  const FetchProfileEvent();
}

class UpdateProfileEvent extends AccountEvent {
  final Map<String, dynamic> updatedData;

  const UpdateProfileEvent(this.updatedData);

  @override
  List<Object?> get props => [updatedData];
}

class ChangeLanguageEvent extends AccountEvent {
  final String langCode;

  const ChangeLanguageEvent({required this.langCode});

  @override
  List<Object?> get props => [langCode];
}

class DeleteAccountEvent extends AccountEvent {
  const DeleteAccountEvent();
}

class ClearErrorEvent extends AccountEvent {
  const ClearErrorEvent();
}
