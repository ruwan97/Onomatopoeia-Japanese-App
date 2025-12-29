import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.currentIndex,
      onDestinationSelected: (index) {
        _navigateToPage(index, context);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_books_outlined),
          selectedIcon: Icon(Icons.library_books),
          label: 'Library',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
      // Already on home
        break;
      case 1:
      // Navigate to explore
        break;
      case 2:
      // Navigate to library
        break;
      case 3:
      // Navigate to profile
        break;
    }
  }
}