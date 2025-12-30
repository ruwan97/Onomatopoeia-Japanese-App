// Update AppBarCustom to accept a callback for navigation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/theme_provider.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onFavoritesPressed; // Add this

  const AppBarCustom({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onFavoritesPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final onomatopoeiaProvider = Provider.of<OnomatopoeiaProvider>(context, listen: true);

    // Calculate favorite count from the list
    final favoriteCount = onomatopoeiaProvider.onomatopoeiaList
        .where((item) => item.isFavorite)
        .length;

    // Hide favorites icon if we're on the Library page
    final isLibraryPage = title == 'My Library';

    return AppBar(
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.maybePop(context),
      )
          : null,
      title: Text(title, style: AppTextStyles.headlineSmall),
      centerTitle: false,
      elevation: 0,
      actions: [
        if (actions != null) ...actions!,

        // Favorites button with badge
        if (!isLibraryPage) ...[
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: onFavoritesPressed ?? () {
                  // Show snackbar to use bottom navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You have $favoriteCount favorite${favoriteCount == 1 ? '' : 's'}. '
                            'Go to Library tab to view them.',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (favoriteCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      favoriteCount > 9 ? '9+' : favoriteCount.toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],

        // Theme toggle
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
      ],
    );
  }
}