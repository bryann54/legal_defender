import 'dart:ui';

class AuthValidators {
  AuthValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }

    final trimmedValue = value.trim();
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    // Additional checks
    if (trimmedValue.length > 254) {
      return 'Email address is too long';
    }

    // Check for consecutive dots
    if (trimmedValue.contains('..')) {
      return 'Email address cannot contain consecutive dots';
    }

    // Check for valid domain
    final parts = trimmedValue.split('@');
    if (parts.length != 2) {
      return 'Please enter a valid email address';
    }

    final domain = parts[1];
    if (!domain.contains('.')) {
      return 'Please enter a valid email domain';
    }

    // Check domain length
    final domainParts = domain.split('.');
    if (domainParts.any((part) => part.isEmpty)) {
      return 'Please enter a valid email domain';
    }

    // Check TLD length (minimum 2 characters)
    if (domainParts.last.length < 2) {
      return 'Please enter a valid email domain';
    }

    return null;
  }

  // Password validation with comprehensive security requirements
  static String? validatePassword(String? value, {bool isStrict = true}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (isStrict) {
      // Check for uppercase letter
      if (!value.contains(RegExp(r'[A-Z]'))) {
        return 'Password must contain at least one uppercase letter';
      }

      // Check for lowercase letter
      if (!value.contains(RegExp(r'[a-z]'))) {
        return 'Password must contain at least one lowercase letter';
      }

      // Check for digit
      if (!value.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain at least one number';
      }

      // Check for special character
      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return 'Password must contain at least one special character';
      }

      // Check for common weak passwords
      final commonPasswords = [
        'password',
        '12345678',
        'qwerty',
        'abc123',
        'password123',
        'admin123',
      ];
      if (commonPasswords.contains(value.toLowerCase())) {
        return 'This password is too common. Please choose a stronger password';
      }

      // Check for sequential characters
      if (_hasSequentialChars(value)) {
        return 'Password should not contain sequential characters';
      }
    }

    if (value.length > 128) {
      return 'Password is too long (maximum 128 characters)';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // First name validation
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'First name must be at least 2 characters';
    }

    if (trimmedValue.length > 50) {
      return 'First name is too long (maximum 50 characters)';
    }

    // Allow only letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(trimmedValue)) {
      return 'First name can only contain letters, spaces, hyphens, and apostrophes';
    }

    // Check for excessive spaces
    if (trimmedValue.contains(RegExp(r'\s{2,}'))) {
      return 'First name cannot contain consecutive spaces';
    }

    return null;
  }

  // Last name validation
  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'Last name must be at least 2 characters';
    }

    if (trimmedValue.length > 50) {
      return 'Last name is too long (maximum 50 characters)';
    }

    // Allow only letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(trimmedValue)) {
      return 'Last name can only contain letters, spaces, hyphens, and apostrophes';
    }

    // Check for excessive spaces
    if (trimmedValue.contains(RegExp(r'\s{2,}'))) {
      return 'Last name cannot contain consecutive spaces';
    }

    return null;
  }

  // Phone number validation (optional, for future use)
  static String? validatePhoneNumber(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Phone number is required' : null;
    }

    final trimmedValue = value.trim();

    // Remove common formatting characters
    final digitsOnly = trimmedValue.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    // Check if it contains only digits after removing formatting
    if (!RegExp(r'^[0-9]+$').hasMatch(digitsOnly)) {
      return 'Phone number can only contain digits and formatting characters';
    }

    // Check length (allowing for international numbers)
    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Generic required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Helper method to check for sequential characters
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
        // Check reverse sequence
        if (lowerPassword.contains(subSequence.split('').reversed.join())) {
          return true;
        }
      }
    }

    return false;
  }

  // Password strength calculator (returns 0-4)
  static int calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Complexity checks
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    // Cap at 4
    return strength > 4 ? 4 : strength;
  }

  // Get password strength text
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  // Get password strength color
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
}
