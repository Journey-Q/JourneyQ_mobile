import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/app/themes/theme.dart'; // Import theme

class TripGroupsTab extends StatefulWidget {
  final Function(String, String, String) onNavigateToChat;

  const TripGroupsTab({super.key, required this.onNavigateToChat});

  @override
  State<TripGroupsTab> createState() => _TripGroupsTabState();
}

class _TripGroupsTabState extends State<TripGroupsTab> {
  bool _showMyGroups = true; // true = My Created Groups, false = Joined Groups

  @override
  Widget build(BuildContext context) {
    final myCreatedGroups = SampleData.createdTrips;
    final joinedGroups = SampleData.joinedTrips;
    final allGroups = [...myCreatedGroups, ...joinedGroups];

    if (allGroups.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Toggle Section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16), // More rounded
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showMyGroups = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _showMyGroups ? AppTheme.lightTheme.colorScheme.secondary : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: _showMyGroups ? Colors.white : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'My Groups',
                          style: TextStyle(
                            color: _showMyGroups ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showMyGroups = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_showMyGroups ? AppTheme.lightTheme.colorScheme.secondary : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.groups,
                          color: !_showMyGroups ? Colors.white : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Joined',
                          style: TextStyle(
                            color: !_showMyGroups ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Groups List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _showMyGroups ? myCreatedGroups.length : joinedGroups.length,
            itemBuilder: (context, index) {
              final trip = _showMyGroups ? myCreatedGroups[index] : joinedGroups[index];
              return _buildGroupTile(trip, _showMyGroups);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTile(Map<String, dynamic> trip, bool isMyGroup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // More rounded
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => widget.onNavigateToChat(
          trip['id']!,
          trip['title']!,
          trip['userImage']!,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Group Image - Rounded Square
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), // Rounded square
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _getLocationBasedImage(trip['destination']),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.location_on,
                          size: 28,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    // Removed the unread count display section
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocationBasedImage(String? destination) {
    final dest = destination?.toLowerCase() ?? '';
    
    if (dest.contains('kandy')) {
      return 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop';
    } else if (dest.contains('ella')) {
      return 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop';
    } else if (dest.contains('sigiriya')) {
      return 'https://images.unsplash.com/photo-1566133568781-d0293023926a?w=400&h=400&fit=crop';
    } else if (dest.contains('galle')) {
      return 'https://images.unsplash.com/photo-1549366021-9f761d040a94?w=400&h=400&fit=crop';
    } else if (dest.contains('nuwara eliya')) {
      return 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=400&fit=crop';
    } else if (dest.contains('yala')) {
      return 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=400&h=400&fit=crop';
    } else if (dest.contains('mirissa')) {
      return 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=400&fit=crop';
    } else if (dest.contains('anuradhapura')) {
      return 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&h=400&fit=crop';
    } else {
      return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20), // Rounded square
              ),
              child: Icon(
                Icons.groups,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Trip Groups Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create or join some trips to start chatting with fellow travelers!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}