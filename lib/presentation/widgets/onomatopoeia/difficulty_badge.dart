import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';

class DifficultyBadge extends StatelessWidget {
  final int difficulty;
  final bool showLabel;
  final double size;
  final DifficultyDisplayType displayType;

  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.showLabel = true,
    this.size = 24,
    this.displayType = DifficultyDisplayType.stars,
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
    final clampedDifficulty = difficulty.clamp(1, 5);
    final difficultyColor = _getDifficultyColor(clampedDifficulty);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColorWithOpacity(difficultyColor, 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (displayType == DifficultyDisplayType.stars)
            _buildStars(clampedDifficulty)
          else
            _buildLevel(clampedDifficulty),

          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              _getDifficultyLabel(clampedDifficulty),
              style: AppTextStyles.buttonSmall.copyWith(
                color: difficultyColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStars(int difficulty) {
    final difficultyColor = _getDifficultyColor(difficulty);

    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < difficulty ? Icons.star : Icons.star_border,
          size: size * 0.8,
          color: difficultyColor,
        );
      }),
    );
  }

  Widget _buildLevel(int difficulty) {
    final difficultyColor = _getDifficultyColor(difficulty);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: difficultyColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$difficulty',
        style: AppTextStyles.buttonSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
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

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Easy';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Unknown';
    }
  }
}

enum DifficultyDisplayType {
  stars,
  level,
}

class DifficultyIndicator extends StatelessWidget {
  final int difficulty;
  final double width;
  final double height;

  const DifficultyIndicator({
    super.key,
    required this.difficulty,
    this.width = 100,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clampedDifficulty = difficulty.clamp(1, 5);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * (clampedDifficulty / 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getDifficultyColor(1),
                  _getDifficultyColor(clampedDifficulty),
                ],
              ),
              borderRadius: BorderRadius.circular(height / 2),
            ),
          );
        },
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