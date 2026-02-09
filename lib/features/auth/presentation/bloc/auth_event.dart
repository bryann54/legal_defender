// lib/features/auth/presentation/bloc/auth_event.dart

import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class SignInWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final File? profileImage;

  const SignUpWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}

class SendOtpEvent extends AuthEvent {
  final String email;

  const SendOtpEvent({required this.email});

  @override
  List<Object> get props => [email];
}
