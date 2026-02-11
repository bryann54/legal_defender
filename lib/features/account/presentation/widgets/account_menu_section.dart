import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/res/colors.dart';
import 'package:legal_defender/common/widgets/drop_down_field.dart';
import 'package:legal_defender/features/account/presentation/bloc/account_bloc.dart';
import 'package:legal_defender/features/account/presentation/widgets/menu_item_tile.dart';

class AccountMenuSection extends StatelessWidget {
  final AccountState state;
  final Locale currentLocale;

  const AccountMenuSection({
    super.key,
    required this.state,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          MenuItemTile(
            icon: Icons.person_outline,
            title: AppLocalizations.getString(context, 'profile.editProfile'),
            subtitle:
                AppLocalizations.getString(context, 'profile.accountDetails'),
            onTap: () {
              // Navigate to profile information screen
            },
          ),
          _buildDivider(context),
          _buildLanguageSelector(context),
          _buildDivider(context),
          MenuItemTile(
            icon: Icons.payment_outlined,
            title:
                AppLocalizations.getString(context, 'profile.paymentHistory'),
            subtitle:
                AppLocalizations.getString(context, 'profile.viewPastOrders'),
            onTap: () {
              // Navigate to payment methods
            },
          ),
          _buildDivider(context),
          MenuItemTile(
            icon: Icons.card_giftcard_outlined,
            title: AppLocalizations.getString(context, 'profile.contactUs'),
            subtitle: AppLocalizations.getString(context, 'profile.contactUs'),
            onTap: () {
              // Navigate to coupons
            },
          ),
          _buildDivider(context),
          MenuItemTile(
            icon: Icons.notifications_outlined,
            title:
                AppLocalizations.getString(context, 'settings.notifications'),
            subtitle: AppLocalizations.getString(
                context, 'settings.alertPreferences'),
            onTap: () {
              // Navigate to notifications settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 60,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryColorDark : AppColors.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.language,
              size: 20,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.getString(context, 'settings.language'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.getString(
                      context, 'settings.changeLanguage'),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: DropDownWidget<Locale>(
              label: '',
              selectedItem: currentLocale,
              items: DropDownWidget.languageItems(context),
              onChanged: state.status == AccountStatus.updating
                  ? null
                  : (locale) {
                      if (locale != null) {
                        context.read<AccountBloc>().add(
                              ChangeLanguageEvent(
                                  langCode: locale.languageCode),
                            );
                      }
                    },
              hintText: AppLocalizations.getString(
                  context, 'language.selectLanguage'),
              isEnabled: state.status != AccountStatus.updating,
              showLabel: false,
              filled: false,
              isDense: true,
              borderRadius: 8,
              borderColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
