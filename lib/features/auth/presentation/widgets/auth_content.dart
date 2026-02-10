// lib/features/auth/presentation/widgets/auth_content.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/notifiers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:legal_defender/features/auth/presentation/widgets/getstarted_button.dart';
import 'package:legal_defender/features/auth/presentation/widgets/onBoarding_data.dart';
import 'package:legal_defender/features/auth/presentation/widgets/terms_privacy_text.dart';
import 'package:legal_defender/features/auth/data/models/onboarding_page_model.dart';

class AuthContent extends StatefulWidget {
  const AuthContent({super.key});

  @override
  State<AuthContent> createState() => _AuthContentState();
}

class _AuthContentState extends State<AuthContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  bool _showGetStarted = false;

  static const Duration _autoPlayDuration = Duration(seconds: 4);
  static const Duration _animationDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(_autoPlayDuration, (timer) {
      if (_currentPage < OnboardingData.pages.length - 1) {
        _pageController.nextPage(
            duration: _animationDuration, curve: Curves.easeInOut);
      } else {
        timer.cancel();
        setState(() => _showGetStarted = true);
      }
    });
  }

  void _stopAutoPlay() => _autoPlayTimer?.cancel();

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      if (page == OnboardingData.pages.length - 1) {
        _showGetStarted = true;
        _stopAutoPlay();
      }
    });
  }

  void _skipToEnd() {
    _stopAutoPlay();
    setState(() {
      _showGetStarted = true;
      _currentPage = OnboardingData.pages.length - 1;
    });
    _pageController.animateToPage(
      OnboardingData.pages.length - 1,
      duration: _animationDuration,
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currentPage < OnboardingData.pages.length - 1) {
      _pageController.nextPage(
          duration: _animationDuration, curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<LocaleProvider>(context);

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: OnboardingData.pages.length,
          itemBuilder: (context, index) {
            return _OnboardingPage(
              pageData: OnboardingData.pages[index],
              isDark: isDark,
            );
          },
        ),

        // TOP NAV: Language Selector & Skip
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color:
                      isDark
                      ? Colors.white10
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: provider.locale,
                    icon: Icon(Icons.language,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black54),
                    dropdownColor:
                        isDark ? const Color(0xFF1a1a2e) : Colors.white,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    items: [
                      DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(AppLocalizations.getString(
                              context, 'language.english'))),
                      DropdownMenuItem(
                          value: const Locale('es'),
                          child: Text(AppLocalizations.getString(
                              context, 'language.spanish'))),
                    ],
                    onChanged: (locale) =>
                        locale != null ? provider.setLocale(locale) : null,
                  ),
                ),
              ),
              if (!_showGetStarted)
                TextButton(
                  onPressed: _skipToEnd,
                  child: Text(
                    AppLocalizations.getString(context, 'common.skip'),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),

        // BOTTOM ACTIONS
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPageIndicators(isDark),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showGetStarted
                      ? Column(
                          key: const ValueKey('get_started'),
                          children: [
                            GetstartedButton(
                              text: AppLocalizations.getString(
                                  context, 'onboarding.getStarted'),
                            ),
                            const SizedBox(height: 24),
                            const TermsPrivacyText()
                                .animate()
                                .fadeIn()
                                .slideY(begin: 0.2, end: 0),
                          ],
                        )
                      : GetstartedButton(
                          key: const ValueKey('next'),
                          text: AppLocalizations.getString(
                              context, 'common.next'),
                          showIcon: true,
                          onPressed: _nextPage,
                        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        OnboardingData.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.white30 : Colors.black26),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageModel pageData;
  final bool isDark;

  const _OnboardingPage({required this.pageData, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text(pageData.iconData, style: const TextStyle(fontSize: 80)),
            const Spacer(flex: 1),
            Text(
              // THIS TRANSLATES THE KEYS FROM ONBOARDINGDATA
              AppLocalizations.getString(context, pageData.title),
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1a1a2e)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              // THIS TRANSLATES THE KEYS FROM ONBOARDINGDATA
              AppLocalizations.getString(context, pageData.subtitle),
              style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : const Color(0xFF64748b),
                  height: 1.6),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
