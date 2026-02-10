// lib/features/account/presentation/screens/account_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/common/notifiers/locale_provider.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/account/presentation/bloc/account_bloc.dart';
import 'package:legal_defender/features/account/presentation/widgets/profile_info_card.dart';
import 'package:legal_defender/features/account/presentation/widgets/profile_menu_item.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when screen opens
    context.read<AccountBloc>().add(const FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          // Handle language changes
          if (state.currentLang != localeProvider.locale.languageCode) {
            localeProvider.setLocale(Locale(state.currentLang));
          }

          // Handle success messages
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            // Clear message after showing
            context.read<AccountBloc>().add(const ClearErrorEvent());
          }

          // Handle error messages
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<AccountBloc>().add(const FetchProfileEvent());
                  },
                ),
                duration: const Duration(seconds: 4),
              ),
            );
            // Clear error after showing
            context.read<AccountBloc>().add(const ClearErrorEvent());
          }

          // Handle account deletion
          if (state.status == AccountStatus.deleted) {
            // Sign out user
            context.read<AuthBloc>().add(const SignOutEvent());
            // Navigate to login
            // context.router.replaceAll([const LoginRoute()]);
          }
        },
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            // Loading state (initial load)
            if (state.status == AccountStatus.loading &&
                state.profile == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            // Error state (initial load failed)
            if (state.status == AccountStatus.error && state.profile == null) {
              return _buildErrorView(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AccountBloc>().add(const FetchProfileEvent());
                // Wait for loading to finish
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // App Bar
                  _buildAppBar(context, theme),

                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Profile Header Card
                        if (state.profile != null)
                          ProfileInfoCard(profile: state.profile!),

                        const SizedBox(height: 24),

                        // Account Settings Section
                        _buildSectionTitle(
                          context,
                          AppLocalizations.getString(context, 'settings.title'),
                        ),
                        const SizedBox(height: 12),
                        _buildSettingsCard(
                            context, state, localeProvider.locale),

                        const SizedBox(height: 24),

                        // Actions Section
                        _buildSectionTitle(
                          context,
                          'Actions',
                        ),
                        const SizedBox(height: 12),
                        _buildActionsCard(context),

                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: theme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppLocalizations.getString(context, 'profile.title'),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load profile',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AccountBloc>().add(const FetchProfileEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    AccountState state,
    Locale currentLocale,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Language Setting
          ProfileMenuItem(
            icon: Icons.language,
            title: AppLocalizations.getString(context, 'settings.language'),
            trailing: DropdownButton<Locale>(
              value: currentLocale,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(12),
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(
                    AppLocalizations.getString(context, 'language.english'),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('es'),
                  child: Text(
                    AppLocalizations.getString(context, 'language.spanish'),
                  ),
                ),
              ],
              onChanged: state.status == AccountStatus.updating
                  ? null
                  : (locale) {
                      if (locale != null) {
                        context.read<AccountBloc>().add(
                              ChangeLanguageEvent(
                                langCode: locale.languageCode,
                              ),
                            );
                      }
                    },
            ),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // Edit Profile
          ProfileMenuItem(
            icon: Icons.edit_outlined,
            title: AppLocalizations.getString(context, 'profile.editProfile'),
            onTap: () {
              // Navigate to edit profile screen
              // context.router.push(const EditProfileRoute());
            },
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // Notifications
          ProfileMenuItem(
            icon: Icons.notifications_outlined,
            title:
                AppLocalizations.getString(context, 'settings.notifications'),
            onTap: () {
              // Navigate to notifications settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Change Password
          ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // Show password change dialog
              // showPasswordChangeDialog(context);
            },
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // Delete Account
          ProfileMenuItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () => _showDeleteAccountDialog(context),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // Logout
          ProfileMenuItem(
            icon: Icons.logout,
            title: AppLocalizations.getString(context, 'settings.logOut'),
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const SignOutEvent());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is permanent and cannot be undone. '
          'All your data will be permanently deleted.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AccountBloc>().add(const DeleteAccountEvent());
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
