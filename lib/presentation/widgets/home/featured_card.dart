import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';

class FeaturedCard extends StatelessWidget {
  final Onomatopoeia onomatopoeia;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool showCategory;

  const FeaturedCard({
    super.key,
    required this.onomatopoeia,
    this.onTap,
    this.onFavoriteTap,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(onomatopoeia.category);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(categoryColor.withAlpha(26), Colors.transparent), // 10% opacity: 255 * 0.1 = 25.5 ≈ 26
                Color.alphaBlend(categoryColor.withAlpha(77), Colors.transparent), // 30% opacity: 255 * 0.3 = 76.5 ≈ 77
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.1,
                  child: Text(
                    onomatopoeia.japanese,
                    style: AppTextStyles.japaneseLarge.copyWith(
                      fontSize: 60,
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    if (showCategory)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          onomatopoeia.category,
                          style: AppTextStyles.buttonSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),

                    if (showCategory) const SizedBox(height: 16),

                    // Japanese Text
                    Text(
                      onomatopoeia.japanese,
                      style: AppTextStyles.japaneseLarge.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Romaji
                    Text(
                      onomatopoeia.romaji,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(179), // 70% opacity: 255 * 0.7 = 178.5 ≈ 179
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meaning
                    Text(
                      onomatopoeia.meaning,
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Example Preview
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Example:',
                            style: AppTextStyles.caption.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            onomatopoeia.exampleSentence,
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Footer
                    Row(
                      children: [
                        // Difficulty
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 14,
                                color: _getDifficultyColor(onomatopoeia.difficulty),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Level ${onomatopoeia.difficulty}',
                                style: AppTextStyles.buttonSmall.copyWith(
                                  color: _getDifficultyColor(onomatopoeia.difficulty),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // View Count
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 60% opacity: 255 * 0.6 = 153
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${onomatopoeia.viewCount}',
                              style: AppTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 60% opacity
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: onFavoriteTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26), // 10% opacity: 255 * 0.1 = 25.5 ≈ 26
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      onomatopoeia.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: onomatopoeia.isFavorite
                          ? Colors.red
                          : Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Animal':
        return AppColors.animalColor;
      case 'Nature':
        return AppColors.natureColor;
      case 'Human':
        return AppColors.humanColor;
      case 'Object':
        return AppColors.objectColor;
      case 'Food':
        return AppColors.foodColor;
      case 'Vehicle':
        return AppColors.vehicleColor;
      case 'Music':
        return AppColors.musicColor;
      case 'Technology':
        return AppColors.technologyColor;
      default:
        return AppColors.primary;
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}