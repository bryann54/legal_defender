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
import 'package:legal_defender/features/auth/presentation/widgets/language_dropdown.dart';
import 'package:legal_defender/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:legal_defender/features/auth/presentation/widgets/profile_type_dropdown.dart';
import 'package:legal_defender/features/auth/presentation/widgets/referral_code_field.dart';
import 'package:legal_defender/features/auth/presentation/widgets/us_state_dropdown.dart';
import 'package:legal_defender/features/auth/presentation/widgets/username_field.dart';

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
    // Calling validate() now flips showErrors to true in the manager
    if (_manager.validate()) {
      context.read<AuthBloc>().add(
            SignUpEvent(
              email: _manager.email,
              password: _manager.password,
              username: _manager.userName,
              phoneNumber: _manager.phone,
              state: _manager.state,
              profileType: _manager.profileType,
              language: _manager.language,
              referralCode: _manager.referralCode,
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
              // Only validate on user interaction AFTER the first submit attempt
              autovalidateMode: _manager.showErrors
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
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
                    controller: _manager.emailController,
                    label: AppLocalizations.getString(context, 'auth.email'),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => AuthValidators.validateEmail(context, v),
                  ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  UsernameField(
                    controller: _manager.usernameController,
                    onChanged: (_) => setState(() {}),
                    animationDelay: 100,
                    validator: (v) =>
                        AuthValidators.validateUsername(context, v),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _manager.phoneController,
                    label:
                        AppLocalizations.getString(context, 'auth.phoneNumber'),
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => AuthValidators.validatePhone(context, v),
                  ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _manager.passwordController,
                    label: AppLocalizations.getString(context, 'auth.password'),
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                    validator: (v) => AuthValidators.validatePassword(
                        context, v,
                        isStrict: true),
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
                        context, v, _manager.password),
                  ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 24),
                  ProfileTypeDropdown(
                    selectedType: _manager.selectedProfileType,
                    onChanged: _manager.updateProfileType,
                    errorText: _manager.showErrors &&
                            _manager.selectedProfileType == null
                        ? AppLocalizations.getString(
                                context, 'validation.required')
                            .replaceFirst(
                                '{field}',
                                AppLocalizations.getString(
                                    context, 'profileType'))
                        : null,
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  UsStateDropdown(
                    selectedState: _manager.selectedState,
                    onChanged: _manager.updateState,
                    errorText: _manager.showErrors &&
                            _manager.selectedState == null
                        ? AppLocalizations.getString(
                                context, 'validation.required')
                            .replaceFirst('{field}',
                                AppLocalizations.getString(context, 'state'))
                        : null,
                  ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  LanguageDropdown(
                    selectedLanguage: _manager.selectedLanguage,
                    onChanged: _manager.updateLanguage,
                    errorText: _manager.showErrors &&
                            _manager.selectedLanguage == null
                        ? AppLocalizations.getString(
                                context, 'validation.required')
                            .replaceFirst('{field}',
                                AppLocalizations.getString(context, 'language'))
                        : null,
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  ReferralCodeField(
                    controller: _manager.referralCodeController,
                  ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      // Button logic remains reactive to current input state
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
                  ).animate(delay: 500.ms).fadeIn(),
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
