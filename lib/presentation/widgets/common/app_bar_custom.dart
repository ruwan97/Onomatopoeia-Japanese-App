import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/theme_provider.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const AppBarCustom({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // Navigate to favorites
          },
        ),
      ],
    );
  }
}