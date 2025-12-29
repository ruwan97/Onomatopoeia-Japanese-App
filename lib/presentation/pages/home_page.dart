import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/home/category_chip.dart';
import 'package:onomatopoeia_app/presentation/widgets/home/search_bar.dart';
import 'package:onomatopoeia_app/presentation/widgets/onomatopoeia/onomatopoeia_card.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  String _currentSort = 'default';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showSortOptions(BuildContext context, OnomatopoeiaProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Sort Options',
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  // Sort Options List
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Alphabetical Section
                        _buildSectionTitle('Alphabetical'),
                        ..._buildSortOptionsWithIcons(context, provider),

                        const SizedBox(height: 16),

                        // Advanced Section
                        _buildSectionTitle('Advanced'),
                        _buildAdvancedOptions(provider),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _currentSort = 'default';
                                provider.sortOnomatopoeia('default');
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED
            fontWeight: FontWeight.w600,
          ),
        )
    );
  }

  List<Widget> _buildSortOptionsWithIcons(BuildContext context, OnomatopoeiaProvider provider) {
    final sortOptions = [
      {
        'label': 'A-Z (Japanese)',
        'value': 'japanese_asc',
        'icon': Icons.sort_by_alpha,
        'color': Colors.blue,
      },
      {
        'label': 'Z-A (Japanese)',
        'value': 'japanese_desc',
        'icon': Icons.sort_by_alpha,
        'color': Colors.blue,
      },
      {
        'label': 'Easy to Hard',
        'value': 'difficulty_asc',
        'icon': Icons.trending_up,
        'color': Colors.green,
      },
      {
        'label': 'Hard to Easy',
        'value': 'difficulty_desc',
        'icon': Icons.trending_down,
        'color': Colors.red,
      },
      {
        'label': 'Most Popular',
        'value': 'popularity_desc',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
      {
        'label': 'Recently Added',
        'value': 'date_desc',
        'icon': Icons.access_time,
        'color': Colors.purple,
      },
    ];

    return sortOptions.map((option) {
      return _buildSortOptionTile(context, option, provider);
    }).toList();
  }

  Widget _buildSortOptionTile(
      BuildContext context,
      Map<String, dynamic> option,
      OnomatopoeiaProvider provider,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _currentSort == option['value']
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1) // FIXED
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentSort == option['value']
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: option['color'].withValues(alpha: 0.1), // FIXED
            shape: BoxShape.circle,
          ),
          child: Icon(
            option['icon'],
            color: option['color'],
            size: 20,
          ),
        ),
        title: Text(option['label']),
        trailing: _currentSort == option['value']
            ? Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
        )
            : null,
        onTap: () {
          setState(() {
            _currentSort = option['value'];
            provider.sortOnomatopoeia(option['value']);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildAdvancedOptions(OnomatopoeiaProvider provider) {
    return Column(
      children: [
        // Multi-language sorting
        _buildAdvancedOptionTile(
          icon: Icons.language,
          title: 'Sort by English Translation',
          subtitle: 'A-Z in English',
          value: 'english_asc',
          iconColor: Colors.indigo,
        ),
        _buildAdvancedOptionTile(
          icon: Icons.category,
          title: 'Sort by Category',
          subtitle: 'Group by category first',
          value: 'category_asc',
          iconColor: Colors.teal,
        ),
        _buildAdvancedOptionTile(
          icon: Icons.star,
          title: 'Sort by Rating',
          subtitle: 'Highest rated first',
          value: 'rating_desc',
          iconColor: Colors.amber,
        ),
        _buildAdvancedOptionTile(
          icon: Icons.repeat,
          title: 'Sort by Frequency',
          subtitle: 'Most commonly used',
          value: 'frequency_desc',
          iconColor: Colors.cyan,
        ),

        // Saved/Presets section
        const SizedBox(height: 16),
        _buildSectionTitle('Saved Sorts'),
        _buildSavedSorts(),
      ],
    );
  }

  Widget _buildAdvancedOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _currentSort == value
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1) // FIXED
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentSort == value
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1), // FIXED
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), // FIXED
          ),
        ),
        trailing: _currentSort == value
            ? Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
        )
            : null,
        onTap: () {
          setState(() {
            _currentSort = value;
            // Note: You'll need to implement these sorting methods in your provider
            // provider.sortOnomatopoeia(value);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSavedSorts() {
    // Example saved sorts - you can load these from shared preferences
    final savedSorts = [
      {'name': 'Study Mode', 'value': 'difficulty_asc'},
      {'name': 'Quick Review', 'value': 'date_desc'},
      {'name': 'Flashcards', 'value': 'random'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: savedSorts.map((sort) {
        return ActionChip(
          avatar: const Icon(Icons.bookmark, size: 16),
          label: Text(sort['name']!),
          onPressed: () {
            setState(() {
              _currentSort = sort['value']!;
              // provider.sortOnomatopoeia(sort['value']!);
            });
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Onomatopoeia Master',
        showBackButton: false,
      ),
      body: provider.isLoading
          ? const LoadingIndicator()
          : _buildContent(context, provider),
    );
  }

  Widget _buildContent(BuildContext context, OnomatopoeiaProvider provider) {
    if (provider.filteredList.isEmpty) {
      return _buildEmptyContent(context, provider);
    }

    return _buildContentWithResults(context, provider);
  }

  Widget _buildEmptyContent(BuildContext context, OnomatopoeiaProvider provider) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWidget(
                onSearchChanged: provider.searchOnomatopoeia,
              ),
            ),

            // Category Chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.getCategories().length,
                itemBuilder: (context, index) {
                  final category = provider.getCategories()[index];
                  return CategoryChip(
                    label: category,
                    isSelected: provider.selectedCategory == category,
                    onSelected: () => provider.filterByCategory(category),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Empty State
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3), // FIXED
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try a different search or category',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), // FIXED
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentWithResults(BuildContext context, OnomatopoeiaProvider provider) {
    return Column(
      children: [
        // Header Section (Fixed)
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarWidget(
                  onSearchChanged: provider.searchOnomatopoeia,
                ),
              ),

              // Category Chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.getCategories().length,
                  itemBuilder: (context, index) {
                    final category = provider.getCategories()[index];
                    return CategoryChip(
                      label: category,
                      isSelected: provider.selectedCategory == category,
                      onSelected: () => provider.filterByCategory(category),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Results Count and Sort Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${provider.filteredList.length} results',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), // FIXED
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _showSortOptions(context, provider),
                      icon: const Icon(Icons.sort),
                      label: const Text('Sort'),
                    ),
                  ],
                ),
              ),

              // Current Sort Indicator
              if (_currentSort != 'default')
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), // FIXED
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sort, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              _getSortLabel(_currentSort),
                              style: AppTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentSort = 'default';
                            provider.sortOnomatopoeia('default');
                          });
                        },
                        child: Text(
                          'Clear',
                          style: AppTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Scrollable List (Expanded)
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => provider.loadData(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: provider.filteredList.length,
              itemBuilder: (context, index) {
                final onomatopoeia = provider.filteredList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: OnomatopoeiaCard(onomatopoeia: onomatopoeia),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getSortLabel(String sortValue) {
    switch (sortValue) {
      case 'japanese_asc':
        return 'A-Z (Japanese)';
      case 'japanese_desc':
        return 'Z-A (Japanese)';
      case 'difficulty_asc':
        return 'Easy to Hard';
      case 'difficulty_desc':
        return 'Hard to Easy';
      case 'popularity_desc':
        return 'Most Popular';
      case 'date_desc':
        return 'Recently Added';
      case 'english_asc':
        return 'A-Z (English)';
      case 'category_asc':
        return 'By Category';
      case 'rating_desc':
        return 'Highest Rated';
      case 'frequency_desc':
        return 'Most Common';
      case 'random':
        return 'Random';
      default:
        return 'Default';
    }
  }
}