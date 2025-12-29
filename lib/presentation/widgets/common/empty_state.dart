import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? lottieAsset;
  final IconData? icon;
  final Widget? action;
  final double iconSize;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.lottieAsset,
    this.icon,
    this.action,
    this.iconSize = 80,
    this.iconColor,
  });

  factory EmptyState.search() {
    return const EmptyState(
      title: 'No Results Found',
      message: 'Try a different search term or category',
      icon: Icons.search_off,
    );
  }

  factory EmptyState.favorites() {
    return const EmptyState(
      title: 'No Favorites Yet',
      message: 'Tap the heart icon to add words to your favorites',
      icon: Icons.favorite_border,
    );
  }

  factory EmptyState.history() {
    return const EmptyState(
      title: 'No History',
      message: 'Words you view will appear here',
      icon: Icons.history,
    );
  }

  factory EmptyState.networkError() {
    return const EmptyState(
      title: 'Connection Error',
      message: 'Check your internet connection and try again',
      icon: Icons.wifi_off,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null)
              Lottie.asset(
                lottieAsset!,
                width: iconSize * 1.5,
                height: iconSize * 1.5,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? Theme.of(context).colorScheme.onSurface.withAlpha(77), // 30% opacity: 255 * 0.3 = 77
              ),

            const SizedBox(height: 24),

            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(179), // 70% opacity: 255 * 0.7 = 179
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(128), // 50% opacity: 255 * 0.5 = 128
              ),
              textAlign: TextAlign.center,
            ),

            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}