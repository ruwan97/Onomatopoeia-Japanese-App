import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/core/utils/extensions/context_extensions.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/loading_indicator.dart';
import 'package:onomatopoeia_app/presentation/widgets/onomatopoeia/audio_player_widget.dart';
import 'package:onomatopoeia_app/presentation/widgets/onomatopoeia/flip_card_widget.dart';
import 'package:onomatopoeia_app/presentation/widgets/onomatopoeia/difficulty_badge.dart';
import 'package:onomatopoeia_app/presentation/animations/fade_animation.dart';
import 'package:onomatopoeia_app/presentation/animations/scale_animation.dart';

class DetailsPage extends StatefulWidget {
  final String onomatopoeiaId;

  const DetailsPage({
    super.key,
    required this.onomatopoeiaId,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  bool _isLoading = true;
  Onomatopoeia? _onomatopoeia;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOnomatopoeia();
  }

  Future<void> _loadOnomatopoeia() async {
    final provider = Provider.of<OnomatopoeiaProvider>(context, listen: false);
    final found = provider.onomatopoeiaList.firstWhere(
          (item) => item.id == widget.onomatopoeiaId,
      orElse: () => provider.onomatopoeiaList.first,
    );

    setState(() {
      _onomatopoeia = found;
      _isFavorite = found.isFavorite;
      _isLoading = false;
    });

    // Increment view count
    provider.incrementViewCount(widget.onomatopoeiaId);
  }

  void _toggleFavorite() {
    if (_onomatopoeia != null) {
      final provider = Provider.of<OnomatopoeiaProvider>(context, listen: false);
      provider.toggleFavorite(_onomatopoeia!.id);
      setState(() {
        _isFavorite = !_isFavorite;
      });

      if (mounted) {
        context.showSuccessSnackbar(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        );
      }
    }
  }

  void _shareOnomatopoeia() {
    if (_onomatopoeia != null) {
      Share.share(
        'Learn Japanese Onomatopoeia!\n\n'
            '${_onomatopoeia!.japanese} (${_onomatopoeia!.romaji})\n'
            'Meaning: ${_onomatopoeia!.meaning}\n\n'
            'Example: ${_onomatopoeia!.exampleSentence}\n'
            'Translation: ${_onomatopoeia!.exampleTranslation}\n\n'
            'Download Onomatopoeia Master app to learn more!',
      );
    }
  }

  Future<void> _searchOnWeb() async {
    if (_onomatopoeia != null) {
      final query = Uri.encodeComponent('${_onomatopoeia!.japanese} onomatopoeia');
      final url = 'https://www.google.com/search?q=$query';

      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          if (mounted) {
            context.showErrorSnackbar('Could not launch browser');
          }
        }
      } catch (e) {
        if (mounted) {
          context.showErrorSnackbar('Error: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: AppBarCustom(
          title: 'Loading...',
          showBackButton: true,
        ),
        body: LoadingIndicator(),
      );
    }

    if (_onomatopoeia == null) {
      return Scaffold(
        appBar: const AppBarCustom(
          title: 'Not Found',
          showBackButton: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Onomatopoeia not found',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),
        ),
      );
    }

    final onomatopoeia = _onomatopoeia!;

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareOnomatopoeia,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Header Section
                _buildHeaderSection(onomatopoeia),

                // Stats Section
                _buildStatsSection(onomatopoeia),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Details'),
                      Tab(text: 'Usage'),
                      Tab(text: 'Related'),
                    ],
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED HERE
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(onomatopoeia),
                _buildUsageTab(onomatopoeia),
                _buildRelatedTab(onomatopoeia),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(onomatopoeia),
    );
  }

  Widget _buildHeaderSection(Onomatopoeia onomatopoeia) {
    final categoryColor = _getCategoryColor(onomatopoeia.category);

    return ScaleAnimation(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withValues(alpha: 0.2),
              categoryColor.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: Column(
          children: [
            // Japanese Text
            FadeAnimation(
              delay: 100,
              child: Text(
                onomatopoeia.japanese,
                style: AppTextStyles.japaneseLarge.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            // Romaji
            FadeAnimation(
              delay: 200,
              child: Text(
                onomatopoeia.romaji,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Meaning
            FadeAnimation(
              delay: 300,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  onomatopoeia.meaning,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Audio Player
            FadeAnimation(
              delay: 400,
              child: AudioPlayerWidget(soundPath: onomatopoeia.soundPath),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(Onomatopoeia onomatopoeia) {
    final categoryColor = _getCategoryColor(onomatopoeia.category);
    final isGiongo = onomatopoeia.soundType == 'giongo';

    return FadeAnimation(
      delay: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Category
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    onomatopoeia.category,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: categoryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Category',
                  style: AppTextStyles.caption,
                ),
              ],
            ),

            // Difficulty
            Column(
              children: [
                DifficultyBadge(difficulty: onomatopoeia.difficulty),
                const SizedBox(height: 4),
                Text(
                  'Difficulty',
                  style: AppTextStyles.caption,
                ),
              ],
            ),

            // Sound Type
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isGiongo
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    onomatopoeia.soundType,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: isGiongo
                          ? Colors.blue
                          : Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Type',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab(Onomatopoeia onomatopoeia) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Example Sentence
        _buildInfoCard(
          icon: Icons.format_quote,
          title: 'Example Sentence',
          content: onomatopoeia.exampleSentence,
        ),

        const SizedBox(height: 16),

        // Translation
        _buildInfoCard(
          icon: Icons.translate,
          title: 'Translation',
          content: onomatopoeia.exampleTranslation,
        ),

        const SizedBox(height: 16),

        // Usage Context
        if (onomatopoeia.usageContext.isNotEmpty)
          Column(
            children: [
              _buildInfoCard(
                icon: Icons.info,
                title: 'Usage Context',
                content: onomatopoeia.usageContext,
              ),
              const SizedBox(height: 16),
            ],
          ),

        // Subcategory
        if (onomatopoeia.subCategory.isNotEmpty)
          Column(
            children: [
              _buildInfoCard(
                icon: Icons.category,
                title: 'Subcategory',
                content: onomatopoeia.subCategory,
              ),
              const SizedBox(height: 16),
            ],
          ),

        // Tags
        if (onomatopoeia.tags.isNotEmpty)
          Column(
            children: [
              _buildInfoCard(
                icon: Icons.tag,
                title: 'Tags',
                content: onomatopoeia.tags.join(', '),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildUsageTab(Onomatopoeia onomatopoeia) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Flip Card for Practice
        Center(
          child: FlipCardWidget(
            frontText: onomatopoeia.japanese,
            backText: '${onomatopoeia.romaji}\n\n${onomatopoeia.meaning}',
            category: onomatopoeia.category,
          ),
        ),

        const SizedBox(height: 32),

        // Usage Tips
        _buildInfoCard(
          icon: Icons.lightbulb,
          title: 'Usage Tips',
          content: _getUsageTips(onomatopoeia),
        ),

        const SizedBox(height: 16),

        // Common Mistakes
        _buildInfoCard(
          icon: Icons.warning,
          title: 'Common Mistakes',
          content: _getCommonMistakes(onomatopoeia),
        ),

        const SizedBox(height: 16),

        // Cultural Notes
        _buildInfoCard(
          icon: Icons.public,
          title: 'Cultural Notes',
          content: _getCulturalNotes(onomatopoeia),
        ),
      ],
    );
  }

  Widget _buildRelatedTab(Onomatopoeia onomatopoeia) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);
    final relatedWords = provider.onomatopoeiaList
        .where((item) =>
    item.category == onomatopoeia.category &&
        item.id != onomatopoeia.id)
        .take(10)
        .toList();

    final similarWords = provider.onomatopoeiaList
        .where((item) =>
    onomatopoeia.similarWords.contains(item.japanese) ||
        onomatopoeia.tags.any((tag) => item.tags.contains(tag)))
        .where((item) => item.id != onomatopoeia.id)
        .take(10)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Similar Words
        if (onomatopoeia.similarWords.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Similar Words',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: onomatopoeia.similarWords.map((word) {
                  return Chip(
                    label: Text(word),
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),

        // Related in Same Category
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'More ${onomatopoeia.category} Words',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...relatedWords.map((item) {
              return _buildRelatedItem(item);
            }),
          ],
        ),

        const SizedBox(height: 24),

        // Similar Words List
        if (similarWords.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Similar Sounds',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...similarWords.map((item) {
                return _buildRelatedItem(item);
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildRelatedItem(Onomatopoeia item) {
    final categoryColor = _getCategoryColor(item.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor.withValues(alpha: 0.1),
          child: Text(
            item.japanese[0],
            style: TextStyle(
              color: categoryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(item.japanese),
        subtitle: Text(item.meaning),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(onomatopoeiaId: item.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Onomatopoeia onomatopoeia) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Practice Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to practice/quiz
                _showPracticeOptions();
              },
              icon: const Icon(Icons.school),
              label: const Text('Practice'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Search Web Button
          IconButton(
            onPressed: () {
              _searchOnWeb();
            },
            icon: const Icon(Icons.public),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  void _showPracticeOptions() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.auto_stories), // Fixed: Changed from Icons.flashcards to Icons.auto_stories
                title: const Text('Flashcards'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to flashcards
                },
              ),
              ListTile(
                leading: const Icon(Icons.quiz),
                title: const Text('Quiz'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to quiz
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic),
                title: const Text('Pronunciation Practice'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to pronunciation practice
                },
              ),
            ],
          ),
        );
      },
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

  String _getUsageTips(Onomatopoeia onomatopoeia) {
    switch (onomatopoeia.category) {
      case 'Animal':
        return 'Use ${onomatopoeia.japanese} when describing animal sounds in stories or conversations. Japanese children often use these sounds when playing or reading picture books.';
      case 'Nature':
        return '${onomatopoeia.japanese} is commonly used in poetry, literature, and daily conversation to describe natural phenomena. It helps create vivid imagery in descriptions.';
      case 'Human':
        return 'This onomatopoeia is frequently used in manga, anime, and casual conversation to express emotions or describe actions vividly.';
      case 'Food':
        return 'Use ${onomatopoeia.japanese} when describing food texture or eating sounds in recipes, food reviews, or cooking shows.';
      default:
        return 'This word is commonly used in various contexts. Pay attention to the example sentence to understand proper usage.';
    }
  }

  String _getCommonMistakes(Onomatopoeia onomatopoeia) {
    switch (onomatopoeia.soundType) {
      case 'giongo':
        return 'Remember that giongo words describe actual sounds. Don\'t use them to describe states or feelings without sound elements.';
      case 'gitaigo':
        return 'Gitaigo words describe states or conditions without sound. Be careful not to use them as sound effects.';
      default:
        return 'Make sure to use the correct particle when using this word in sentences.';
    }
  }

  String _getCulturalNotes(Onomatopoeia onomatopoeia) {
    if (onomatopoeia.category == 'Food' && onomatopoeia.japanese.contains('ネバネバ')) {
      return 'ネバネバ foods like natto and okra are considered healthy in Japan and are popular breakfast items.';
    }

    if (onomatopoeia.category == 'Animal' && onomatopoeia.japanese == 'ワンワン') {
      return 'In Japanese, dog sounds are "wan wan" instead of "woof woof". This reflects cultural differences in how sounds are perceived.';
    }

    return 'Onomatopoeia are an important part of Japanese language and culture, appearing frequently in manga, anime, and daily conversation.';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}