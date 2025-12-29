import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/loading_indicator.dart';

import '../../data/models/onomatopoeia_model.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Favorites', 'History', 'Practice', 'Mastered'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onomatopoeiaProvider = Provider.of<OnomatopoeiaProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'My Library',
        showBackButton: false,
      ),
      body: onomatopoeiaProvider.isLoading
          ? const LoadingIndicator()
          : Column(
        children: [
          // User Stats Card
          _buildUserStatsCard(userProvider),

          // Tab Bar
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
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFavoritesTab(onomatopoeiaProvider),
                _buildHistoryTab(onomatopoeiaProvider),
                _buildPracticeTab(onomatopoeiaProvider),
                _buildMasteredTab(onomatopoeiaProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsCard(UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8), // FIXED
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), // FIXED
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learning Progress',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level ${userProvider.userLevel}',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  '${userProvider.totalMastery}%',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2), // FIXED
              borderRadius: BorderRadius.circular(4),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * (userProvider.totalMastery / 100),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.8), // FIXED
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Words', '${userProvider.learnedWords}', Icons.book),
              _buildStatItem('Favorites', '${userProvider.favoriteCount}', Icons.favorite),
              _buildStatItem('Days', '${userProvider.streakDays}', Icons.local_fire_department),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)), // FIXED
        ),
      ],
    );
  }

  Widget _buildFavoritesTab(OnomatopoeiaProvider provider) {
    final favorites = provider.getFavorites();

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3), // FIXED
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: AppTextStyles.headlineSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon to add favorites',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), // FIXED
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return _buildLibraryItem(item, provider);
      },
    );
  }

  Widget _buildHistoryTab(OnomatopoeiaProvider provider) {
    final history = [...provider.onomatopoeiaList]
      ..sort((a, b) => b.viewCount.compareTo(a.viewCount))
      ..removeWhere((item) => item.viewCount == 0);

    if (history.isEmpty) {
      return _buildEmptyState('No viewing history', Icons.history);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return _buildLibraryItem(item, provider);
      },
    );
  }

  Widget _buildPracticeTab(OnomatopoeiaProvider provider) {
    final practiceItems = provider.onomatopoeiaList
        .where((item) => item.practiceCount > 0)
        .toList()
      ..sort((a, b) => b.practiceCount.compareTo(a.practiceCount));

    if (practiceItems.isEmpty) {
      return _buildEmptyState('No practice history', Icons.school);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: practiceItems.length,
      itemBuilder: (context, index) {
        final item = practiceItems[index];
        return _buildLibraryItem(item, provider);
      },
    );
  }

  Widget _buildMasteredTab(OnomatopoeiaProvider provider) {
    final mastered = provider.onomatopoeiaList
        .where((item) => item.mastery >= 0.8)
        .toList()
      ..sort((a, b) => b.mastery.compareTo(a.mastery));

    if (mastered.isEmpty) {
      return _buildEmptyState('No mastered words yet', Icons.emoji_events);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: mastered.length,
      itemBuilder: (context, index) {
        final item = mastered[index];
        return _buildMasteredCard(item);
      },
    );
  }

  Widget _buildLibraryItem(Onomatopoeia item, OnomatopoeiaProvider provider) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), // FIXED
          child: Text(
            item.japanese[0],
            style: AppTextStyles.japaneseMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        title: Text(
          item.japanese,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.romaji),
            Text(
              item.meaning,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Practice Count
            Chip(
              label: Text('${item.practiceCount}×'),
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), // FIXED
            ),
            const SizedBox(width: 8),
            // Mastery
            CircularProgressIndicator(
              value: item.mastery,
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        onTap: () {
          // Navigate to details
        },
      ),
    );
  }

  Widget _buildMasteredCard(Onomatopoeia item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), // FIXED
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), // FIXED
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mastery Badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              // Japanese Text
              Text(
                item.japanese,
                style: AppTextStyles.japaneseLarge.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Meaning
              Text(
                item.meaning,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // Mastery Level
              Text(
                '${(item.mastery * 100).round()}% Mastered',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3), // FIXED
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED
            ),
          ),
        ],
      ),
    );
  }
}