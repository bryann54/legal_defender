// lib/common/widgets/custom_app_bar.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';
import 'package:legal_defender/common/res/colors.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/account/presentation/bloc/account_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final displayName = _getDisplayName(context, accountState);
        final userState = accountState.profile?.state;

        return SliverAppBar(
          expandedHeight: isHome ? expandedHeight : kToolbarHeight,
          floating: false,
          pinned: true,
          elevation: 0,
          centerTitle: !isHome,
          leading:
              !isHome ? const AutoLeadingButton(color: Colors.white) : null,
          backgroundColor: isDark
              ? AppColors.primaryColor.withOpacity(0.95)
              : AppColors.primaryColor,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final collapseProgress = _calculateCollapseProgress(
                constraints.biggest.height,
                statusBarHeight,
              );

              return FlexibleSpaceBar(
                centerTitle: !isHome,
                titlePadding: EdgeInsets.only(
                  left: isHome ? 16 : 0,
                  bottom: 16,
                ),
                title: CollapsedTitle(
                  isHome: isHome,
                  displayName: displayName,
                  collapseProgress: collapseProgress,
                ),
                background: AppBarBackground(
                  isDark: isDark,
                  collapseProgress: collapseProgress,
                  isHome: isHome,
                  displayName: displayName,
                  userState: userState,
                ),
              );
            },
          ),
          actions: [
            if (actions != null) ...actions!,
            if (showNotification) const NotificationButton(),
          ],
        );
      },
    );
  }

  String _getDisplayName(BuildContext context, AccountState accountState) {
    if (isHome && accountState.profile != null) {
      return accountState.profile!.username;
    }
    return title ?? AppLocalizations.getString(context, 'dashboard.guest');
  }

  double _calculateCollapseProgress(
      double currentHeight, double statusBarHeight) {
    final collapsedHeight = statusBarHeight + kToolbarHeight;
    final fullHeight =
        (isHome ? expandedHeight : kToolbarHeight) + statusBarHeight;
    return ((fullHeight - currentHeight) / (fullHeight - collapsedHeight))
        .clamp(0.0, 1.0);
  }
}

class CollapsedTitle extends StatelessWidget {
  final bool isHome;
  final String displayName;
  final double collapseProgress;

  const CollapsedTitle({
    super.key,
    required this.isHome,
    required this.displayName,
    required this.collapseProgress,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowTitle = !isHome || collapseProgress > 0.5;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: shouldShowTitle ? 1.0 : 0.0,
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
    );
  }
}

class AppBarBackground extends StatelessWidget {
  final bool isDark;
  final double collapseProgress;
  final bool isHome;
  final String displayName;
  final String? userState;

  const AppBarBackground({
    super.key,
    required this.isDark,
    required this.collapseProgress,
    required this.isHome,
    required this.displayName,
    this.userState,
  });

  @override
  Widget build(BuildContext context) {
    if (!isHome) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primaryColor.withOpacity(0.9),
                  AppColors.primaryColor.withOpacity(0.7),
                ]
              : [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.85),
                ],
        ),
      ),
      child: ExpandedContent(
        collapseProgress: collapseProgress,
        displayName: displayName,
        userState: userState,
      ),
    );
  }
}

class ExpandedContent extends StatelessWidget {
  final double collapseProgress;
  final String displayName;
  final String? userState;

  const ExpandedContent({
    super.key,
    required this.collapseProgress,
    required this.displayName,
    this.userState,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = (1.0 - collapseProgress).clamp(0.0, 1.0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Opacity(
          opacity: opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              GreetingText(displayName: displayName),
              const SizedBox(height: 12),
              LocationIndicator(stateName: userState),
            ],
          ),
        ),
      ),
    );
  }
}

class GreetingText extends StatelessWidget {
  final String displayName;

  const GreetingText({
    super.key,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          AppLocalizations.getString(context, 'dashboard.hi'),
          style: GoogleFonts.acme(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            displayName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class LocationIndicator extends StatelessWidget {
  final String? stateName;

  const LocationIndicator({
    super.key,
    this.stateName,
  });

  @override
  Widget build(BuildContext context) {
    final displayState = stateName ?? 'Your State';

    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Text(
          displayState,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

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
