// lib/features/auth/presentation/pages/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_content.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_state_listener.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthStateListener(
        child: AuthContent(),
      ),
    );
  }
}
