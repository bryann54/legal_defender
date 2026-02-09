// lib/features/auth/presentation/widgets/auth_container.dart

import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/colors.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AuthContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? const EdgeInsets.all(AppColors.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardColor : AppColors.lightCardColor,
        borderRadius: BorderRadius.circular(AppColors.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
