import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JourneyQAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount;
  final int chatCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onChatTap;
  final String selectedLocation;
  final List<String> sriLankanCities;
  final TextEditingController searchController;
  final ValueChanged<String?>? onLocationChanged;
  final String searchHint;

  const JourneyQAppBar({
    super.key,
    this.notificationCount = 0,
    this.chatCount = 0,
    this.onNotificationTap,
    this.onChatTap,
    required this.selectedLocation,
    required this.sriLankanCities,
    required this.searchController,
    this.onLocationChanged,
    this.searchHint = 'Search...',
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
                    // Notification Icon with Badge
                    _buildIconWithBadge(
                      icon: Icons.favorite_border_rounded,
                      count: notificationCount,
                      onTap: onNotificationTap,
                      isDark: false,
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
                                    style: const TextStyle(fontSize: 14),
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
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: searchHint,
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF0088cc),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
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
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 28, color: isDark ? Colors.white : Colors.black87),
            if (count > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: gradientBlue,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: gradientBlue.first.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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