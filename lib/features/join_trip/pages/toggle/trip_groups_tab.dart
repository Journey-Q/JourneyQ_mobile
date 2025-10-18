import 'package:flutter/material.dart';
import 'package:journeyq/app/themes/theme.dart'; // Import theme
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';
import 'package:journeyq/core/storage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripGroupsTab extends StatefulWidget {
  final Function(String, String, String) onNavigateToChat;

  const TripGroupsTab({super.key, required this.onNavigateToChat});

  @override
  State<TripGroupsTab> createState() => TripGroupsTabState();
}

class TripGroupsTabState extends State<TripGroupsTab>
    with AutomaticKeepAliveClientMixin {
  bool _showMyGroups = true; // true = My Created Groups, false = Joined Groups
  bool _isLoading = true;
  List<Map<String, dynamic>> _myCreatedGroups = [];
  List<Map<String, dynamic>> _joinedGroups = [];
  int? _currentUserId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  /// Public method to refresh groups (can be called from parent)
  Future<void> refreshGroups() async {
    print('🔄 Manually refreshing groups from external call...');
    await _loadGroups();
    print('✅ Manual refresh completed');
  }

  Future<void> _loadGroups() async {
    setState(() => _isLoading = true);

    try {
      // Get current user
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorage(prefs: prefs);
      final currentUser = await localStorage.getUser();

      if (currentUser != null && currentUser.userId != null) {
        _currentUserId = currentUser.userId;

        print('🔄 Loading groups for user ${currentUser.userId}...');

        // Fetch groups created by user
        final createdGroups = await JointTripGroupRepository.getCreatedGroups(currentUser.userId!);
        print('✅ Loaded ${createdGroups.length} created groups');

        // Fetch groups joined by user
        final joinedGroups = await JointTripGroupRepository.getJoinedGroups(currentUser.userId!);
        print('✅ Loaded ${joinedGroups.length} joined groups');

        if (mounted) {
          setState(() {
            _myCreatedGroups = createdGroups;
            _joinedGroups = joinedGroups;
            _isLoading = false;
          });
        }
      } else {
        print('⚠️ No user found in local storage');
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('❌ Error loading groups: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allGroups = [..._myCreatedGroups, ..._joinedGroups];

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
          child: RefreshIndicator(
            onRefresh: _loadGroups,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _showMyGroups ? _myCreatedGroups.length : _joinedGroups.length,
              itemBuilder: (context, index) {
                final group = _showMyGroups ? _myCreatedGroups[index] : _joinedGroups[index];
                return _buildGroupTile(group, _showMyGroups);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTile(Map<String, dynamic> group, bool isMyGroup) {
    final groupId = group['groupId']?.toString() ?? '';
    final groupName = group['groupName']?.toString() ?? 'Unknown Group';
    final groupProfile = group['groupProfile']?.toString() ?? '';
    final memberCount = (group['members'] as Map?)?.length ?? 0;

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
          groupId,
          groupName,
          groupProfile,
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
                  child: groupProfile.isNotEmpty
                      ? Image.network(
                          groupProfile,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultGroupIcon();
                          },
                        )
                      : _buildDefaultGroupIcon(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildDefaultGroupIcon() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.groups,
        size: 28,
        color: Colors.grey[600],
      ),
    );
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