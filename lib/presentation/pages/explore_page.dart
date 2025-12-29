import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/loading_indicator.dart';
import '../../data/models/onomatopoeia_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Popular',
    'New',
    'Difficult',
    'Easy'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Explore',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog(context, provider);
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const LoadingIndicator()
          : Column(
              children: [
                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: _categories
                        .map((category) => Tab(text: category))
                        .toList(),
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    isScrollable: true,
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _categories.map((category) {
                      return _buildCategoryView(category, provider);
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryView(String category, OnomatopoeiaProvider provider) {
    List<Onomatopoeia> items = [];

    switch (category) {
      case 'All':
        items = provider.filteredList;
        break;
      case 'Popular':
        items = [...provider.onomatopoeiaList]
          ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
      case 'New':
        items = [...provider.onomatopoeiaList]
          ..sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
      case 'Difficult':
        items = provider.onomatopoeiaList
            .where((item) => item.difficulty >= 4)
            .toList();
        break;
      case 'Easy':
        items = provider.onomatopoeiaList
            .where((item) => item.difficulty <= 2)
            .toList();
        break;
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_off,
              size: 80,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: AppTextStyles.headlineSmall.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildExploreCard(items[index]);
      },
    );
  }

  Widget _buildExploreCard(Onomatopoeia item) {
    final categoryColor = _getCategoryColor(item.category);

    return GestureDetector(
      onTap: () {
        _navigateToDetails(item);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Background Image/Color
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor.withValues(alpha: 0.2),
                    categoryColor.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.category,
                      style: AppTextStyles.buttonSmall
                          .copyWith(color: Colors.white),
                    ),
                  ),

                  // Japanese Text
                  Center(
                    child: Text(
                      item.japanese,
                      style: AppTextStyles.japaneseMedium.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Meaning
                  Text(
                    item.meaning,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Difficulty
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < item.difficulty
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: Colors.white,
                          );
                        }),
                      ),

                      // Views
                      Row(
                        children: [
                          const Icon(Icons.visibility,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${item.viewCount}',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white),
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
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: item.isFavorite ? Colors.red : Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  Provider.of<OnomatopoeiaProvider>(context, listen: false)
                      .toggleFavorite(item.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(Onomatopoeia item) {
    // TODO: Import DetailsPage and navigate
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DetailsPage(onomatopoeiaId: item.id),
    //   ),
    // );
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

  void _showFilterDialog(BuildContext context, OnomatopoeiaProvider provider) {
    Map<String, bool> difficultyFilters = {
      'All Levels': true,
      'Beginner (1-2)': false,
      'Intermediate (3)': false,
      'Advanced (4-5)': false,
    };

    Map<String, bool> soundTypeFilters = {
      'All Types': true,
      'Giongo (Sound)': false,
      'Gitaigo (State)': false,
    };

    Map<String, bool> sortByFilters = {
      'Default': true,
      'Popularity': false,
      'Recently Added': false,
      'Alphabetical': false,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Options'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildFilterSection(
                      'Difficulty',
                      difficultyFilters,
                      (entry) {
                        setState(() {
                          if (entry.value == true &&
                              entry.key != 'All Levels') {
                            difficultyFilters['All Levels'] = false;
                          } else if (entry.key == 'All Levels' &&
                              entry.value == true) {
                            difficultyFilters.forEach((key, _) {
                              difficultyFilters[key] = key == 'All Levels';
                            });
                          }
                          difficultyFilters[entry.key] = entry.value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFilterSection(
                      'Sound Type',
                      soundTypeFilters,
                      (entry) {
                        setState(() {
                          if (entry.value == true && entry.key != 'All Types') {
                            soundTypeFilters['All Types'] = false;
                          } else if (entry.key == 'All Types' &&
                              entry.value == true) {
                            soundTypeFilters.forEach((key, _) {
                              soundTypeFilters[key] = key == 'All Types';
                            });
                          }
                          soundTypeFilters[entry.key] = entry.value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFilterSection(
                      'Sort By',
                      sortByFilters,
                      (entry) {
                        setState(() {
                          if (entry.value == true) {
                            sortByFilters.forEach((key, _) {
                              sortByFilters[key] = key == entry.key;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters(
                      difficultyFilters,
                      soundTypeFilters,
                      sortByFilters,
                      provider,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    Map<String, bool> options,
    void Function(MapEntry<String, bool?>) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...options.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: entry.value,
                  onChanged: (value) => onChanged(MapEntry(entry.key, value)),
                ),
                Text(entry.key),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _applyFilters(
    Map<String, bool> difficultyFilters,
    Map<String, bool> soundTypeFilters,
    Map<String, bool> sortByFilters,
    OnomatopoeiaProvider provider,
  ) {
    // Apply difficulty filter
    List<int> selectedDifficulties = [];
    if (difficultyFilters['Beginner (1-2)'] == true) {
      selectedDifficulties.addAll([1, 2]);
    }
    if (difficultyFilters['Intermediate (3)'] == true) {
      selectedDifficulties.add(3);
    }
    if (difficultyFilters['Advanced (4-5)'] == true) {
      selectedDifficulties.addAll([4, 5]);
    }

    // Apply sound type filter
    List<String> selectedSoundTypes = [];
    if (soundTypeFilters['Giongo (Sound)'] == true) {
      selectedSoundTypes.add('giongo');
    }
    if (soundTypeFilters['Gitaigo (State)'] == true) {
      selectedSoundTypes.add('gitaigo');
    }

    // Apply sort
    String sortType = 'default';
    if (sortByFilters['Popularity'] == true) {
      sortType = 'popularity_desc';
    } else if (sortByFilters['Recently Added'] == true) {
      sortType = 'date_desc';
    } else if (sortByFilters['Alphabetical'] == true) {
      sortType = 'japanese_asc';
    }

    // Apply filters to provider
    provider.applyFilters(
      difficulties:
          difficultyFilters['All Levels'] == true ? [] : selectedDifficulties,
      soundTypes:
          soundTypeFilters['All Types'] == true ? [] : selectedSoundTypes,
      sortType: sortType,
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Filters applied successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
