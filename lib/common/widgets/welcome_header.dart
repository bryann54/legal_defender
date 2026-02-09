// lib/common/widgets/welcome_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeHeader extends StatelessWidget {
  final String? firstName;

  const WelcomeHeader({super.key, this.firstName});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 4) {
      return 'Good night,';
    } else if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 17) {
      return 'Good afternoon,';
    } else if (hour < 21) {
      return 'Good evening,';
    } else {
      return 'Good night,';
    }
  }

  String get _displayName =>
      firstName?.isNotEmpty == true ? firstName! : 'User';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildGreetingSection(context),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(
          begin: -0.1,
          duration: 700.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildGreetingSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.grey,
          ),
        ).animate().slideX(duration: 300.ms).fadeIn(duration: 300.ms),
        Text(
          _displayName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
      ],
    );
  }
}
