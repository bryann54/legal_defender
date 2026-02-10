import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:legal_defender/common/notifiers/locale_provider.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/res/colors.dart';
import 'package:legal_defender/features/account/presentation/bloc/account_bloc.dart';
import 'package:legal_defender/features/account/domain/entities/user_profile.dart';
import 'package:legal_defender/features/account/presentation/widgets/account_menu_section.dart';
import 'package:legal_defender/features/account/presentation/widgets/support_menu_section.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_event.dart';

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
    context.read<AccountBloc>().add(const FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) =>
            _handleStateChanges(context, state, localeProvider),
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state.status == AccountStatus.loading &&
                state.profile == null) {
              return const _LoadingView();
            }

            if (state.status == AccountStatus.error && state.profile == null) {
              return _ErrorView(
                onRetry: () =>
                    context.read<AccountBloc>().add(const FetchProfileEvent()),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AccountBloc>().add(const FetchProfileEvent());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (state.profile != null)
                    _buildSliverAppBar(context, state.profile!, theme),
                  SliverToBoxAdapter(
                    child: _buildMenuSections(
                        context, state, localeProvider.locale),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuSections(
      BuildContext context, AccountState state, Locale currentLocale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
            context, AppLocalizations.getString(context, 'profile.account')),
        AccountMenuSection(
          state: state,
          currentLocale: currentLocale,
        ),
        const SizedBox(height: 24),
        _buildSectionLabel(
            context, AppLocalizations.getString(context, 'profile.getHelp')),
        const SupportMenuSection(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, UserProfile profile, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            color: Colors.red,
            tooltip: AppLocalizations.getString(context, 'settings.logOut'),
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double appBarHeight = constraints.biggest.height;
          final double expandedHeight = 150;
          final double collapsedHeight =
              kToolbarHeight + MediaQuery.of(context).padding.top;

          // Calculate progress from 0 (expanded) to 1 (collapsed)
          final double progress = ((appBarHeight - expandedHeight) /
                  (collapsedHeight - expandedHeight))
              .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            title: Opacity(
              opacity: progress, // Only show title when collapsing
              child: _buildCollapsedTitle(context, profile, theme),
            ),
            background: _buildExpandedHeader(context, profile, theme),
          );
        },
      ),
    );
  }

  Widget _buildCollapsedTitle(
      BuildContext context, UserProfile profile, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
          child: Text(
            _getInitials(profile.username),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              profile.username,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              profile.email,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedHeader(
      BuildContext context, UserProfile profile, ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            child: Text(
              _getInitials(profile.username),
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.username,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String username) {
    if (username.isEmpty) return '?';
    final parts = username.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return username.substring(0, 1).toUpperCase();
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(AppLocalizations.getString(context, 'settings.logOut')),
          content: Text(
              AppLocalizations.getString(context, 'settings.logoutMessage')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.getString(context, 'common.cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(SignOutEvent());
              },
              child: Text(
                AppLocalizations.getString(context, 'settings.logOut'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleStateChanges(
      BuildContext context, AccountState state, LocaleProvider localeProvider) {
    if (state.currentLang != localeProvider.locale.languageCode) {
      localeProvider.setLocale(Locale(state.currentLang));
    }

    if (state.successMessage != null) {
      _showSuccessMessage(context, state.successMessage!);
      context.read<AccountBloc>().add(const ClearErrorEvent());
    }

    if (state.errorMessage != null) {
      _showErrorMessage(context, state.errorMessage!);
      context.read<AccountBloc>().add(const ClearErrorEvent());
    }

    if (state.status == AccountStatus.deleted) {
      context.read<AuthBloc>().add(const SignOutEvent());
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () =>
              context.read<AccountBloc>().add(const FetchProfileEvent()),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.getString(context, 'common.error'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.getString(context, 'profile.retry')),
          ),
        ],
      ),
    );
  }
}
