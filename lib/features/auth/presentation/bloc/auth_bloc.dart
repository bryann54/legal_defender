// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:legal_defender/features/auth/domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPassword;
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPassword;
  final SignOutUseCase _signOutUseCase;
  final GetAuthStateChangesUseCase _getAuthStateChanges;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;

  AuthBloc({
    required SignInWithEmailAndPasswordUseCase signInWithEmailAndPassword,
    required SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPassword,
    required SignOutUseCase signOutUseCase,
    required GetAuthStateChangesUseCase getAuthStateChanges,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required SendOtpUseCase sendOtpUseCase,
  })  : _signInWithEmailAndPassword = signInWithEmailAndPassword,
        _signUpWithEmailAndPassword = signUpWithEmailAndPassword,
        _signOutUseCase = signOutUseCase,
        _getAuthStateChanges = getAuthStateChanges,
        _resetPasswordUseCase = resetPasswordUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _sendOtpUseCase = sendOtpUseCase,
        super(const AuthState()) {
    on<SignInWithEmailAndPasswordEvent>(_onSignInWithEmailAndPassword);
    on<SignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPassword);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ResetPasswordEvent>(_onResetPassword);
    on<ChangePasswordEvent>(_onChangePassword);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SendOtpEvent>(_onSendOtp);
  }

  Future<void> _onSignInWithEmailAndPassword(
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result =
        await _signInWithEmailAndPassword(event.email, event.password);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
    );
  }

  Future<void> _onSignUpWithEmailAndPassword(
    SignUpWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signUpWithEmailAndPassword(
      event.email,
      event.password,
      event.firstName,
      event.lastName,
      event.profileImage,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (_) =>
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: null)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    // Listen to auth state changes stream
    await emit.forEach(
      _getAuthStateChanges(),
      onData: (user) {
        if (user != null) {
          return state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
        } else {
          return state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
          );
        }
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _resetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
      )),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _changePasswordUseCase(
      event.currentPassword,
      event.newPassword,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.authenticated,
      )),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _verifyOtpUseCase(event.email, event.otp);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
      )),
    );
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _sendOtpUseCase(event.email);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.toString(),
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
      )),
    );
  }
}
