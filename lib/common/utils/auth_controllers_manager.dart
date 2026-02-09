import 'package:flutter/material.dart';

class AuthControllersManager {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController phoneController;

  // Form key
  final GlobalKey<FormState> formKey;

  // Callbacks
  final VoidCallback? onFormChanged;

  AuthControllersManager({
    this.onFormChanged,
    GlobalKey<FormState>? formKey,
  }) : formKey = formKey ?? GlobalKey<FormState>() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();

    // Add listeners if callback provided
    if (onFormChanged != null) {
      _addListeners();
    }
  }

  /// Add change listeners to all controllers
  void _addListeners() {
    emailController.addListener(onFormChanged!);
    passwordController.addListener(onFormChanged!);
    confirmPasswordController.addListener(onFormChanged!);
    firstNameController.addListener(onFormChanged!);
    lastNameController.addListener(onFormChanged!);
    phoneController.addListener(onFormChanged!);
  }

  /// Remove change listeners from all controllers
  void _removeListeners() {
    if (onFormChanged != null) {
      emailController.removeListener(onFormChanged!);
      passwordController.removeListener(onFormChanged!);
      confirmPasswordController.removeListener(onFormChanged!);
      firstNameController.removeListener(onFormChanged!);
      lastNameController.removeListener(onFormChanged!);
      phoneController.removeListener(onFormChanged!);
    }
  }

  /// Dispose all controllers
  void dispose() {
    _removeListeners();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
  }

  /// Clear all text fields
  void clearAll() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
  }

  /// Clear password fields only
  void clearPasswords() {
    passwordController.clear();
    confirmPasswordController.clear();
  }

  /// Validate the form
  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  /// Get trimmed email
  String get email => emailController.text.trim();

  /// Get password (no trimming for passwords)
  String get password => passwordController.text;

  /// Get confirm password
  String get confirmPassword => confirmPasswordController.text;

  /// Get trimmed first name
  String get firstName => firstNameController.text.trim();

  /// Get trimmed last name
  String get lastName => lastNameController.text.trim();

  /// Get trimmed phone
  String get phone => phoneController.text.trim();

  /// Check if email field has content
  bool get hasEmail => emailController.text.trim().isNotEmpty;

  /// Check if password field has content
  bool get hasPassword => passwordController.text.isNotEmpty;

  /// Check if confirm password field has content
  bool get hasConfirmPassword => confirmPasswordController.text.isNotEmpty;

  /// Check if first name field has content
  bool get hasFirstName => firstNameController.text.trim().isNotEmpty;

  /// Check if last name field has content
  bool get hasLastName => lastNameController.text.trim().isNotEmpty;

  /// Check if all login fields are filled
  bool get canAttemptLogin => hasEmail && hasPassword;

  /// Check if all registration fields are filled
  bool get canAttemptRegister => hasEmail && hasPassword && hasConfirmPassword;

  /// Check if all registration fields including names are filled
  bool get canAttemptFullRegister =>
      hasEmail &&
      hasPassword &&
      hasConfirmPassword &&
      hasFirstName &&
      hasLastName;

  /// Check if passwords match
  bool get passwordsMatch => password == confirmPassword;

  /// Check if password meets minimum length
  bool passwordMeetsMinLength([int minLength = 8]) {
    return password.length >= minLength;
  }
}

/// A specialized version for login screen
class LoginControllersManager {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onFormChanged;

  LoginControllersManager({
    this.onFormChanged,
    GlobalKey<FormState>? formKey,
  }) : formKey = formKey ?? GlobalKey<FormState>() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    if (onFormChanged != null) {
      emailController.addListener(onFormChanged!);
      passwordController.addListener(onFormChanged!);
    }
  }

  void dispose() {
    if (onFormChanged != null) {
      emailController.removeListener(onFormChanged!);
      passwordController.removeListener(onFormChanged!);
    }
    emailController.dispose();
    passwordController.dispose();
  }

  void clearAll() {
    emailController.clear();
    passwordController.clear();
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  String get email => emailController.text.trim();
  String get password => passwordController.text;

  bool get hasEmail => emailController.text.trim().isNotEmpty;
  bool get hasPassword => passwordController.text.isNotEmpty;
  bool get canAttemptLogin => hasEmail && hasPassword;
}

/// A specialized version for registration screen
class RegisterControllersManager {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onFormChanged;

  RegisterControllersManager({
    this.onFormChanged,
    GlobalKey<FormState>? formKey,
  }) : formKey = formKey ?? GlobalKey<FormState>() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();

    if (onFormChanged != null) {
      _addListeners();
    }
  }

  void _addListeners() {
    emailController.addListener(onFormChanged!);
    passwordController.addListener(onFormChanged!);
    confirmPasswordController.addListener(onFormChanged!);
    firstNameController.addListener(onFormChanged!);
    lastNameController.addListener(onFormChanged!);
  }

  void _removeListeners() {
    if (onFormChanged != null) {
      emailController.removeListener(onFormChanged!);
      passwordController.removeListener(onFormChanged!);
      confirmPasswordController.removeListener(onFormChanged!);
      firstNameController.removeListener(onFormChanged!);
      lastNameController.removeListener(onFormChanged!);
    }
  }

  void dispose() {
    _removeListeners();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  void clearAll() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  void clearPasswords() {
    passwordController.clear();
    confirmPasswordController.clear();
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  String get email => emailController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;
  String get firstName => firstNameController.text.trim();
  String get lastName => lastNameController.text.trim();

  bool get hasEmail => emailController.text.trim().isNotEmpty;
  bool get hasPassword => passwordController.text.isNotEmpty;
  bool get hasConfirmPassword => confirmPasswordController.text.isNotEmpty;
  bool get hasFirstName => firstNameController.text.trim().isNotEmpty;
  bool get hasLastName => lastNameController.text.trim().isNotEmpty;

  bool get canAttemptRegister => hasEmail && hasPassword && hasConfirmPassword;

  bool get canAttemptFullRegister =>
      canAttemptRegister && hasFirstName && hasLastName;

  bool get passwordsMatch => password == confirmPassword;

  bool passwordMeetsMinLength([int minLength = 8]) {
    return password.length >= minLength;
  }
}

/// A specialized version for password reset
class PasswordResetControllersManager {
  late final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onFormChanged;

  PasswordResetControllersManager({
    this.onFormChanged,
    GlobalKey<FormState>? formKey,
  }) : formKey = formKey ?? GlobalKey<FormState>() {
    emailController = TextEditingController();

    if (onFormChanged != null) {
      emailController.addListener(onFormChanged!);
    }
  }

  void dispose() {
    if (onFormChanged != null) {
      emailController.removeListener(onFormChanged!);
    }
    emailController.dispose();
  }

  void clear() {
    emailController.clear();
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  String get email => emailController.text.trim();
  bool get hasEmail => emailController.text.trim().isNotEmpty;
}
