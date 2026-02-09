// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors - Teal Based
  static const Color primaryColor = Color(0xFF111827); // Dark Teal
  static const Color secondaryColor = Color(0xFF20B2AA); // Light Sea Green
  static const Color accentColor = Color(0xFF48D1CC); // Medium Turquoise
  static const Color background = Color(0xFFF0F9F9); // Very Light Teal
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB0272F);
  static const Color textPrimary = Color(0xFF004D4D); // Deep Teal
  static const Color textSecondary = Color(0xFF5F7C7C);
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFB2DFDB);
  static const Color shadowColor = Color(0x1A008B8B);
  static const Color cardDark = Color(0xFF2C2C2C); // Dark Card/Input Fill
  static const Color cardLight = Color(0xFFF0F0F0); // Light Card/Input Fill

  // Success and Info Colors
  static const Color success = Color(0xFF00897B); // Teal Success
  static const Color info = Color(0xFF26C6DA); // Cyan Info
  static const Color warning = Color(0xFFFFA726); // Amber Warning

  // Light Theme Gradient for Buttons
  static const LinearGradient lightButtonGradient = LinearGradient(
    colors: [Color(0xFF008B8B), Color(0xFF20B2AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Premium Teal Gradients
  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF00796B), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealAccentGradient = LinearGradient(
    colors: [Color(0xFF48D1CC), Color(0xFF7FDBDA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Consistency for Split Screen Backgrounds
  static const Color visualDarkBackgroundHalf = Color(0xFF1A1A1A);
  static const Color visualLightBackgroundHalf = Colors.white;

  // Dark Theme Colors - Teal Based
  static const Color primaryColorDark = Color(0xFF26A69A); // Light Teal
  static const Color secondaryColorDark = Color(0xFF4DB6AC); // Lighter Teal
  static const Color accentColorDark = Color(0xFF80CBC4); // Very Light Teal
  static const Color backgroundDark = Color(0xFF0D1B1B); // Very Dark Teal
  static const Color surfaceColorDark = Color(0xFF1B2F2F); // Dark Teal Surface
  static const Color errorDark = Color(0xFFEF5350);
  static const Color textPrimaryDark = Color(0xFFE0F2F1); // Light Teal White
  static const Color textSecondaryDark = Color(0xFFB2DFDB); // Light Teal Gray
  static const Color cardColorDark = Color(0xFF1B2F2F);
  static const Color dividerColorDark = Color(0xFF2C4A4A);
  static const Color shadowColorDark = Color(0x3D000000);
  static const Color textLight = Color(0xFF6C7C7C);
  static const Color textLightDark = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Dark Theme Gradient for Buttons
  static const LinearGradient darkButtonGradient = LinearGradient(
    colors: [Color(0xFF00796B), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Teal Shades for Various Use Cases
  static const Color tealExtraLight = Color(0xFFE0F2F1);
  static const Color tealLight = Color(0xFFB2DFDB);
  static const Color tealMedium = Color(0xFF4DB6AC);
  static const Color tealDark = Color(0xFF00796B);
  static const Color tealExtraDark = Color(0xFF004D40);
  // Colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color lightBackgroundColor = Color(0xFFFAFAFA);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color lightCardColor = Colors.white;

  // Spacing
  static const double horizontalPadding = 24.0;
  static const double verticalPadding = 32.0;
  static const double cardPadding = 24.0;
  static const double elementSpacing = 20.0;
  static const double largeElementSpacing = 24.0;

  // Sizes
  static const double cardBorderRadius = 16.0;
  static const double buttonHeight = 50.0;

  // Animations
  static const Duration snackBarDuration = Duration(seconds: 4);
  static const Duration splashDelay = Duration(milliseconds: 500);
}
