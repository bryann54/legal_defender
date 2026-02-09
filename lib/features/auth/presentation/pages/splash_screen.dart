// lib/features/auth/presentation/pages/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_event.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_state.dart';
import 'package:legal_defender/common/res/colors.dart';
import 'package:legal_defender/features/auth/presentation/widgets/splash_content.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minimumDelayComplete = false;
  bool _authCheckComplete = false;
  AuthState? _authStateToNavigate;

  @override
  void initState() {
    super.initState();
    // Start the minimum delay timer
    _startMinimumDelay();
    // Trigger auth check when splash screen loads
    context.read<AuthBloc>().add(const CheckAuthStatusEvent());
  }

  void _startMinimumDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _minimumDelayComplete = true;
        });
        _checkIfReadyToNavigate();
      }
    });
  }

  void _onAuthStateChanged(AuthState state) {
    // Only consider non-initial/loading states
    if (state.status != AuthStatus.initial &&
        state.status != AuthStatus.loading) {
      setState(() {
        _authCheckComplete = true;
        _authStateToNavigate = state;
      });
      _checkIfReadyToNavigate();
    }
  }

  void _checkIfReadyToNavigate() {
    // Only navigate when both conditions are met
    if (_minimumDelayComplete &&
        _authCheckComplete &&
        _authStateToNavigate != null) {
      _navigateBasedOnAuthState(_authStateToNavigate!);
    }
  }

  void _navigateBasedOnAuthState(AuthState state) {
    if (!mounted) return;

    switch (state.status) {
      case AuthStatus.authenticated:
        context.router.replace(MainRoute());
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.error:
         context.router.replace(AuthRoute());
        // context.router.replace(HomeRoute());

        break;
      case AuthStatus.initial:
      case AuthStatus.loading:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _onAuthStateChanged(state);
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackgroundColor
            : AppColors.lightBackgroundColor,
        body: const Center(
          child: SplashContent(),
        ),
      ),
    );
  }
}
