// lib/features/auth/presentation/pages/login_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/utils/auth_controllers_manager.dart';
import 'package:legal_defender/common/utils/auth_validators.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_event.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_state.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_bottom_bar.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_button.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_header.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_state_listener.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:legal_defender/features/auth/presentation/widgets/password_reset_dialog.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginControllersManager _controllersManager;
  bool _isPasswordVisible = false;
  bool _canLogin = false;

  @override
  void initState() {
    super.initState();
    _controllersManager = LoginControllersManager(
      onFormChanged: _checkFormValidity,
    );
  }

  @override
  void dispose() {
    _controllersManager.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    // Use the controllers manager for cleaner validation logic
    final newCanLogin = _controllersManager.canAttemptLogin &&
        AuthValidators.validateEmail(_controllersManager.email) == null;

    if (_canLogin != newCanLogin) {
      setState(() {
        _canLogin = newCanLogin;
      });
    }
  }

  void _handleLogin() {
    if (_controllersManager.validate()) {
      context.read<AuthBloc>().add(
            SignInWithEmailAndPasswordEvent(
              email: _controllersManager.email,
              password: _controllersManager.password,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthStateListener(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _controllersManager.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     AuthHeader(
                      title: AppLocalizations.getString(context, 'auth.welcomeBack'),
                      subtitle: AppLocalizations.getString(context, 'auth.signIn'
                      )
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    AuthTextField(
                      controller: _controllersManager.emailController,
                      label: AppLocalizations.getString(context, 'auth.email'),
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: AuthValidators.validateEmail,
                      onChanged: (value) => _checkFormValidity(),
                    )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 16),

                    // Password Field
                    AuthTextField(
                      controller: _controllersManager.passwordController,
                      label: AppLocalizations.getString(context, 'auth.password'),
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) =>
                          AuthValidators.validateRequired(value, 'Password'),
                      onChanged: (value) => _checkFormValidity(),
                    )
                        .animate(delay: 500.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => showPasswordResetDialog(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.getString(context, 'auth.forgotPassword'),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ).animate(delay: 600.ms).fadeIn(duration: 600.ms),
                    const SizedBox(height: 32),

                    // Login Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AuthButton(
                          text: AppLocalizations.getString(context, 'auth.signInLink'),
                          isEnabled:
                              _canLogin && state.status != AuthStatus.loading,
                          isLoading: state.status == AuthStatus.loading,
                          onPressed: _handleLogin,
                          heroTag: 'login_button',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomBar(
        promptText: AppLocalizations.getString(context, 'auth.dontHaveAccount'),
        actionText: AppLocalizations.getString(context, 'auth.signUpLink'),
        onActionPressed: () {
          context.router.push(const RegisterRoute());
        },
        heroTag: 'auth_toggle_button',
      ),
    );
  }
}
