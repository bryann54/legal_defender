// lib/features/auth/presentation/widgets/terms_privacy_text.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsPrivacyText extends StatelessWidget {
  const TermsPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final linkStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: linkStyle,
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
        ),
      ),
    );
  }
}
