// lib/features/auth/presentation/widgets/getstarted_button.dart

import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';
import 'package:legal_defender/common/res/colors.dart';
import 'package:flutter/material.dart';

class GetstartedButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onPressed;
  final bool showIcon;

  const GetstartedButton({
    super.key,
    this.text,
    this.onPressed,
    this.showIcon = false,
  });

  @override
  State<GetstartedButton> createState() => _GetstartedButtonState();
}

class _GetstartedButtonState extends State<GetstartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleTap() async {
    // Start animation
    _controller.forward();

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    // Use custom callback if provided, otherwise navigate to login
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else {
      context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = widget.text ?? 'GET STARTED';

    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: widget.showIcon
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  buttonText.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                              ],
                            )
                          : Text(
                              buttonText.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
