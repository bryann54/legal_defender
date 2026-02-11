// lib/features/auth/presentation/pages/login_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';
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

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginControllersManager _manager;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _manager = LoginControllersManager(onFormChanged: () => setState(() {}));
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_manager.validate()) {
      context.read<AuthBloc>().add(
            SignInEvent(
              email: _manager.email,
              password: _manager.password,
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
              key: _manager.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    title:
                        AppLocalizations.getString(context, 'auth.welcomeBack'),
                    subtitle:
                        AppLocalizations.getString(context, 'auth.signIn'),
                  ),
                  const SizedBox(height: 40),

                  // Staggered Animation 1: Email Field
                  AuthTextField(
                    controller: _manager.emailController,
                    label: AppLocalizations.getString(context, 'auth.email'),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        AuthValidators.validateEmail(context, value),
                  ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 16),

                  // Staggered Animation 2: Password Field (100ms delay)
                  AuthTextField(
                    controller: _manager.passwordController,
                    label: AppLocalizations.getString(context, 'auth.password'),
                    isPassword: true,
                    icon: Icons.lock_outline,
                    isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                    validator: (value) => AuthValidators.validatePassword(
                        context, value,
                        isStrict: true),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 32),

                  // Staggered Animation 3: Login Button (200ms delay)
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isReady = _manager.canAttemptLogin &&
                          state.status != AuthStatus.loading;

                      return AuthButton(
                        text: AppLocalizations.getString(
                            context, 'auth.signInLink'),
                        heroTag: 'login_button',
                        isEnabled: isReady,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: _handleLogin,
                      );
                    },
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
                ],
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
