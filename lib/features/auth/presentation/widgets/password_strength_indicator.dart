import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legal_defender/common/utils/auth_validators.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strength; // 0-4

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final strengthText = AuthValidators.getPasswordStrengthText(strength);
    final strengthColor = AuthValidators.getPasswordStrengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bars
        Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < 3 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: index < strength
                      ? strengthColor
                      : Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Strength text
        Text(
          'Password strength: $strengthText',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: strengthColor,
          ),
        ),

        // Password requirements (show if weak)
        if (strength < 3) ...[
          const SizedBox(height: 4),
          Text(
            'Must include: uppercase, lowercase, number & special character',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }
}
