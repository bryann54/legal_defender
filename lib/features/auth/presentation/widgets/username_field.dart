// lib/features/auth/presentation/widgets/username_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/utils/auth_validators.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_text_field.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int? animationDelay;
  final String? Function(String?)? validator;

  const UsernameField({
    super.key,
    required this.controller,
    this.onChanged,
    this.animationDelay,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final field = AuthTextField(
      controller: controller,
      label: AppLocalizations.getString(context, 'auth.username'),
      icon: Icons.person_outline,
      validator: validator ??
          (value) => AuthValidators.validateUsername(context, value),
      onChanged: onChanged,
    );

    if (animationDelay != null) {
      return field
          .animate(
            delay: Duration(milliseconds: animationDelay!),
          )
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0);
    }

    return field;
  }
}
