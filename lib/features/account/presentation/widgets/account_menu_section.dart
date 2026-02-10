import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_defender/common/res/l10n.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
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
          MenuItemTile(
            icon: Icons.tune_outlined,
            title: AppLocalizations.getString(context, 'profile.preferences'),
            subtitle:
                AppLocalizations.getString(context, 'profile.preferences'),
            trailing: _buildLanguageSelector(context),
            onTap: null,
          ),
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
            subtitle:
                AppLocalizations.getString(context, 'settings.notifications'),
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
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return DropdownButton<Locale>(
      value: currentLocale,
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              Text( '🇺🇸', style: const TextStyle(fontSize: 16)),
              Text(
                AppLocalizations.getString(context, 'language.english'),
              ),
            ],
          ),
        ),
        
        DropdownMenuItem(
          value: const Locale('es'),
          child: Row(
            children: [
              Text( '🇪🇸', style: const TextStyle(fontSize: 16)),
              Text(
                AppLocalizations.getString(context, 'language.spanish'),
              ),
            ],
          ),
        ),
      ],
      onChanged: state.status == AccountStatus.updating
          ? null
          : (locale) {
              if (locale != null) {
                // Your original logic - sends ChangeLanguageEvent to AccountBloc
                context.read<AccountBloc>().add(
                      ChangeLanguageEvent(langCode: locale.languageCode),
                    );
              }
            },
    );
  }


}
