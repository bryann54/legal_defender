// lib/features/auth/presentation/widgets/name_fields_row.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/utils/auth_validators.dart';
import 'package:legal_defender/features/auth/presentation/widgets/auth_text_field.dart';

class NameFieldsRow extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String>? onChanged;
  final int? animationDelay;

  const NameFieldsRow({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    this.onChanged,
    this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        // First Name Field
        Expanded(
          child: AuthTextField(
            controller: firstNameController,
            label: AppLocalizations.getString(context, 'auth.first name'),
            icon: Icons.person_outline,
            validator: AuthValidators.validateFirstName,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),

        // Last Name Field
        Expanded(
          child: AuthTextField(
            controller: lastNameController,
            label:  AppLocalizations.getString(context, 'auth.last name'),
            icon: Icons.person_outline,
            validator: AuthValidators.validateLastName,
            onChanged: onChanged,
          ),
        ),
      ],
    );

    // Apply animation if delay is provided
    if (animationDelay != null) {
      return row
          .animate(delay: Duration(milliseconds: animationDelay!))
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0);
    }

    return row;
  }
}
