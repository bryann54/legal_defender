// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/core/errors/failures.dart';
import 'package:legal_defender/features/auth/domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetAuthStateUseCase _getAuthStateUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetAuthStateUseCase getAuthStateUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getAuthStateUseCase = getAuthStateUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(const AuthState()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signInUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFailureToMessage(failure),
      )),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signUpUseCase({
      'email': event.email,
      'password': event.password,
      'username': event.username,
      'phone_number': event.phoneNumber,
      'state': event.state,
      if (event.referralCode != null) 'referral_code': event.referralCode,
    });
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFailureToMessage(failure),
      )),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await emit.forEach(
      _getAuthStateUseCase(),
      onData: (user) => user != null
          ? state.copyWith(status: AuthStatus.authenticated, user: user)
          : state.copyWith(status: AuthStatus.unauthenticated, user: null),
      onError: (error, _) => state.copyWith(
          status: AuthStatus.error, errorMessage: error.toString()),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure))),
      (_) =>
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: null)),
    );
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result =
        await _resetPasswordUseCase(event.email, event.otp, event.newPassword);
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure))),
      (_) => emit(state.copyWith(status: AuthStatus.passwordReset)),
    );
  }

String _mapFailureToMessage(dynamic failure) {
    if (failure is ValidationFailure) return failure.error;
    if (failure is GeneralFailure) return failure.error;
    if (failure is UnauthorizedFailure) return "Invalid email or password";
    if (failure is NetworkFailure) return "Check your internet connection";
    return "An unexpected error occurred";
  }
}
