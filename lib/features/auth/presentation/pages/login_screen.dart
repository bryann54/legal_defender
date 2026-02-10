// lib/features/auth/presentation/pages/login_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_defender/common/utils/auth_controllers_manager.dart';
import 'package:legal_defender/common/utils/auth_validators.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_event.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_state.dart';
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
    // Pass setState as the listener to refresh the "Login" button state automatically
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
                children: [
                  const AuthHeader(
                      title: 'Welcome Back', subtitle: 'Sign in to continue'),
                  const SizedBox(height: 40),
                  AuthTextField(
                    controller: _manager.emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    validator: AuthValidators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _manager.passwordController,
                    label: 'Password',
                    isPassword: true,
                    icon: Icons.lock_outline,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                    validator: (v) =>
                        AuthValidators.validateRequired(v, 'Password'),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        text: 'Sign In',
                        heroTag: 'login_button',
                        isEnabled: _manager.canAttemptLogin &&
                            state.status != AuthStatus.loading,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: _handleLogin,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
