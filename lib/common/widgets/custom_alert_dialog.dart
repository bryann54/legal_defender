import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/colors.dart';

enum DialogType {
  info,
  success,
  warning,
  error,
  confirm,
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final DialogType type;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showCancelButton;
  final bool showConfirmButton;
  final bool barrierDismissible;
  final bool showCloseButton;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final double? maxWidth;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final Widget? icon;
  final double? borderRadius;

  const CustomAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.actions,
    this.type = DialogType.info,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCancelButton = true,
    this.showConfirmButton = true,
    this.barrierDismissible = true,
    this.showCloseButton = true,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.maxWidth,
    this.contentPadding,
    this.titleStyle,
    this.messageStyle,
    this.icon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
      ),
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 400,
          minWidth: 280,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                  padding: const EdgeInsets.all(12),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            Padding(
              padding: contentPadding ??
                  const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: 24,
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null || type != DialogType.info)
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: _getIconColor(context).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: icon ?? _buildDefaultIcon(context),
                      ),
                    ),
                  Text(
                    title,
                    style: titleStyle ??
                        theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                  ),
                  if (message != null || content != null) ...[
                    const SizedBox(height: 12),
                    if (message != null)
                      Text(
                        message!,
                        style: messageStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                              height: 1.5,
                            ),
                      ),
                    if (content != null) content!,
                  ],
                  const SizedBox(height: 24),
                  if (actions != null)
                    ...actions!
                  else
                    _buildDefaultActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = switch (type) {
      DialogType.success => Icons.check_circle,
      DialogType.error => Icons.error,
      DialogType.warning => Icons.warning,
      DialogType.confirm => Icons.help,
      _ => Icons.info,
    };

    return Icon(
      iconData,
      color: _getIconColor(context),
      size: 24,
    );
  }

  Color _getIconColor(BuildContext context) {
    final theme = Theme.of(context);
    return switch (type) {
      DialogType.success => Colors.green,
      DialogType.error => Colors.red,
      DialogType.warning => Colors.orange,
      DialogType.confirm => theme.colorScheme.primary,
      _ => theme.colorScheme.primary,
    };
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Row(
      children: [
        if (showCancelButton) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: cancelButtonColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              child: Text(
                cancelText ?? 'Cancel',
                style: TextStyle(
                  color: cancelButtonColor ??
                      Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          if (showConfirmButton) const SizedBox(width: 12),
        ],
        if (showConfirmButton)
          Expanded(
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: confirmButtonColor ?? _getIconColor(context),
              ),
              child: Text(
                confirmText ?? 'Confirm',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  // Static method to show the dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    List<Widget>? actions,
    DialogType type = DialogType.info,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    bool barrierDismissible = true,
    bool showCloseButton = true,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    double? maxWidth,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    Widget? icon,
    double? borderRadius,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomAlertDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCancelButton: showCancelButton,
        showConfirmButton: showConfirmButton,
        barrierDismissible: barrierDismissible,
        showCloseButton: showCloseButton,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
        maxWidth: maxWidth,
        contentPadding: contentPadding,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
        icon: icon,
        borderRadius: borderRadius,
      ),
    );
  }
}

// Convenience class for common dialog types
class AppDialogs {
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool destructive = true,
  }) {
    return CustomAlertDialog.show<bool>(
      context: context,
      title: title,
      message: message,
      type: destructive ? DialogType.error : DialogType.confirm,
      confirmText: confirmText,
      cancelText: cancelText,
      showCancelButton: true,
      showConfirmButton: true,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: destructive ? Colors.red : null,
      barrierDismissible: true,
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return CustomAlertDialog.show(
      context: context,
      title: title,
      message: message,
      content: content,
      type: DialogType.info,
      confirmText: buttonText,
      showCancelButton: false,
      showConfirmButton: true,
      onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
      barrierDismissible: false,
    );
  }

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return CustomAlertDialog.show(
      context: context,
      title: title,
      message: message,
      type: DialogType.success,
      confirmText: buttonText,
      showCancelButton: false,
      showConfirmButton: true,
      onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
      barrierDismissible: false,
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return CustomAlertDialog.show(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
      confirmText: buttonText,
      showCancelButton: false,
      showConfirmButton: true,
      onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
      barrierDismissible: false,
    );
  }
}
