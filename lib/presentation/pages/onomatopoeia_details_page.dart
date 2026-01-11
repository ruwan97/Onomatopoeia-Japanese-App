import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';

class OnomatopoeiaDetailsPage extends StatefulWidget {
  final Onomatopoeia onomatopoeia;

  const OnomatopoeiaDetailsPage({super.key, required this.onomatopoeia});

  @override
  State<OnomatopoeiaDetailsPage> createState() =>
      _OnomatopoeiaDetailsPageState();
}

class _OnomatopoeiaDetailsPageState extends State<OnomatopoeiaDetailsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoadingSound = false;

  @override
  void initState() {
    super.initState();
    // Increment view count when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<OnomatopoeiaProvider>(context, listen: false)
            .incrementViewCount(widget.onomatopoeia.id);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      if (mounted) {
        setState(() => _isPlaying = false);
      }
      return;
    }

    if (mounted) {
      setState(() => _isLoadingSound = true);
    }

    try {
      await _audioPlayer.play(AssetSource(widget.onomatopoeia.soundPath));

      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isLoadingSound = false;
        });
      }

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoadingSound = false;
        });
      }

      // Check mounted before showing snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not play audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.onomatopoeia.category);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image or Color Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          categoryColor,
                          categoryColor.withAlpha(204),
                        ],
                      ),
                    ),
                    child: _buildImageSection(context, categoryColor),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withAlpha(204),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Japanese and Romaji
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.onomatopoeia.japanese,
                              style: AppTextStyles.japaneseLarge.copyWith(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.onomatopoeia.romaji,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(153),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Favorite Button
                      Consumer<OnomatopoeiaProvider>(
                        builder: (context, provider, child) {
                          return IconButton(
                            onPressed: () {
                              provider.toggleFavorite(widget.onomatopoeia.id);
                            },
                            icon: Icon(
                              widget.onomatopoeia.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 32,
                              color: widget.onomatopoeia.isFavorite
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Audio Player
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: categoryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Play Button
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: categoryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _playAudio,
                            icon: _isLoadingSound
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    _isPlaying ? Icons.stop : Icons.volume_up,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pronunciation',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(153),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to hear the sound',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Meaning
                  Text(
                    'Meaning',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.onomatopoeia.meaning,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Example Sentence
                  Text(
                    'Example Sentence',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.onomatopoeia.exampleSentence,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        if (widget
                            .onomatopoeia.exampleTranslation.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Translation:',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(153),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.onomatopoeia.exampleTranslation,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Additional Information
                  Text(
                    'Details',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: categoryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: categoryColor,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(widget.onomatopoeia.category),
                              size: 16,
                              color: categoryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.onomatopoeia.category,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Difficulty
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.amber,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.school,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Level ${widget.onomatopoeia.difficulty}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Sound Type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.onomatopoeia.soundType == 'giongo'
                                  ? Icons.volume_up
                                  : Icons.auto_awesome,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.onomatopoeia.soundType,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Usage Context
                  if (widget.onomatopoeia.usageContext.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usage Context',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Text(
                            widget.onomatopoeia.usageContext,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),

                  // Tags
                  if (widget.onomatopoeia.tags.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tags',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.onomatopoeia.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Animal':
        return Icons.pets;
      case 'Nature':
        return Icons.park;
      case 'Human':
        return Icons.person;
      case 'Object':
        return Icons.category_outlined;
      case 'Food':
        return Icons.restaurant;
      case 'Vehicle':
        return Icons.directions_car;
      case 'Music':
        return Icons.music_note;
      case 'Technology':
        return Icons.computer;
      default:
        return Icons.category;
    }
  }

  Widget _buildImageSection(BuildContext context, Color categoryColor) {
    final imagePath = widget.onomatopoeia.imagePath;

    // If no image path is provided or it's empty, show icon
    if (imagePath.isEmpty) {
      return Center(
        child: Icon(
          _getCategoryIcon(widget.onomatopoeia.category),
          size: 120,
          color: Colors.white.withAlpha(179),
        ),
      );
    }

    // Try to load the image with error handling
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Log the error for debugging
        if (kDebugMode) {
          print('Error loading image: $imagePath - $error');
        }

        // If image fails to load, show icon
        return Center(
          child: Icon(
            _getCategoryIcon(widget.onomatopoeia.category),
            size: 120,
            color: Colors.white.withAlpha(179),
          ),
        );
      },
    );
  }
}
