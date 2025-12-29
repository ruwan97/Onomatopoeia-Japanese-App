import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

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

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(label);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTextStyles.buttonSmall.copyWith(
            color: isSelected ? Colors.white : color,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        backgroundColor: Color.alphaBlend(color.withAlpha(26), Colors.transparent), // 10% opacity: 255 * 0.1 = 25.5 ≈ 26
        selectedColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: color.withAlpha(77), // 30% opacity: 255 * 0.3 = 76.5 ≈ 77
          width: 1,
        ),
      ),
    );
  }
}