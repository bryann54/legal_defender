// lib/common/utils/auth_controllers_manager.dart

import 'package:flutter/material.dart';
import 'package:legal_defender/common/constants/us_states.dart';
import 'package:legal_defender/features/auth/presentation/widgets/language_dropdown.dart';
import 'package:legal_defender/features/auth/presentation/widgets/profile_type_dropdown.dart';

abstract class BaseAuthManager {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final VoidCallback? onFormChanged;

  // Controls global error visibility
  bool showErrors = false;

  BaseAuthManager(this.onFormChanged);

  void dispose();

  bool validate() {
    showErrors = true;
    onFormChanged?.call();
    return formKey.currentState?.validate() ?? false;
  }
}

class LoginControllersManager extends BaseAuthManager {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  final referralCodeController = TextEditingController();

  UsState? selectedState;
  ProfileType? selectedProfileType;
  AppLanguage? selectedLanguage;

  RegisterControllersManager({VoidCallback? onFormChanged})
      : super(onFormChanged) {
    if (onFormChanged != null) {
      emailController.addListener(onFormChanged);
      passwordController.addListener(onFormChanged);
      confirmPasswordController.addListener(onFormChanged);
      usernameController.addListener(onFormChanged);
      phoneController.addListener(onFormChanged);
      referralCodeController.addListener(onFormChanged);
    }
  }

  // Getters
  String get email => emailController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;
  String get userName => usernameController.text.trim();
  String get phone => phoneController.text.trim();
  String? get referralCode => referralCodeController.text.trim().isEmpty
      ? null
      : referralCodeController.text.trim();
  String? get state => selectedState?.code;
  String? get profileType => selectedProfileType?.apiValue;
  String? get language => selectedLanguage?.apiValue;

  bool get passwordsMatch => password == confirmPassword;

  bool get canAttemptRegister =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      userName.isNotEmpty &&
      phone.isNotEmpty &&
      selectedState != null &&
      selectedProfileType != null &&
      selectedLanguage != null &&
      passwordsMatch;

  void updateState(UsState? value) {
    selectedState = value;
    onFormChanged?.call();
  }

  void updateProfileType(ProfileType? value) {
    selectedProfileType = value;
    onFormChanged?.call();
  }

  void updateLanguage(AppLanguage? value) {
    selectedLanguage = value;
    onFormChanged?.call();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    referralCodeController.dispose();
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
