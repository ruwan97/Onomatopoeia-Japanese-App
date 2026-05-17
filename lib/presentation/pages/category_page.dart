import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/loading_indicator.dart';
import 'package:onomatopoeia_app/presentation/pages/category_detail_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    _categories = [
      CategoryModel(
        id: 'animal',
        name: 'Animal',
        icon: Icons.pets,
        color: AppColors.animalColor,
        description:
            'Sounds made by animals including pets, wildlife, and insects',
      ),
      CategoryModel(
        id: 'nature',
        name: 'Nature',
        icon: Icons.park,
        color: AppColors.natureColor,
        description:
            'Natural environmental sounds from weather, water, and plants',
      ),
      CategoryModel(
        id: 'weather',
        name: 'Weather',
        icon: Icons.wb_sunny,
        color: Colors.amber,
        description: 'Atmospheric and meteorological sound phenomena',
      ),
      CategoryModel(
        id: 'human',
        name: 'Human',
        icon: Icons.person,
        color: AppColors.humanColor,
        description:
            'Sounds related to human emotions, speech, and body functions',
      ),
      CategoryModel(
        id: 'emotions',
        name: 'Emotions',
        icon: Icons.sentiment_satisfied,
        color: Colors.pink,
        description:
            'Descriptive states expressing feelings and psychological conditions',
      ),
      CategoryModel(
        id: 'object',
        name: 'Object',
        icon: Icons.category,
        color: AppColors.objectColor,
        description:
            'Sounds produced by man-made objects and mechanical devices',
      ),
      CategoryModel(
        id: 'food',
        name: 'Food',
        icon: Icons.restaurant,
        color: AppColors.foodColor,
        description:
            'Sounds related to eating, drinking, cooking, and food textures',
      ),
      CategoryModel(
        id: 'vehicle',
        name: 'Vehicle',
        icon: Icons.directions_car,
        color: AppColors.vehicleColor,
        description: 'Transportation and vehicle-related sounds',
      ),
      CategoryModel(
        id: 'music',
        name: 'Music',
        icon: Icons.music_note,
        color: AppColors.musicColor,
        description:
            'Musical instrument sounds and performance-related onomatopoeia',
      ),
      CategoryModel(
        id: 'technology',
        name: 'Technology',
        icon: Icons.computer,
        color: AppColors.technologyColor,
        description: 'Modern technology and electronic device sounds',
      ),
      CategoryModel(
        id: 'sports',
        name: 'Sports',
        icon: Icons.sports_soccer,
        color: Colors.green,
        description: 'Sounds from athletic activities and sports events',
      ),
      CategoryModel(
        id: 'work',
        name: 'Work',
        icon: Icons.work,
        color: Colors.brown,
        description:
            'Office, construction, and professional environment sounds',
      ),
      CategoryModel(
        id: 'magic',
        name: 'Magic',
        icon: Icons.auto_awesome,
        color: Colors.purple,
        description: 'Fantasy, magical, and supernatural sound effects',
      ),
    ];

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context);

    final Map<String, int> categoryCounts = {};
    for (var category in _categories) {
      categoryCounts[category.name] = provider.onomatopoeiaList
          .where((item) => item.category == category.name)
          .length;
    }

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Categories',
        showBackButton: false,
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final count = categoryCounts[category.name] ?? 0;
                  return _buildCategoryCard(category, count);
                },
              ),
            ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category, int count) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailPage(
              categoryName: category.name,
              categoryColor: category.color,
            ),
          ),
        );
      },
      child: Hero(
        tag: 'category_${category.name}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withValues(alpha: 0.15),
                category.color.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: category.color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: category.color.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    size: 30,
                    color: category.color,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Text(
                    category.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count words',
                    style: AppTextStyles.caption.copyWith(
                      color: category.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    category.description,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Category Model Class
class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}
