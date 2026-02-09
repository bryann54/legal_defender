// lib/features/auth/presentation/pages/register_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import 'package:legal_defender/features/auth/presentation/widgets/password_strength_indicator.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterControllersManager _controllersManager;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _canRegister = false;
  int _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    _controllersManager = RegisterControllersManager(
      onFormChanged: _checkFormValidity,
    );
  }

  @override
  void dispose() {
    _controllersManager.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    // Calculate password strength
    final newPasswordStrength = AuthValidators.calculatePasswordStrength(
      _controllersManager.password,
    );

    // Check if form is valid
    final newCanRegister = _controllersManager.canAttemptRegister &&
        _controllersManager.passwordsMatch &&
        _controllersManager.passwordMeetsMinLength(8) &&
        AuthValidators.validateEmail(_controllersManager.email) == null;

    if (_canRegister != newCanRegister ||
        _passwordStrength != newPasswordStrength) {
      setState(() {
        _canRegister = newCanRegister;
        _passwordStrength = newPasswordStrength;
      });
    }
  }

  void _handleRegister() {
    if (_controllersManager.validate()) {
      context.read<AuthBloc>().add(
            SignUpWithEmailAndPasswordEvent(
              email: _controllersManager.email,
              password: _controllersManager.password,
              firstName: '',
              lastName: '',
              profileImage: null,
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _controllersManager.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   AuthHeader(
                    title: AppLocalizations.getString(context, 'auth.createAccount'),
                    subtitle: AppLocalizations.getString(context, 'auth.setupAccount'),
                  ),
                  const SizedBox(height: 40),
AuthTextField(controller: _controllersManager.firstNameController, label:AppLocalizations.getString(context,'profile.username'), icon: Icons.person_outline,).animate(delay: 100.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  // Email Field
                  AuthTextField(
                    controller: _controllersManager.emailController,
                    label: AppLocalizations.getString(context, 'auth.email'),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidators.validateEmail,
                    onChanged: (value) => _checkFormValidity(),
                  )
                      .animate(delay: 300.ms)
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
                        AuthValidators.validatePassword(value, isStrict: true),
                    onChanged: (value) => _checkFormValidity(),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  // Password Strength Indicator
                  if (_controllersManager.hasPassword)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: PasswordStrengthIndicator(
                        strength: _passwordStrength,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  AuthTextField(
                    controller: _controllersManager.confirmPasswordController,
                    label: AppLocalizations.getString(context, 'auth.confirmPassword'),
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    validator: (value) =>
                        AuthValidators.validateConfirmPassword(
                      value,
                      _controllersManager.password,
                    ),
                    onChanged: (value) => _checkFormValidity(),
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 32),

                  // Register Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        text: AppLocalizations.getString(context, 'auth.createAccount'),
                        isEnabled:
                            _canRegister && state.status != AuthStatus.loading,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: _handleRegister,
                        heroTag: 'register_button',
                      );
                    },
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomBar(
        promptText: AppLocalizations.getString(context, 'auth.alreadyHaveAccount'),
        actionText: AppLocalizations.getString(context, 'auth.signInLink'),
        onActionPressed: () {
          context.router.maybePop();
        },
        heroTag: 'auth_toggle_button',
      ),
    );
  }
}
