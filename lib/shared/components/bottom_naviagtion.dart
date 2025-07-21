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

  // Define navigation items with attractive icons
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      route: '/home',
    ),
    BottomNavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      label: 'Marketplace',
      route: '/marketplace',
    ),
    BottomNavItem(
      icon: Icons.add_circle_outlined,
      activeIcon: Icons.add_circle,
      label: 'Create',
      route: '/create',
    ),
    BottomNavItem(
      icon: Icons.group_add_outlined,
      activeIcon: Icons.group_add_rounded,
      label: 'Join Trip',
      route: '/join_trip',
    ),
    BottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Check if keyboard is visible using MediaQuery
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    // Hide bottom navigation when keyboard is visible
    if (isKeyboardVisible) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false, // Don't add top padding
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    final primaryColor = theme.primaryColor;
    final activeColor = isActive ? primaryColor : Colors.black87;
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: isActive
                    ? BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : null,
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  color: activeColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // Unfocus any text fields to hide keyboard before navigation
    FocusScope.of(context).unfocus();
    
    // Add a small delay to ensure keyboard dismissal
    Future.delayed(const Duration(milliseconds: 100), () {
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
    });
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