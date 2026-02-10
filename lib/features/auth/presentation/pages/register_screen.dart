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
// lib/features/auth/presentation/pages/register_screen.dart

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterControllersManager _manager;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _manager = RegisterControllersManager(
      onFormChanged: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_manager.validate()) {
      context.read<AuthBloc>().add(
            SignUpEvent(
              email: _manager.email,
              password: _manager.password,
              username: _manager.userName,
              phoneNumber: _manager.phone,
              state: _manager.state,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength =
        AuthValidators.calculatePasswordStrength(_manager.password);

    return Scaffold(
      body: AuthStateListener(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _manager.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    title: AppLocalizations.getString(
                        context, 'auth.createAccount'),
                    subtitle: AppLocalizations.getString(
                        context, 'auth.setupAccount'),
                  ),
                  const SizedBox(height: 40),
                  AuthTextField(
                    controller: _manager.usernameController,
                    label:
                        AppLocalizations.getString(context, 'profile.username'),
                    icon: Icons.person_outline,
                  ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _manager.emailController,
                    label: AppLocalizations.getString(context, 'auth.email'),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidators.validateEmail,
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _manager.passwordController,
                    label: AppLocalizations.getString(context, 'auth.password'),
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                    validator: (v) =>
                        AuthValidators.validatePassword(v, isStrict: true),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  if (_manager.password.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: PasswordStrengthIndicator(strength: strength),
                    ).animate().fadeIn(),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _manager.confirmPasswordController,
                    label: AppLocalizations.getString(
                        context, 'auth.confirmPassword'),
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onVisibilityToggle: () => setState(() =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    validator: (v) => AuthValidators.validateConfirmPassword(
                        v, _manager.password),
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isReady = _manager.canAttemptRegister &&
                          _manager.passwordsMatch &&
                          state.status != AuthStatus.loading;

                      return AuthButton(
                        text: AppLocalizations.getString(
                            context, 'auth.createAccount'),
                        isEnabled: isReady,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: _handleRegister,
                        heroTag: 'register_button',
                      );
                    },
                  ).animate(delay: 400.ms).fadeIn(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomBar(
        promptText:
            AppLocalizations.getString(context, 'auth.alreadyHaveAccount'),
        actionText: AppLocalizations.getString(context, 'auth.signInLink'),
        onActionPressed: () => context.router.maybePop(),
        heroTag: 'auth_toggle_button',
      ),
    );
  }
}
