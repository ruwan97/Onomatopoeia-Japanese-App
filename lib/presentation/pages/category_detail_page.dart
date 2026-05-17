import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import '../../data/models/onomatopoeia_model.dart';
import 'onomatopoeia_details_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final Color categoryColor;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String _sortBy = 'default';
  String _searchQuery = '';

  List<Onomatopoeia> _getFilteredAndSortedItems(List<Onomatopoeia> items) {
    List<Onomatopoeia> result = List.from(items);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = result.where((item) =>
      item.japanese.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.romaji.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.meaning.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'japanese_asc':
        result.sort((a, b) => a.japanese.compareTo(b.japanese));
        break;
      case 'difficulty_asc':
        result.sort((a, b) => a.difficulty.compareTo(b.difficulty));
        break;
      case 'difficulty_desc':
        result.sort((a, b) => b.difficulty.compareTo(a.difficulty));
        break;
      case 'popularity_desc':
        result.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);
    final categoryItems = provider.onomatopoeiaList
        .where((item) => item.category == widget.categoryName)
        .toList();
    final filteredItems = _getFilteredAndSortedItems(categoryItems);

    return Scaffold(
      appBar: AppBarCustom(
        title: widget.categoryName,
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() => _sortBy = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'default', child: Text('Default')),
              const PopupMenuItem(value: 'japanese_asc', child: Text('A-Z Japanese')),
              const PopupMenuItem(value: 'difficulty_asc', child: Text('Easy First')),
              const PopupMenuItem(value: 'difficulty_desc', child: Text('Hard First')),
              const PopupMenuItem(value: 'popularity_desc', child: Text('Most Popular')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.categoryColor.withOpacity(0.8),
                  widget.categoryColor.withOpacity(0.4),
                ],
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.categoryName,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${categoryItems.length} words',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${filteredItems.length} results',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_searchQuery.isNotEmpty)
                  Chip(
                    label: Text('Search: $_searchQuery'),
                    onDeleted: () {
                      setState(() => _searchQuery = '');
                    },
                  ),
              ],
            ),
          ),

          // Word List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No words found',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _sortBy = 'default';
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return RepaintBoundary(
                  child: _buildWordCard(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(Onomatopoeia item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OnomatopoeiaDetailsPage(onomatopoeia: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Difficulty indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getDifficultyColor(item.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.difficulty.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getDifficultyColor(item.difficulty),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Word info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.japanese,
                      style: AppTextStyles.japaneseMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.romaji,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.meaning,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Favorite button
              IconButton(
                icon: Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: item.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  Provider.of<OnomatopoeiaProvider>(context, listen: false)
                      .toggleFavorite(item.id);
                },
              ),
              // Audio icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.categoryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, size: 20),
                  onPressed: () {
                    // Play audio - you'll need to integrate your AudioService here
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1: return Colors.green;
      case 2: return Colors.lightGreen;
      case 3: return Colors.orange;
      case 4: return Colors.deepOrange;
      case 5: return Colors.red;
      default: return Colors.grey;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempQuery = _searchQuery;
        return AlertDialog(
          title: const Text('Search in Category'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter Japanese, Romaji, or meaning...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => tempQuery = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _searchQuery = tempQuery);
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}