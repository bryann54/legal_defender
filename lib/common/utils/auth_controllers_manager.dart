// lib/common/utils/auth_controllers_manager.dart

import 'package:flutter/material.dart';

abstract class BaseAuthManager {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final VoidCallback? onFormChanged;

  BaseAuthManager(this.onFormChanged);

  void dispose();
  bool validate() => formKey.currentState?.validate() ?? false;
}

class LoginControllersManager extends BaseAuthManager {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Fix: Explicitly pass the parameter to the super constructor
  LoginControllersManager({VoidCallback? onFormChanged})
      : super(onFormChanged) {
    if (onFormChanged != null) {
      emailController.addListener(onFormChanged);
      passwordController.addListener(onFormChanged);
    }
  }

  String get email => emailController.text.trim();
  String get password => passwordController.text;

  bool get canAttemptLogin => email.isNotEmpty && password.isNotEmpty;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class RegisterControllersManager extends BaseAuthManager {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final stateController = TextEditingController();

  RegisterControllersManager({VoidCallback? onFormChanged})
      : super(onFormChanged) {
    if (onFormChanged != null) {
      emailController.addListener(onFormChanged);
      passwordController.addListener(onFormChanged);
      confirmPasswordController.addListener(onFormChanged);
      usernameController.addListener(onFormChanged);
      phoneController.addListener(onFormChanged);
      stateController.addListener(onFormChanged);
    }
  }

  String get email => emailController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;
  String get userName => usernameController.text.trim();
  String get phone => phoneController.text.trim();
  String get state => stateController.text.trim();

  // Fix: Added the missing getter for the Register Screen
  bool get passwordsMatch => password == confirmPassword;

  bool get canAttemptRegister =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      userName.isNotEmpty;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    stateController.dispose();
  }
}

class PasswordResetControllersManager extends BaseAuthManager {
  final emailController = TextEditingController();

  PasswordResetControllersManager({VoidCallback? onFormChanged})
      : super(onFormChanged) {
    if (onFormChanged != null) {
      emailController.addListener(onFormChanged);
    }
  }

  String get email => emailController.text.trim();
  bool get hasEmail => email.isNotEmpty;

  @override
  void dispose() {
    emailController.dispose();
  }
}
