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
  @override
  void initState() {
    super.initState();
    // Start logic immediately
    context.read<AuthBloc>().add(const CheckAuthStatusEvent());

    // Start the timer and trigger navigation attempt when done
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _attemptNavigation(context.read<AuthBloc>().state);
      }
    });
  }

  void _attemptNavigation(AuthState state) {
    // 1. Logic Guard: Don't navigate if we are still 'loading' or 'initial'
    // even if the 3 seconds are up.
    if (state.status == AuthStatus.loading ||
        state.status == AuthStatus.initial) {
      return;
    }

    // 2. Navigation logic
    switch (state.status) {
      case AuthStatus.authenticated:
        context.router.replace(MainRoute());
      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        context.router.replace(const AuthRoute());
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      // Only listen, don't rebuild the whole body for status changes
      // unless you actually need to show a loader.
      listener: (context, state) => _attemptNavigation(state),
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
