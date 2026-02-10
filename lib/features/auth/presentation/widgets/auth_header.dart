// lib/features/auth/presentation/widgets/auth_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Logo/Icon
        Center(
          child: Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/legal_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ).animate().slideX(duration: 800.ms).fadeIn(duration: 800.ms),
        ),

        const SizedBox(height: 24),

        // Title
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ).animate().slideY(duration: 800.ms).fadeIn(duration: 800.ms),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
