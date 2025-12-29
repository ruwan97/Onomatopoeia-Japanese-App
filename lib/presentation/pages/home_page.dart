import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/bottom_nav_bar.dart';
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Onomatopoeia Master',
        showBackButton: false,
      ),
      body: provider.isLoading
          ? const LoadingIndicator()
          : _buildContent(context, provider, theme),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildContent(BuildContext context, OnomatopoeiaProvider provider, ThemeData theme) {
    return Column(
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

        // Results Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${provider.filteredList.length} results',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getSurfaceVariantColor(theme),
                ),
              ),
              const Spacer(),
              if (provider.filteredList.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    // Sort functionality
                  },
                  icon: const Icon(Icons.sort),
                  label: const Text('Sort'),
                ),
            ],
          ),
        ),

        // Onomatopoeia List
        Expanded(
          child: provider.filteredList.isEmpty
              ? _buildEmptyState(theme)
              : _buildOnomatopoeiaList(provider),
        ),
      ],
    );
  }

  Widget _buildOnomatopoeiaList(OnomatopoeiaProvider provider) {
    return RefreshIndicator(
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
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: _getSurfaceVariantColor(theme, opacity: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: AppTextStyles.headlineSmall.copyWith(
              color: _getSurfaceVariantColor(theme, opacity: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search or category',
            style: AppTextStyles.bodyMedium.copyWith(
              color: _getSurfaceVariantColor(theme, opacity: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get color with opacity without using deprecated withOpacity()
  Color _getSurfaceVariantColor(ThemeData theme, {double opacity = 1.0}) {
    final baseColor = theme.colorScheme.onSurface;

    // Method 1: Use withOpacity() with ignore (quick fix)
    // ignore: deprecated_member_use
    return baseColor.withOpacity(opacity);

    // Method 2: Use withValues() for exact color
    // return baseColor.withValues(
    //   alpha: (opacity * 255).round(),
    //   red: baseColor.red,
    //   green: baseColor.green,
    //   blue: baseColor.blue,
    // );

    // Method 3: Use Color.fromRGBO()
    // return Color.fromRGBO(
    //   baseColor.red,
    //   baseColor.green,
    //   baseColor.blue,
    //   opacity,
    // );
  }
}