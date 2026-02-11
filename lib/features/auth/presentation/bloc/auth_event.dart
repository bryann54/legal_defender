// lib/features/auth/presentation/bloc/auth_event.dart

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phoneNumber;
  final String? state;
  final String? profileType;
  final String? language;
  final String? referralCode;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    this.state,
    this.profileType,
    this.language,
    this.referralCode,
  });
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;
  const ResetPasswordEvent(
      {required this.email, required this.otp, required this.newPassword});
}
