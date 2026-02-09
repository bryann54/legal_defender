// lib/features/auth/presentation/widgets/auth_state_listener.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_state.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';

/// A wrapper widget that listens to auth state changes and handles
/// navigation and feedback (snackbars) in a centralized way.
///
/// This prevents duplicate BlocListeners across auth screens.
class AuthStateListener extends StatelessWidget {
  final Widget child;
  final String? successMessage;
  final bool isRegistration;

  const AuthStateListener({
    super.key,
    required this.child,
    this.successMessage,
    this.isRegistration = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _handleAuthState(context, state);
      },
      child: child,
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        _showSuccessSnackBar(context);
        context.router.replace(const MainRoute());
        break;
      case AuthStatus.error:
        _showErrorSnackBar(context, state.errorMessage);
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.initial:
      case AuthStatus.loading:
        break;
    }
  }

  void _showSuccessSnackBar(BuildContext context) {
    final message = successMessage ??
        (isRegistration
            ? 'Account created successfully!'
            : 'Welcome back! Successfully signed in');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String? errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage ?? AppLocalizations.getString(context, 'auth.genericError'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
