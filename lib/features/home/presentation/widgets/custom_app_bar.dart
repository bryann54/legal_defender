import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';
import 'package:legal_defender/common/res/colors.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:legal_defender/features/auth/presentation/bloc/auth_state.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final bool isHome;
  final bool showNotification;
  final double expandedHeight;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.isHome = false,
    this.showNotification = false,
    this.expandedHeight = 130.0,
  });

  String _getDisplayName(BuildContext context, AuthState state) {
    if (isHome &&
        state.status == AuthStatus.authenticated &&
        state.user != null) {
      return state.user!.username;
    }
    return title ?? AppLocalizations.getString(context, 'dashboard.guest');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    final List<Widget> effectiveActions = [
      if (actions != null) ...actions!,
      if (showNotification) const _NotificationAction(),
    ];

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final displayName = _getDisplayName(context, state);

        return SliverAppBar(
          expandedHeight: isHome ? expandedHeight : kToolbarHeight,
          floating: false,
          pinned: true,
          elevation: 0,
          // Centers the title automatically on sub-screens
          centerTitle: !isHome,
          leading:
              !isHome ? const AutoLeadingButton(color: Colors.white) : null,
          backgroundColor: isDark
              ? AppColors.primaryColor.withOpacity(0.95)
              : AppColors.primaryColor,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final double top = constraints.biggest.height;
              final double collapsedHeight = statusBarHeight + kToolbarHeight;
              final double fullHeight =
                  (isHome ? expandedHeight : kToolbarHeight) + statusBarHeight;

              final double collapseRatio =
                  ((fullHeight - top) / (fullHeight - collapsedHeight))
                      .clamp(0.0, 1.0);

              return FlexibleSpaceBar(
                centerTitle: !isHome,
                titlePadding: EdgeInsets.only(
                  left: isHome ? 16 : 0, // Reset left padding when centered
                  bottom: 16,
                  right: isHome ? 0 : 0,
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: !isHome ? 1.0 : (collapseRatio > 0.5 ? 1.0 : 0.0),
                  child: Text(
                    isHome
                        ? '${AppLocalizations.getString(context, "dashboard.hi")}, $displayName'
                        : displayName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                background: _AppBarBackground(
                  isDark: isDark,
                  collapseRatio: collapseRatio,
                  isHome: isHome,
                  displayName: displayName,
                ),
              );
            },
          ),
          actions: effectiveActions,
        );
      },
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  final bool isDark;
  final double collapseRatio;
  final bool isHome;
  final String displayName;

  const _AppBarBackground({
    required this.isDark,
    required this.collapseRatio,
    required this.isHome,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primaryColor.withOpacity(0.9),
                  AppColors.primaryColor.withOpacity(0.7)
                ]
              : [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.85)
                ],
        ),
      ),
      child: isHome
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Opacity(
                  opacity: (1.0 - collapseRatio).clamp(0.0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Hi,',
                            style: GoogleFonts.acme(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            displayName,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Your State',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _NotificationAction extends StatelessWidget {
  const _NotificationAction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Center(
        child: GestureDetector(
          onTap: () => context.router.push(const NotificationsRoute()),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
