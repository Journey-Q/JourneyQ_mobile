import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/trip_repository.dart';
import 'package:journeyq/core/storage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_details_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/core/services/api_service.dart';

class GroupDetailsPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupImage;

  const GroupDetailsPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupImage,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late TextEditingController _groupNameController;
  bool _isEditing = false;
  bool _isLoading = true;

  Map<String, dynamic>? _groupData;
  List<Map<String, dynamic>> _members = [];
  Map<String, dynamic>? _tripData;
  bool _isCreator = false;
  int? _currentUserId;
  int? _tripId;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(text: widget.groupName);
    _loadGroupData();
  }

  Future<void> _loadGroupData() async {
    setState(() => _isLoading = true);

    try {
      // Get current user
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorage(prefs: prefs);
      final currentUser = await localStorage.getUser();
      _currentUserId = currentUser?.userId;

      // Extract tripId from groupId (format: trip_123)
      _tripId = int.tryParse(widget.groupId.replaceFirst('trip_', ''));

      if (_tripId != null) {
        // Fetch group data from Firebase
        _groupData = await JointTripGroupRepository.getGroupDetails(_tripId!);

        if (_groupData != null) {
          // Get members
          final membersMap = _groupData!['members'] as Map<dynamic, dynamic>?;
          if (membersMap != null) {
            _members = membersMap.values
                .map((m) => Map<String, dynamic>.from(m as Map))
                .toList();
          }

          // Check if current user is creator
          _isCreator = _groupData!['creatorId'] == _currentUserId;

          // Update group name controller
          _groupNameController.text = _groupData!['groupName'] ?? widget.groupName;
        }

        // Fetch trip data from backend
        try {
          _tripData = await TripRepository.getTripById(_tripId!);
        } catch (e) {
          print('Error fetching trip data: $e');
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading group data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _saveGroupName() async {
    if (_tripId == null) return;

    try {
      final newName = _groupNameController.text.trim();
      if (newName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group name cannot be empty'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await JointTripGroupRepository.updateGroupName(
        tripId: _tripId!,
        newGroupName: newName,
      );

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group name updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update group name: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _getTripCoverImage() {
    // First check trip data (backend) for cover image
    if (_tripData != null && _tripData!['coverImageUrl'] != null && _tripData!['coverImageUrl'].toString().isNotEmpty) {
      return _tripData!['coverImageUrl'];
    }

    // Fallback: Check Firebase group profile for cover image
    if (_groupData != null && _groupData!['groupProfile'] != null && _groupData!['groupProfile'].toString().isNotEmpty) {
      return _groupData!['groupProfile'];
    }

    // Return null if no cover image - will show placeholder
    return null;
  }

  Future<void> _changeGroupImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      // Pick image from gallery
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (_tripId != null) {
        final File imageFile = File(image.path);

        // TEMPORARY FIX: Upload directly to Cloudinary and update Firebase
        // This bypasses the backend endpoint that doesn't exist yet
        print('📤 Uploading image to Cloudinary...');

        final coverImageUrl = await ApiService.uploadImage(
          imageFile: imageFile,
          subfolderName: 'journeyq/trip_covers',
          customFileName: 'trip_${_tripId}_cover_${DateTime.now().millisecondsSinceEpoch}',
        );

        if (coverImageUrl == null || coverImageUrl.isEmpty) {
          throw Exception('Failed to upload image to Cloudinary');
        }

        print('✅ Image uploaded to Cloudinary: $coverImageUrl');

        // Update Firebase group profile
        await JointTripGroupRepository.updateGroupProfile(
          tripId: _tripId!,
          profileUrl: coverImageUrl,
        );
        print('✅ Firebase group profile updated');

        // TODO: When backend endpoint is ready, also call:
        // await TripRepository.uploadTripCoverImage(_tripId!, imageFile);

        // Reload group data from Firebase to get the updated profile
        _groupData = await JointTripGroupRepository.getGroupDetails(_tripId!);

        // Update local trip data with new cover image
        if (_tripData != null) {
          _tripData!['coverImageUrl'] = coverImageUrl;
        }

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Update UI
        setState(() {});

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cover image updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error updating cover image: $e');

      // Close loading dialog if open
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cover image: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Landscape Image
          SliverAppBar(
            expandedHeight: 320.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              if (_isCreator)
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_isEditing) {
                        _saveGroupName();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
                    child: Text(
                      _isEditing ? 'Save' : 'Edit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Color
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      color: Colors.grey[100],
                    ),
                  ),

                  // Content - Profile Picture and Name
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Full-width Rounded Rectangle Profile Picture
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: _getTripCoverImage() != null
                                    ? Image.network(
                                        _getTripCoverImage()!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'No cover image',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            if (_isCreator && _isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _changeGroupImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0088cc),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Group Name Below Picture
                        _isEditing && _isCreator
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: TextField(
                                  controller: _groupNameController,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Group Name',
                                  ),
                                ),
                              )
                            : Text(
                                _groupNameController.text,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Details Section
                  _buildTripDetailsSection(),
                  const SizedBox(height: 24),

                  // Members Section
                  _buildMembersSection(),
                  const SizedBox(height: 24),

                  // Leave/Delete Group Button
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Destination',
            _tripData?['destination'] ?? 'Unknown',
            Icons.location_on,
          ),
          _buildDetailRow(
            'Start Date',
            _tripData?['startDate'] ?? 'TBD',
            Icons.calendar_today,
          ),
          _buildDetailRow(
            'End Date',
            _tripData?['endDate'] ?? 'TBD',
            Icons.calendar_month,
          ),
          _buildDetailRow(
            'Trip Type',
            _tripData?['tripType'] ?? 'Cultural Heritage',
            Icons.category,
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 16),
          // View and Edit Buttons
          Row(
            children: [
              Expanded(
                child: _buildTripActionButton(
                  icon: Icons.visibility,
                  label: 'View',
                  color: Colors.blue,
                  onTap: _tripData != null ? _viewTripDetails : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTripActionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  color: Colors.green,
                  onTap: _isCreator && _tripData != null ? _editTrip : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0088cc).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF0088cc)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Members (${_members.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_members.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No members found'),
              ),
            )
          else
            ..._members.map((member) => _buildMemberTile(member)),
        ],
      ),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member) {
    final userName = member['userName']?.toString() ?? 'Unknown';
    final userRole = member['role']?.toString() ?? 'member';
    final userId = member['userId'] as int?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Member Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: const Icon(
              Icons.person,
              size: 24,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  userRole == 'creator' ? 'Creator' : 'Member',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (_isCreator && userId != _currentUserId)
            IconButton(
              icon: const Icon(Icons.person_remove, color: Colors.red),
              onPressed: () => _removeMember(userId, userName),
            ),
        ],
      ),
    );
  }

  Future<void> _removeMember(int? userId, String userName) async {
    if (userId == null || _tripId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Remove $userName from the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true && _currentUserId != null) {
      try {
        await JointTripGroupRepository.removeMember(
          tripId: _tripId!,
          creatorId: _currentUserId!,
          memberIdToRemove: userId,
        );

        _loadGroupData(); // Reload data

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$userName removed from group'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove member: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildActionButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _isCreator ? _deleteGroup : _leaveGroup,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isCreator ? Icons.delete : Icons.exit_to_app,
                color: Colors.red,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                _isCreator ? 'Delete Group' : 'Leave Group',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteGroup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && _tripId != null && _currentUserId != null) {
      try {
        await JointTripGroupRepository.deleteGroup(
          tripId: _tripId!,
          userId: _currentUserId!,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group deleted successfully'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete group: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _leaveGroup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirm == true && _tripId != null && _currentUserId != null) {
      try {
        await JointTripGroupRepository.leaveGroup(
          tripId: _tripId!,
          userId: _currentUserId!,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have left the group'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to leave group: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildTripActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: onTap == null ? Colors.grey.withOpacity(0.1) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: onTap == null ? Colors.grey.withOpacity(0.3) : color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: onTap == null ? Colors.grey : color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: onTap == null ? Colors.grey : color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewTripDetails() {
    if (_tripData == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsWidget(
          tripData: _tripData!,
          customTitle: _tripData!['title'],
          isGroupMember: true,
        ),
      ),
    );
  }

  void _editTrip() async {
    if (_tripData == null || !_isCreator) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormWidget(
          mode: TripFormMode.edit,
          initialData: _tripData,
          isGroupMember: true,
          customTitle: 'Edit ${_tripData!['title']}',
          onSubmit: (updatedData) async {
            try {
              await TripRepository.updateTrip(_tripId!, updatedData);
            } catch (e) {
              throw Exception('Failed to update trip: $e');
            }
          },
        ),
        fullscreenDialog: true,
      ),
    );

    // Reload trip data if edit was successful
    if (result == true || result == null) {
      await _loadGroupData();
    }
  }
}
