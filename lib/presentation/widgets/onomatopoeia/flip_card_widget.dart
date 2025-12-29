import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';

class FlipCardWidget extends StatelessWidget {
  final String frontText;
  final String backText;
  final String category;
  final Color frontColor;
  final Color backColor;
  final bool showCategory;
  final bool isFlipped;

  const FlipCardWidget({
    super.key,
    required this.frontText,
    required this.backText,
    this.category = '',
    this.frontColor = AppColors.primary,
    this.backColor = Colors.white,
    this.showCategory = true,
    this.isFlipped = false,
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
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      front: _buildCardSide(
        context,
        frontText,
        frontColor,
        'Tap to flip',
        Icons.auto_awesome,
        isFront: true,
      ),
      back: _buildCardSide(
        context,
        backText,
        backColor,
        'Tap to flip back',
        Icons.refresh,
        isFront: false,
      ),
      onFlipDone: (flipped) {
        // You can add callback logic here if needed
      },
    );
  }

  Widget _buildCardSide(
      BuildContext context,
      String text,
      Color backgroundColor,
      String hint,
      IconData hintIcon, {
        required bool isFront,
      }) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getColorWithOpacity(backgroundColor, 0.8),
            _getColorWithOpacity(backgroundColor, 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getColorWithOpacity(Colors.black, 0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Category Badge
          if (showCategory && category.isNotEmpty && isFront)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getColorWithOpacity(Colors.white, 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Hint
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [
                Icon(
                  hintIcon,
                  size: 16,
                  color: _getColorWithOpacity(Colors.white, 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  hint,
                  style: AppTextStyles.caption.copyWith(
                    color: _getColorWithOpacity(Colors.white, 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearningFlipCard extends StatefulWidget {
  final String japanese;
  final String romaji;
  final String meaning;
  final String example;
  final String category;
  final VoidCallback? onFlip;
  final VoidCallback? onCorrect;
  final VoidCallback? onIncorrect;

  const LearningFlipCard({
    super.key,
    required this.japanese,
    required this.romaji,
    required this.meaning,
    required this.example,
    required this.category,
    this.onFlip,
    this.onCorrect,
    this.onIncorrect,
  });

  @override
  State<LearningFlipCard> createState() => _LearningFlipCardState();
}

class _LearningFlipCardState extends State<LearningFlipCard> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool _isFlipped = false;

  // Helper method to get color with opacity
  Color _getColorWithOpacity(Color color, double opacity) {
    return Color.fromARGB(
      ((color.a * 255.0) * opacity).round().clamp(0, 255),
      (color.r * 255.0).round().clamp(0, 255),
      (color.g * 255.0).round().clamp(0, 255),
      (color.b * 255.0).round().clamp(0, 255),
    );
  }

  void _flipCard() {
    if (_cardKey.currentState != null) {
      _cardKey.currentState!.toggleCard();
      setState(() => _isFlipped = !_isFlipped);
      widget.onFlip?.call();
    }
  }

  void _handleCorrect() {
    _flipCard();
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onCorrect?.call();
    });
  }

  void _handleIncorrect() {
    widget.onIncorrect?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flip Card
        GestureDetector(
          onTap: _flipCard,
          child: FlipCard(
            key: _cardKey,
            fill: Fill.fillBack,
            direction: FlipDirection.HORIZONTAL,
            front: _buildFrontCard(),
            back: _buildBackCard(),
            onFlipDone: (flipped) {
              setState(() => _isFlipped = flipped);
            },
          ),
        ),

        const SizedBox(height: 24),

        // Practice Buttons
        if (_isFlipped)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _handleCorrect,
                icon: const Icon(Icons.check),
                label: const Text('I knew it'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _handleIncorrect,
                icon: const Icon(Icons.close),
                label: const Text('Need practice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getColorWithOpacity(AppColors.primary, 0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.japanese,
              textAlign: TextAlign.center,
              style: AppTextStyles.japaneseLarge.copyWith(
                fontSize: 42,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.romaji,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: _getColorWithOpacity(Colors.white, 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getColorWithOpacity(Colors.black, 0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _getColorWithOpacity(_getCategoryColor(widget.category), 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.category,
                style: AppTextStyles.buttonSmall.copyWith(
                  color: _getCategoryColor(widget.category),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Meaning
            Text(
              widget.meaning,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Example
            Text(
              widget.example,
              style: AppTextStyles.bodyMedium.copyWith(
                color: _getColorWithOpacity(onSurfaceColor, 0.7),
              ),
            ),
          ],
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
}