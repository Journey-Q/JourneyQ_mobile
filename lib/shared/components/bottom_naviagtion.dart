import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNavigation({
    super.key,
    required this.currentRoute,
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
    icon: Icons.storefront_outlined,
    activeIcon: Icons.storefront,
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
    route: '/join-trip',
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
              final isActive = currentRoute == item.route;
              
              return _buildNavItem(
                context: context,
                item: item,
                isActive: isActive,
                onTap: () => _handleNavigation(context, item.route, index),
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

  void _handleNavigation(BuildContext context, String route, int index) {
    // Handle special cases or add custom logic here
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
        context.go(route);
    }
  }

  // Helper method to get current index based on route
  static int getCurrentIndex(String route) {
    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].route == route) {
        return i;
      }
    }
    return 0; // Default to home
  }
}

// Data class for navigation items
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

// Example usage in your pages:
/*
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home Page')),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: '/home',
      ),
    );
  }
}

class MarketplacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Marketplace Page')),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: '/marketplace',
      ),
    );
  }
}
*/