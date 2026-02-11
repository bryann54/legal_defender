// lib/features/auth/presentation/widgets/language_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/widgets/drop_down_field.dart';
import 'package:legal_defender/common/notifiers/locale_provider.dart';

enum AppLanguage {
  en('English', Locale('en')),
  es('Español', Locale('es'));

  final String displayName;
  final Locale locale;

  const AppLanguage(this.displayName, this.locale);

  String get apiValue => name;

  // Helper to get enum from Locale
  static AppLanguage fromLocale(Locale locale) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.locale.languageCode == locale.languageCode,
      orElse: () => AppLanguage.en,
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  final AppLanguage? selectedLanguage;
  final ValueChanged<AppLanguage?> onChanged;
  final bool isEnabled;
  final String? errorText;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
    this.isEnabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final items = AppLanguage.values.map((lang) {
      return DropdownMenuItem<AppLanguage>(
        value: lang,
        child: Text(lang.displayName),
      );
    }).toList();

    return DropDownWidget<AppLanguage>(
      label: AppLocalizations.getString(context, 'auth.language'),
      selectedItem: selectedLanguage,
      items: items,
      onChanged: isEnabled
          ? (language) {
              if (language != null) {
                // 1. Update the Global App Language
                context.read<LocaleProvider>().setLocale(language.locale);
                // 2. Pass the value back to the Register Manager
                onChanged(language);
              }
            }
          : null,
      errorText: errorText,
      isRequired: true,
      prefixIcon: const Icon(Icons.language),
      validator: (value) {
        if (value == null) {
          return AppLocalizations.getString(context, 'validation.required');
        }
        return null;
      },
    );
  }
}
