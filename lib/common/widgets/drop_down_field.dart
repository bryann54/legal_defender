import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/common/res/colors.dart';

class DropDownWidget<T> extends StatelessWidget {
  final String label;
  final T? selectedItem;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? hintText;
  final String? errorText;
  final bool isRequired;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  final String? Function(T?)? validator;
  final Color? borderColor;
  final Color? filledColor;
  final double? borderRadius;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showLabel;
  final bool showErrorBorder;
  final bool showBorder;
  final bool filled;
  final bool isDense;
  final double? contentPadding;
  final String? Function(T?)? onValidationError;
  final AutovalidateMode? autovalidateMode;

  const DropDownWidget({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.hintText,
    this.errorText,
    this.isRequired = false,
    this.isEnabled = true,
    this.padding,
    this.validator,
    this.borderColor,
    this.filledColor,
    this.borderRadius,
    this.labelStyle,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.showLabel = true,
    this.showErrorBorder = true,
    this.showBorder = true,
    this.filled = false,
    this.isDense = false,
    this.contentPadding,
    this.onValidationError,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: labelStyle ??
                          theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    if (isRequired)
                      TextSpan(
                        text: ' *',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          DropdownButtonFormField<T>(
            value: selectedItem,
            isExpanded: true,
            isDense: isDense,
            icon: suffixIcon ??
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 24,
                ),
            decoration: InputDecoration(
              hintText: hintText ??
                  AppLocalizations.getString(context, 'common.select'),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              errorText: errorText,
              errorStyle: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                height: 1.2,
              ),
              filled: filled,
              fillColor: filledColor ?? theme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 12 : 16,
                vertical: contentPadding ?? (isDense ? 12 : 16),
              ),
              prefixIcon: prefixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 24,
              ),
              border: _buildBorder(theme, colors, false),
              enabledBorder: _buildBorder(theme, colors, false),
              focusedBorder: _buildBorder(theme, colors, true),
              errorBorder: showErrorBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 1.5,
                      ),
                    )
                  : null,
              focusedErrorBorder: showErrorBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 1.5,
                      ),
                    )
                  : null,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide(
                  color: theme.disabledColor,
                  width: 1,
                ),
              ),
            ),
            style: textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
            dropdownColor: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            menuMaxHeight: 300,
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.value?.toString() ?? '',
                    style: textStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
            items: items,
            validator: validator,
            autovalidateMode: autovalidateMode,
            onChanged: isEnabled ? onChanged : null,
            onSaved: isEnabled ? onChanged : null,
          ),
        ],
      ),
    );
  }

  InputBorder? _buildBorder(ThemeData theme, AppColors colors, bool isFocused) {
    if (!showBorder) return InputBorder.none;

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      borderSide: BorderSide(
        color: isFocused
            ? theme.colorScheme.primary
            : borderColor ?? theme.dividerColor,
        width: isFocused ? 1.5 : 1,
      ),
    );
  }

  // Helper method for creating dropdown items from a list of objects
  static List<DropdownMenuItem<T>> fromList<T>({
    required List<T> items,
    required String Function(T) labelBuilder,
    T? selectedValue,
    Widget Function(T)? iconBuilder,
    bool showIcons = false,
  }) {
    return items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Row(
          children: [
            if (showIcons && iconBuilder != null) ...[
              iconBuilder(item),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                labelBuilder(item),
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // Helper method for creating language dropdown items
  static List<DropdownMenuItem<Locale>> languageItems(BuildContext context) {
    return [
      DropdownMenuItem<Locale>(
        value: const Locale('en'),
        child: Text(
          AppLocalizations.getString(context, 'language.english'),
          style: const TextStyle(fontSize: 14),
        ),
      ),
      DropdownMenuItem<Locale>(
        value: const Locale('es'),
        child: Text(
          AppLocalizations.getString(context, 'language.spanish'),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ];
  }
}
