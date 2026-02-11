// lib/common/utils/auth_validators.dart

import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/l10n.dart'; // adjust import path as needed

class AuthValidators {
  AuthValidators._();

  // -------------------- EMAIL --------------------
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(context, 'auth.emailRequired');
    }

    final trimmedValue = value.trim();
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return AppLocalizations.getString(context, 'auth.invalidEmail');
    }

    if (trimmedValue.length > 254) {
      return AppLocalizations.getString(context, 'auth.emailTooLong');
    }

    if (trimmedValue.contains('..')) {
      return AppLocalizations.getString(context, 'auth.emailConsecutiveDots');
    }

    final parts = trimmedValue.split('@');
    if (parts.length != 2) {
      return AppLocalizations.getString(context, 'auth.invalidEmailDomain');
    }

    final domain = parts[1];
    if (!domain.contains('.')) {
      return AppLocalizations.getString(context, 'auth.invalidEmailDomain');
    }

    final domainParts = domain.split('.');
    if (domainParts.any((part) => part.isEmpty)) {
      return AppLocalizations.getString(context, 'auth.invalidEmailDomain');
    }

    if (domainParts.last.length < 2) {
      return AppLocalizations.getString(context, 'auth.invalidEmailDomain');
    }

    return null;
  }

  // -------------------- USERNAME --------------------
  static String? validateUsername(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(context, 'auth.usernameRequired');
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return AppLocalizations.getString(context, 'auth.usernameTooShort');
    }

    if (trimmedValue.length > 30) {
      return AppLocalizations.getString(context, 'auth.usernameTooLong');
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_.]+$');
    if (!usernameRegex.hasMatch(trimmedValue)) {
      return AppLocalizations.getString(
          context, 'auth.usernameInvalidCharacters');
    }

    if (trimmedValue.startsWith('.') ||
        trimmedValue.startsWith('_') ||
        trimmedValue.endsWith('.') ||
        trimmedValue.endsWith('_')) {
      return AppLocalizations.getString(
          context, 'auth.usernameInvalidStartEnd');
    }

    if (trimmedValue.contains('..') ||
        trimmedValue.contains('__') ||
        trimmedValue.contains('_.') ||
        trimmedValue.contains('._')) {
      return AppLocalizations.getString(
          context, 'auth.usernameConsecutiveSpecial');
    }

    return null;
  }

  // -------------------- PASSWORD --------------------
  static String? validatePassword(
    BuildContext context,
    String? value, {
    bool isStrict = true,
  }) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.getString(context, 'auth.passwordRequired');
    }

    if (value.length < 8) {
      return AppLocalizations.getString(context, 'auth.passwordTooShort');
    }

    if (isStrict) {
      if (!value.contains(RegExp(r'[A-Z]'))) {
        return AppLocalizations.getString(
            context, 'auth.passwordRequiresUppercase');
      }
      if (!value.contains(RegExp(r'[a-z]'))) {
        return AppLocalizations.getString(
            context, 'auth.passwordRequiresLowercase');
      }
      if (!value.contains(RegExp(r'[0-9]'))) {
        return AppLocalizations.getString(
            context, 'auth.passwordRequiresNumber');
      }
      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return AppLocalizations.getString(
            context, 'auth.passwordRequiresSpecial');
      }

      final commonPasswords = [
        'password',
        '12345678',
        'qwerty',
        'abc123',
        'password123',
        'admin123',
      ];
      if (commonPasswords.contains(value.toLowerCase())) {
        return AppLocalizations.getString(context, 'auth.passwordCommon');
      }

      if (_hasSequentialChars(value)) {
        return AppLocalizations.getString(context, 'auth.passwordSequential');
      }
    }

    if (value.length > 128) {
      return AppLocalizations.getString(context, 'auth.passwordTooLong');
    }

    return null;
  }

  // -------------------- CONFIRM PASSWORD --------------------
  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.getString(
          context, 'auth.confirmPasswordRequired');
    }

    if (value != originalPassword) {
      return AppLocalizations.getString(context, 'auth.passwordsDontMatch');
    }

    return null;
  }

  // -------------------- PHONE --------------------
  static String? validatePhone(BuildContext context, String? value,
      {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired
          ? AppLocalizations.getString(context, 'auth.phoneRequired')
          : null;
    }

    final trimmedValue = value.trim();

    // Remove common formatting characters
    final digitsOnly = trimmedValue.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (!RegExp(r'^[0-9]+$').hasMatch(digitsOnly)) {
      return AppLocalizations.getString(context, 'auth.phoneInvalidCharacters');
    }

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return AppLocalizations.getString(context, 'auth.phoneInvalidLength');
    }

    return null;
  }

  // -------------------- GENERIC REQUIRED --------------------
  static String? validateRequired(
    BuildContext context,
    String? value,
    String fieldName, {
    String? customMessageKey,
  }) {
    if (value == null || value.trim().isEmpty) {
      if (customMessageKey != null) {
        return AppLocalizations.getString(context, customMessageKey);
      }
      return '$fieldName is required'; // fallback – better to always provide a key
    }
    return null;
  }

  // -------------------- PASSWORD STRENGTH --------------------
  static int calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength > 4 ? 4 : strength;
  }

  static String getPasswordStrengthText(BuildContext context, int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppLocalizations.getString(context, 'common.weak');
      case 2:
        return AppLocalizations.getString(context, 'common.fair');
      case 3:
        return AppLocalizations.getString(context, 'common.good');
      case 4:
        return AppLocalizations.getString(context, 'common.strong');
      default:
        return AppLocalizations.getString(context, 'common.weak');
    }
  }

  static Color getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return const Color(0xFFEF4444); // Red
      case 2:
        return const Color(0xFFF59E0B); // Orange
      case 3:
        return const Color(0xFF3B82F6); // Blue
      case 4:
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFFEF4444);
    }
  }

  // -------------------- HELPERS --------------------
  static bool _hasSequentialChars(String password) {
    final sequences = [
      '0123456789',
      'abcdefghijklmnopqrstuvwxyz',
      'qwertyuiop',
      'asdfghjkl',
      'zxcvbnm',
    ];

    final lowerPassword = password.toLowerCase();

    for (final sequence in sequences) {
      for (int i = 0; i <= sequence.length - 4; i++) {
        final subSequence = sequence.substring(i, i + 4);
        if (lowerPassword.contains(subSequence)) {
          return true;
        }
        if (lowerPassword.contains(subSequence.split('').reversed.join())) {
          return true;
        }
      }
    }

    return false;
  }
}
