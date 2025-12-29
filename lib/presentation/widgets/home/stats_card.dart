import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool showProgress;
  final double progress;
  final String? progressText;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
    this.showProgress = false,
    this.progress = 0.0,
    this.progressText,
  });

  factory StatsCard.wordsLearned(int count, {VoidCallback? onTap}) {
    return StatsCard(
      title: 'Words Learned',
      value: '$count',
      icon: Icons.book,
      color: AppColors.primary,
      onTap: onTap,
    );
  }

  factory StatsCard.favorites(int count, {VoidCallback? onTap}) {
    return StatsCard(
      title: 'Favorites',
      value: '$count',
      icon: Icons.favorite,
      color: Colors.red,
      onTap: onTap,
    );
  }

  factory StatsCard.streak(int days, {VoidCallback? onTap}) {
    return StatsCard(
      title: 'Study Streak',
      value: '$days days',
      icon: Icons.local_fire_department,
      color: Colors.orange,
      onTap: onTap,
    );
  }

  factory StatsCard.mastery(double percentage, {VoidCallback? onTap}) {
    return StatsCard(
      title: 'Mastery',
      value: '${percentage.toStringAsFixed(1)}%',
      icon: Icons.emoji_events,
      color: Colors.green,
      onTap: onTap,
      showProgress: true,
      progress: percentage / 100,
      progressText: '${percentage.toStringAsFixed(1)}%',
    );
  }

  // Helper method to get color with opacity
  Color _getColorWithOpacity(Color color, double opacity) {
    return Color.fromARGB(
      ((color.a * 255.0) * opacity).round().clamp(0, 255),
      (color.r * 255.0).round().clamp(0, 255),
      (color.g * 255.0).round().clamp(0, 255),
      (color.b * 255.0).round().clamp(0, 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getColorWithOpacity(color, 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _getColorWithOpacity(onSurfaceColor, 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Value
              Text(
                value,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              // Progress Bar (if shown)
              if (showProgress) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color,
                                  _getColorWithOpacity(color, 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        },
                      ),
                    ),

                    // Progress Text
                    if (progressText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          progressText!,
                          style: AppTextStyles.caption.copyWith(
                            color: _getColorWithOpacity(onSurfaceColor, 0.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class StatsGrid extends StatelessWidget {
  final int wordsLearned;
  final int favorites;
  final int streakDays;
  final double mastery;

  const StatsGrid({
    super.key,
    required this.wordsLearned,
    required this.favorites,
    required this.streakDays,
    required this.mastery,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatsCard.wordsLearned(wordsLearned),
        StatsCard.favorites(favorites),
        StatsCard.streak(streakDays),
        StatsCard.mastery(mastery),
      ],
    );
  }
}