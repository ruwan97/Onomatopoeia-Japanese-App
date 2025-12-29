import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/onomatopoeia/audio_player_widget.dart';

class OnomatopoeiaCard extends StatelessWidget {
  final Onomatopoeia onomatopoeia;

  const OnomatopoeiaCard({
    super.key,
    required this.onomatopoeia,
  });

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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Japanese Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          onomatopoeia.japanese,
                          style: AppTextStyles.japaneseLarge.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          onomatopoeia.romaji,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _getColorWithOpacity(primaryColor, 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite Button
                  LikeButton(
                    size: 30,
                    isLiked: onomatopoeia.isFavorite,
                    likeBuilder: (isLiked) {
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : _getColorWithOpacity(onSurfaceColor, 0.6),
                        size: 30,
                      );
                    },
                    onTap: (isLiked) async {
                      Provider.of<OnomatopoeiaProvider>(context, listen: false)
                          .toggleFavorite(onomatopoeia.id);
                      return !isLiked;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Meaning
              Text(
                onomatopoeia.meaning,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              // Example Sentence
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example:',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      onomatopoeia.exampleSentence,
                      style: AppTextStyles.bodyMedium,
                    ),
                    if (onomatopoeia.exampleTranslation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        onomatopoeia.exampleTranslation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _getColorWithOpacity(onSurfaceColor, 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Footer Row
              Row(
                children: [
                  // Audio Player
                  AudioPlayerWidget(soundPath: onomatopoeia.soundPath),

                  const Spacer(),

                  // Category Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getColorWithOpacity(primaryColor, 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      onomatopoeia.category,
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Difficulty Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getColorWithOpacity(
                          _getDifficultyColor(onomatopoeia.difficulty), 0.1
                      ),
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
                          'Lv. ${onomatopoeia.difficulty}',
                          style: AppTextStyles.buttonSmall.copyWith(
                            color: _getDifficultyColor(onomatopoeia.difficulty),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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