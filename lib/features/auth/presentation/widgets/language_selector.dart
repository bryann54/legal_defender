// lib/features/auth/presentation/widgets/language_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/account/presentation/bloc/account_bloc.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        // Get current locale from context
        final currentLocale = Localizations.localeOf(context);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                size: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              const SizedBox(width: 6),
              DropdownButton<Locale>(
                value: currentLocale,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                isDense: true,
                borderRadius: BorderRadius.circular(12),
                dropdownColor: isDark ? const Color(0xFF2a2a3e) : Colors.white,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: _LanguageItem(
                      label: AppLocalizations.getString(context, 'english'),
                      flag: '🇺🇸',
                      isDark: isDark,
                    ),
                  ),
                  DropdownMenuItem(
                    value: const Locale('fr'),
                    child: _LanguageItem(
                      label: AppLocalizations.getString(context, 'french'),
                      flag: '🇫🇷',
                      isDark: isDark,
                    ),
                  ),
                  DropdownMenuItem(
                    value: const Locale('es'),
                    child: _LanguageItem(
                      label: AppLocalizations.getString(context, 'spanish'),
                      flag: '🇪🇸',
                      isDark: isDark,
                    ),
                  ),
                ],
                onChanged: state is AccountLoadingState
                    ? null
                    : (locale) {
                        if (locale != null &&
                            locale.languageCode != currentLocale.languageCode) {
                          context.read<AccountBloc>().add(
                                ChangeLanguageEvent(
                                  langCode: locale.languageCode,
                                ),
                              );
                        }
                      },
                selectedItemBuilder: (context) => [
                  _buildSelectedItem(
                      'EN', isDark, state is AccountLoadingState),
                  _buildSelectedItem(
                      'FR', isDark, state is AccountLoadingState),
                  _buildSelectedItem(
                      'ES', isDark, state is AccountLoadingState),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedItem(String code, bool isDark, bool isLoading) {
    return Center(
      child: isLoading
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            )
          : Text(
              code,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String label;
  final String flag;
  final bool isDark;

  const _LanguageItem({
    required this.label,
    required this.flag,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(flag, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
