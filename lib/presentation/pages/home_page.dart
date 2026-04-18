import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/home/search_bar.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/loading_indicator.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/home/featured_card.dart';
import '../../data/models/onomatopoeia_model.dart';
import 'onomatopoeia_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  String _currentSort = 'default';
  int _selectedCategoryIndex = 0;
  List<String> _categories = ['All']; // Add this to store categories
  bool _categoriesLoaded = false; // Track if categories are loaded

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCategories(); // Load categories on init
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {});
  }

  // Load categories asynchronously
  Future<void> _loadCategories() async {
    final provider = Provider.of<OnomatopoeiaProvider>(context, listen: false);
    final categories = await provider.getCategories(); // Await the Future
    setState(() {
      _categories = categories;
      _categoriesLoaded = true;
    });
  }

  void _showSortOptions(BuildContext context, OnomatopoeiaProvider provider) {
    final sortOptions = [
      {
        'title': 'A-Z Japanese',
        'subtitle': 'Alphabetical (Japanese)',
        'icon': Icons.sort_by_alpha,
        'color': Colors.blue,
        'value': 'japanese_asc',
      },
      {
        'title': 'Z-A Japanese',
        'subtitle': 'Reverse alphabetical',
        'icon': Icons.sort_by_alpha,
        'color': Colors.blue.shade300,
        'value': 'japanese_desc',
      },
      {
        'title': 'Easy First',
        'subtitle': 'Lowest difficulty first',
        'icon': Icons.trending_up,
        'color': Colors.green,
        'value': 'difficulty_asc',
      },
      {
        'title': 'Hard First',
        'subtitle': 'Highest difficulty first',
        'icon': Icons.trending_down,
        'color': Colors.red,
        'value': 'difficulty_desc',
      },
      {
        'title': 'Popular',
        'subtitle': 'Most viewed first',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
        'value': 'popularity_desc',
      },
      {
        'title': 'Recent',
        'subtitle': 'Newly added first',
        'icon': Icons.access_time,
        'color': Colors.purple,
        'value': 'date_desc',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sort,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sort Options',
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Sort Options List
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: sortOptions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final option = sortOptions[index];
                      final isSelected = _currentSort == option['value'];

                      return _buildSortOptionItem(
                        context: context,
                        title: option['title'] as String,
                        subtitle: option['subtitle'] as String,
                        icon: option['icon'] as IconData,
                        color: option['color'] as Color,
                        value: option['value'] as String,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _currentSort = option['value'] as String;
                          });
                          provider.sortOnomatopoeia(option['value'] as String);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentSort = 'default';
                            });
                            provider.sortOnomatopoeia('default');
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Text(
                            'Reset to Default',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOptionItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withAlpha(30)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Icon with circular background
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? color.withAlpha(20) : color.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : color.withAlpha(180),
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? color
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),

            // Selection Indicator (modern checkmark)
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(100),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userStats = userProvider.getUserStats();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: provider.isLoading
            ? const LoadingIndicator()
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 160,
                      floating: false,
                      pinned: true,
                      snap: false,
                      stretch: true,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            stretchModes: const [StretchMode.zoomBackground],
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.doraemonLightBlue,
                                    AppColors.doraemonBlue,
                                  ],
                                ),
                              ),
                              child: SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Greeting Section
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Greeting
                                            Text(
                                              'Welcome back,',
                                              style: AppTextStyles.bodyLarge
                                                  .copyWith(
                                                color:
                                                    Colors.white.withAlpha(204),
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              userStats['username'] ??
                                                  'Learner',
                                              style: AppTextStyles.headlineLarge
                                                  .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            // Search Bar
                                            SearchBarWidget(
                                              onSearchChanged:
                                                  provider.searchOnomatopoeia,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Doraemon Character - Using Image
                                      _buildDoraemonImage(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ];
                },
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Main Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quick Stats Section
                            _buildQuickStats(context, userStats),

                            const SizedBox(height: 24),

                            // Categories Section
                            _buildCategoriesSection(context, provider),

                            const SizedBox(height: 24),

                            // Featured Section
                            if (provider.onomatopoeiaList
                                .any((item) => item.viewCount > 10))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFeaturedSection(context, provider),
                                  const SizedBox(height: 16),
                                ],
                              ),

                            // Results Header
                            _buildResultsHeader(context, provider),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // Onomatopoeia Grid
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
                      sliver: provider.filteredList.isEmpty
                          ? SliverToBoxAdapter(
                              child: _buildEmptyContent(context, provider),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.85,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final onomatopoeia =
                                      provider.filteredList[index];
                                  return _buildCompactOnomatopoeiaCard(
                                      onomatopoeia, context);
                                },
                                childCount: provider.filteredList.length,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Doraemon Image Widget
  Widget _buildDoraemonImage() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 8),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            'assets/images/doraemon/doraemon.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.doraemonBlue,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Icon(
                    Icons.pets,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            context: context,
            value: '${stats['level']}',
            label: 'Level',
            color: Colors.amber,
            icon: Icons.star,
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).dividerColor,
          ),
          _buildStatItem(
            context: context,
            value: '${stats['learnedWords']}',
            label: 'Words',
            color: AppColors.doraemonBlue,
            icon: Icons.book,
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).dividerColor,
          ),
          _buildStatItem(
            context: context,
            value: '${stats['streak']}',
            label: 'Days',
            color: Colors.red,
            icon: Icons.local_fire_department,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String value,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
          ),
        ),
      ],
    );
  }

  // FIXED: Build categories section with loaded categories
  Widget _buildCategoriesSection(
      BuildContext context, OnomatopoeiaProvider provider) {
    // Show loading indicator while categories are loading
    if (!_categoriesLoaded) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Text(
                'Categories',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: EdgeInsets.only(
                  right: 12,
                  left: index == 0 ? 0 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    provider.filterByCategory(category);
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getCategoryColor(category).withAlpha(26)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? _getCategoryColor(category)
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    _getCategoryColor(category).withAlpha(51),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          color: isSelected
                              ? _getCategoryColor(category)
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(153),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? _getCategoryColor(category)
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(153),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(
      BuildContext context, OnomatopoeiaProvider provider) {
    final featuredList = provider.onomatopoeiaList
        .where((item) => item.viewCount > 10)
        .take(3)
        .toList();

    if (featuredList.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Text(
                'Featured Today',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.doraemonBlue.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: AppColors.doraemonBlue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Trending',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.doraemonBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: featuredList.length,
            itemBuilder: (context, index) {
              final onomatopoeia = featuredList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FeaturedCard(onomatopoeia: onomatopoeia),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultsHeader(
      BuildContext context, OnomatopoeiaProvider provider) {
    return Row(
      children: [
        Text(
          '${provider.filteredList.length} Results',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _showSortOptions(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.sort,
                  size: 16,
                  color: AppColors.doraemonBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  _getSortLabel(_currentSort),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.doraemonBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactOnomatopoeiaCard(
      Onomatopoeia onomatopoeia, BuildContext context) {
    final categoryColor = _getCategoryColor(onomatopoeia.category);

    return GestureDetector(
      onTap: () {
        _navigateToDetailsPage(context, onomatopoeia);
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background color with gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor.withAlpha(51),
                      categoryColor.withAlpha(26),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        onomatopoeia.category,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Japanese Text
                  Text(
                    onomatopoeia.japanese,
                    style: AppTextStyles.japaneseMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Romaji
                  Text(
                    onomatopoeia.romaji,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Meaning Preview
                  Flexible(
                    child: Text(
                      onomatopoeia.meaning,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const Spacer(),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Difficulty
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < onomatopoeia.difficulty
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      // View Count
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(153),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${onomatopoeia.viewCount}',
                            style: AppTextStyles.caption.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(153),
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
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  Provider.of<OnomatopoeiaProvider>(context, listen: false)
                      .toggleFavorite(onomatopoeia.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    onomatopoeia.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18,
                    color: onomatopoeia.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetailsPage(BuildContext context, Onomatopoeia onomatopoeia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OnomatopoeiaDetailsPage(onomatopoeia: onomatopoeia),
      ),
    );
  }

  Widget _buildEmptyContent(
      BuildContext context, OnomatopoeiaProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppColors.doraemonBlue.withAlpha(102),
            ),
          ),
          const SizedBox(height: 32),
          // Text
          Text(
            'No results found',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Try a different search or select a different category',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Button to clear filters
          ElevatedButton(
            onPressed: () {
              provider.clearAllFilters();
              setState(() {
                _selectedCategoryIndex = 0;
                _currentSort = 'default';
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: AppColors.doraemonBlue,
            ),
            child: const Text(
              'Clear All Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'All':
        return AppColors.doraemonBlue;
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
        return AppColors.doraemonBlue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All':
        return Icons.category;
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

  String _getSortLabel(String sortValue) {
    switch (sortValue) {
      case 'japanese_asc':
        return 'A-Z Japanese';
      case 'japanese_desc':
        return 'Z-A Japanese';
      case 'difficulty_asc':
        return 'Easy First';
      case 'difficulty_desc':
        return 'Hard First';
      case 'popularity_desc':
        return 'Popular';
      case 'date_desc':
        return 'Recent';
      case 'default':
      default:
        return 'Default';
    }
  }
}
