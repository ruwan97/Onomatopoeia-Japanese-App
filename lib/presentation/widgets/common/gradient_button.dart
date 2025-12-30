// In gradient_button.dart
import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final Gradient? disabledGradient; // Add this parameter
  final VoidCallback? onPressed;
  final bool isLoading;
  final double borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? shadow;
  final bool disabled;

  const GradientButton({
    super.key,
    required this.child,
    required this.gradient,
    this.disabledGradient, // Add this parameter
    this.onPressed,
    this.isLoading = false,
    this.borderRadius = 12,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    this.shadow,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonGradient = disabled
        ? (disabledGradient ??
            LinearGradient(
              colors: [
                Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(31), // 12% opacity
                Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(31), // 12% opacity
              ],
            ))
        : gradient;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: buttonGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: disabled
            ? null
            : shadow ??
                [
                  BoxShadow(
                    color: gradient.colors.first.withAlpha(77), // 30% opacity
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
      ),
      child: ElevatedButton(
        onPressed: disabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : DefaultTextStyle(
                style: AppTextStyles.buttonLarge.copyWith(
                  color: disabled
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.38)
                      : Colors.white,
                ),
                child: child,
              ),
      ),
    );
  }
}

class AnimatedGradientButton extends StatefulWidget {
  final Widget child;
  final List<Gradient> gradients;
  final VoidCallback? onPressed;
  final Duration animationDuration;
  final double borderRadius;

  const AnimatedGradientButton({
    super.key,
    required this.child,
    required this.gradients,
    this.onPressed,
    this.animationDuration = const Duration(milliseconds: 500),
    this.borderRadius = 12,
  });

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _gradientIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration * widget.gradients.length,
    )..repeat();

    _gradientIndex = IntTween(
      begin: 0,
      end: widget.gradients.length - 1,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GradientButton(
          onPressed: widget.onPressed,
          gradient: widget.gradients[_gradientIndex.value],
          borderRadius: widget.borderRadius,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
