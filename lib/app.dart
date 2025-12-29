import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_theme.dart';
import 'package:onomatopoeia_app/core/themes/theme_provider.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/services/audio_service.dart';
import 'package:onomatopoeia_app/presentation/pages/home_page.dart';
import 'package:onomatopoeia_app/presentation/pages/explore_page.dart';
import 'package:onomatopoeia_app/presentation/pages/library_page.dart';
import 'package:onomatopoeia_app/presentation/pages/profile_page.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/bottom_nav_bar.dart';

class OnomatopoeiaApp extends StatelessWidget {
  const OnomatopoeiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnomatopoeiaProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) => AudioService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Japanese Onomatopoeia',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const LibraryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}