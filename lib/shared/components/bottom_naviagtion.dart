import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentPageIndex;
  final Function(int)? onPageChanged; // Optional callback for page changes

  const CustomBottomNavigation({
    super.key,
    required this.currentPageIndex,
    this.onPageChanged,
  });

  // Define navigation items with their routes and icons
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    BottomNavItem(
      icon: Icons.store_outlined,
      activeIcon: Icons.store, 
      label: 'Marketplace',
      route: '/marketplace',
    ),
    BottomNavItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Create',
      route: '/create',
    ),
    BottomNavItem(
      icon: Icons.group_add_outlined, 
      activeIcon: Icons.group_add,    
      label: 'Join Trip',
      route: '/join_trip',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = currentPageIndex == index;
              
              return _buildNavItem(
                context: context,
                item: item,
                isActive: isActive,
                onTap: () => _handleNavigation(context, index),
                theme: theme,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required BottomNavItem item,
    required bool isActive,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final color = isActive 
        ? theme.primaryColor 
        : Colors.black;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              color: color,
              size: 28,
            )
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // Call the callback if provided
    if (onPageChanged != null) {
      onPageChanged!(index);
    }
    
    // Handle navigation based on index
    switch (index) {
      case 0: // Home
        context.go('/home');
        break;
      case 1: // Marketplace
        context.go('/marketplace');
        break;
      case 2: // Create
        context.go('/create');
        break;
      case 3: // Join Trip
        context.go('/join_trip');
        break;
      case 4: // Profile
        context.go('/profile');
        break;
      default:
        // Fallback to first item's route if index is out of bounds
        if (_navItems.isNotEmpty && index < _navItems.length) {
          context.go(_navItems[index].route);
        } else {
          context.go('/home');
        }
    }
  }

  // Helper method to get route based on index
  static String getRouteByIndex(int index) {
    if (index >= 0 && index < _navItems.length) {
      return _navItems[index].route;
    }
    return '/home'; // Default to home
  }

  // Helper method to get index based on route
  static int getIndexByRoute(String route) {
    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].route == route) {
        return i;
      }
    }
    return 0; // Default to home index
  }

  // Helper method to get total number of navigation items
  static int get itemCount => _navItems.length;
}

// Data class for navigation items (unchanged)
class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

// Example usage with the updated AppWrapper:
/*
class _AppWrapper extends StatelessWidget {
  final Widget? child;
  final int currentPageIndex;
  
  const _AppWrapper({
    this.child,
    this.currentPageIndex = 0,
  });

  bool _shouldShowNavigation(int pageIndex) {
    // All pages from 0-4 show navigation
    return pageIndex >= 0 && pageIndex < CustomBottomNavigation.itemCount;
  }

  @override
  Widget build(BuildContext context) {
    final showNavigation = _shouldShowNavigation(currentPageIndex);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: child,
        bottomNavigationBar: showNavigation
            ? CustomBottomNavigation(currentPageIndex: currentPageIndex)
            : null,
      ),
    );
  }
}

// Usage in your pages:
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AppWrapper(
      currentPageIndex: 0, // Home page index
      child: Center(child: Text('Home Page')),
    );
  }
}

class MarketplacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AppWrapper(
      currentPageIndex: 1, // Marketplace page index
      child: Center(child: Text('Marketplace Page')),
    );
  }
}
*/