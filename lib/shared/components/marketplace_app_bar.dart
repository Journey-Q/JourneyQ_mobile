import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class JourneyQAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount;
  final int chatCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onMenuTap; // New callback for menu
  final String selectedLocation;
  final List<String> sriLankanCities;
  final TextEditingController searchController;
  final ValueChanged<String?>? onLocationChanged;
  final String searchHint;
  final bool showMenuIcon; // New parameter to show/hide menu icon

  const JourneyQAppBar({
    super.key,
    this.notificationCount = 0,
    this.chatCount = 0,
    this.onNotificationTap,
    this.onChatTap,
    this.onMenuTap, // New parameter
    required this.selectedLocation,
    required this.sriLankanCities,
    required this.searchController,
    this.onLocationChanged,
    this.searchHint = 'Search...',
    this.showMenuIcon = false, // Default to false for backward compatibility
  });

  // Gradient colors from AppTheme
  static const List<Color> gradientBlue = [
    Color(0xFF1E3A8A), // Dark blue
    Color(0xFF3B82F6), // Medium blue
    Color(0xFF06B6D4), // Cyan
  ];

  // Gradient shader callback
  static ShaderCallback get gradientShader =>
          (bounds) => const LinearGradient(
        colors: gradientBlue,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds);

  // Method to show menu options
  void _showMenuOptions(BuildContext context) {
    final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + button.size.width - 200, // Adjust position to align with button
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height + 200,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          value: 'booking_history',
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Booking History',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'notifications',
          child: Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (notificationCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        notificationCount > 99 ? '99+' : notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((String? selected) {
      if (selected != null) {
        _handleMenuSelection(context, selected);
      }
    });
  }

  // Handle menu item selection
  void _handleMenuSelection(BuildContext context, String selection) {
    switch (selection) {
      case 'booking_history':
      // Navigate to booking history page
        context.push('/booking-history');
        break;
      case 'notifications':
      // Handle notifications tap
        if (onNotificationTap != null) {
          onNotificationTap!();
        }
        break;
      case 'profile':
      // Navigate to profile page
        context.push('/profile');
        break;
      case 'settings':
      // Navigate to settings page
        context.push('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // Remove Material 3 tinting
        foregroundColor: Colors.black87, // Set text/icon colors
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        clipBehavior: Clip.none,
        title: Column(
          children: [
            // Original title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // JourneyQ Logo with Gradient
                Flexible(
                  child: ShaderMask(
                    shaderCallback: gradientShader,
                    child: Text(
                      'MarketPlace',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // Icons container
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Menu Icon (3 dots) - Always show with functionality
                    Builder(
                      builder: (BuildContext context) {
                        return _buildIconWithBadge(
                          icon: Icons.more_vert,
                          count: 0, // Remove badge for cleaner look
                          onTap: () => _showMenuOptions(context),
                          isDark: false,
                          isMenuIcon: false,
                        );
                      },
                    ),

                    const SizedBox(width: 10),

                    // Chat Icon with Badge
                    _buildIconWithBadge(
                      icon: LucideIcons.messageCircle,
                      count: chatCount,
                      onTap: onChatTap,
                      isDark: false,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Location and Search Row
            Row(
              children: [
                // Location Dropdown
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLocation,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                        isExpanded: true,
                        isDense: true,
                        items: sriLankanCities.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF0088cc),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    city,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: onLocationChanged,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Search Bar
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: searchHint,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF0088cc),
                          size: 20,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey.shade600,
                            size: 18,
                          ),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onTap: () {
                        // Optional: Navigate to dedicated search page
                        // context.go('/search');
                      },
                      onSubmitted: (value) {
                        // Handle search submission
                        if (value.trim().isNotEmpty) {
                          // Perform search logic here
                          print('Searching for: $value');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required int count,
    required bool isDark,
    VoidCallback? onTap,
    bool isMenuIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isMenuIcon ? Colors.grey.shade100 : Colors.transparent,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: 24,
              color: isDark ? Colors.white : Colors.black87,
            ),
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMenuIcon
                          ? [Color(0xFF0088cc), Color(0xFF0066aa)] // Solid blue for menu
                          : gradientBlue, // Original gradient for notifications
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: (isMenuIcon ? Color(0xFF0088cc) : gradientBlue.first)
                            .withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isMenuIcon ? '•' : (count > 99 ? '99+' : count.toString()),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMenuIcon ? 16 : 11,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}