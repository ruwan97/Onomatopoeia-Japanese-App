import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_theme.dart';
import 'package:onomatopoeia_app/core/themes/theme_provider.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/presentation/pages/home_page.dart';

class OnomatopoeiaApp extends StatelessWidget {
  const OnomatopoeiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnomatopoeiaProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Onomatopoeia Master',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}