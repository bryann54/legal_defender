// lib/common/widgets/skip_button.dart

import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/l10n.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  final bool showIcon;
  final Widget? icon;

  final bool enabled;
  final SkipButtonStyle? style;

  const SkipButton({
    super.key,
    required this.onPressed,
    this.text,
    this.showIcon = false,
    this.icon,
    this.enabled = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveStyle = style ?? SkipButtonStyle.standard();

    return Semantics(
      button: true,
      enabled: enabled,
      label: text ?? AppLocalizations.getString(context, 'common.skip'),
      child: AnimatedContainer(
        duration: effectiveStyle.animationDuration,
        curve: Curves.easeInOut,
        padding: effectiveStyle.padding,
        decoration: BoxDecoration(
          color: _getBackgroundColor(effectiveStyle, isDark, enabled),
          borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
          border: Border.all(
            color: _getBorderColor(effectiveStyle, isDark, enabled),
            width: effectiveStyle.borderWidth,
          ),
          boxShadow: enabled ? _getBoxShadow(effectiveStyle, isDark) : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
            splashColor: effectiveStyle.splashColor?.withOpacity(0.2) ??
                (isDark ? Colors.white12 : Colors.black12),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: effectiveStyle.contentPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text ?? AppLocalizations.getString(context, 'common.skip'),
                    style: _getTextStyle(effectiveStyle, isDark, enabled),
                  ),
                  if (showIcon) ...[
                    SizedBox(width: effectiveStyle.iconSpacing),
                    _buildIcon(effectiveStyle, isDark, enabled),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(SkipButtonStyle style, bool isDark, bool enabled) {
    if (icon != null) return icon!;
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: style.iconSize,
      color: _getIconColor(style, isDark, enabled),
    );
  }

  Color _getBackgroundColor(SkipButtonStyle style, bool isDark, bool enabled) {
    if (!enabled) {
      return style.disabledBackgroundColor ??
          (isDark ? Colors.white10 : Colors.black.withOpacity(0.05));
    }
    return style.backgroundColor ??
        (isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05));
  }

  Color _getBorderColor(SkipButtonStyle style, bool isDark, bool enabled) {
    if (!enabled) {
      return style.disabledBorderColor ??
          (isDark ? Colors.white12 : Colors.black12);
    }
    return style.borderColor ??
        (isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.1));
  }

  Color _getIconColor(SkipButtonStyle style, bool isDark, bool enabled) {
    if (!enabled) {
      return style.disabledIconColor ??
          (isDark ? Colors.white38 : Colors.black38);
    }
    return style.iconColor ?? (isDark ? Colors.white70 : Colors.black54);
  }

  TextStyle _getTextStyle(SkipButtonStyle style, bool isDark, bool enabled) {
    final baseStyle = style.textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : Colors.black54,
        );
    if (!enabled) {
      return baseStyle.copyWith(
        color: (style.disabledTextColor ??
                (isDark ? Colors.white38 : Colors.black38))
            .withOpacity(0.6),
      );
    }
    return baseStyle;
  }

  List<BoxShadow>? _getBoxShadow(SkipButtonStyle style, bool isDark) {
    if (style.boxShadow != null) return style.boxShadow;
    if (isDark) return null;
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }
}

class SkipButtonStyle {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final double borderWidth;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? iconColor;
  final Color? disabledIconColor;
  final TextStyle? textStyle;
  final double iconSize;
  final double iconSpacing;
  final List<BoxShadow>? boxShadow;
  final Color? splashColor;
  final Duration animationDuration;

  const SkipButtonStyle({
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.contentPadding = EdgeInsets.zero,
    this.borderRadius = 5,
    this.borderWidth = 1,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.disabledBorderColor,
    this.textColor,
    this.disabledTextColor,
    this.iconColor,
    this.disabledIconColor,
    this.textStyle,
    this.iconSize = 12,
    this.iconSpacing = 4,
    this.boxShadow,
    this.splashColor,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  factory SkipButtonStyle.standard() => const SkipButtonStyle();

  factory SkipButtonStyle.textButton() => SkipButtonStyle(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        boxShadow: null,
        borderRadius: 8,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );

  factory SkipButtonStyle.filled({
    required Color color,
    required Color disabledColor,
  }) =>
      SkipButtonStyle(
        backgroundColor: color,
        disabledBackgroundColor: disabledColor,
        borderColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconColor: Colors.white70,
        disabledIconColor: Colors.white38,
      );

  SkipButtonStyle copyWith({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? contentPadding,
    double? borderRadius,
    double? borderWidth,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    Color? disabledBorderColor,
    Color? textColor,
    Color? disabledTextColor,
    Color? iconColor,
    Color? disabledIconColor,
    TextStyle? textStyle,
    double? iconSize,
    double? iconSpacing,
    List<BoxShadow>? boxShadow,
    Color? splashColor,
    Duration? animationDuration,
  }) {
    return SkipButtonStyle(
      padding: padding ?? this.padding,
      contentPadding: contentPadding ?? this.contentPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      textColor: textColor ?? this.textColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      iconColor: iconColor ?? this.iconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      boxShadow: boxShadow ?? this.boxShadow,
      splashColor: splashColor ?? this.splashColor,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
