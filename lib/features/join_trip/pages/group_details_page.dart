import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_details_widget.dart';

class GroupDetailsPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupImage;
  final String description;
  final List<Map<String, dynamic>> members;
  final bool isCreator; // true if current user created this group
  final String createdDate;

  const GroupDetailsPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupImage,
    required this.description,
    required this.members,
    required this.isCreator,
    required this.createdDate,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late TextEditingController _groupNameController;
  bool _isEditing = false;
  late Map<String, String> _tripDetails;
  Map<String, dynamic>? _tripFormData;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(text: widget.groupName);
    _tripDetails = SampleData.getTripDetails(widget.groupId);
    _loadTripFormData();
  }

  void _loadTripFormData() {
    // Try to find corresponding trip form data
    final groupData = SampleData.getGroupById(widget.groupId);
    if (groupData != null) {
      // Convert group data to trip form format with ONLY basic fields
      _tripFormData = {
        'title': groupData['title'] ?? widget.groupName,
        'destination': _tripDetails['destination'],
        'startDate': _tripDetails['startDate'],
        'endDate': _tripDetails['endDate'],
        'tripType': _tripDetails['tripType'],
        'description': widget.description,
        'duration': groupData['duration'] ?? '3 days',
        'status': 'Active',
        'createdDate': widget.createdDate,
      };
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  String _getLocationBasedImage() {
    final destination = _tripDetails['destination']?.toLowerCase() ?? '';

    if (destination.contains('kandy')) {
      return 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop';
    } else if (destination.contains('ella')) {
      return 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=400&fit=crop';
    } else if (destination.contains('sigiriya')) {
      return 'https://images.unsplash.com/photo-1566133568781-d0293023926a?w=800&h=400&fit=crop';
    } else if (destination.contains('galle')) {
      return 'https://images.unsplash.com/photo-1549366021-9f761d040a94?w=800&h=400&fit=crop';
    } else if (destination.contains('nuwara eliya')) {
      return 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&h=400&fit=crop';
    } else {
      return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              if (widget.isCreator)
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_isEditing) {
                        _saveChanges();
                      } else {
                        setState(() {
                          _isEditing = true;
                        });
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
                  // Solid Color Background (no landscape image)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      color: Colors.grey[100], // Light background color
                    ),
                  ),
                  
                  // Content Overlay - Profile Picture and Name Only
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Full-width Rounded Rectangle Profile Picture with increased length
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150, // Increased length
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12), // Rounded rectangle
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
                                child: Image.network(
                                  _getLocationBasedImage(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (widget.isCreator && _isEditing)
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
                        _isEditing && widget.isCreator
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
                                widget.groupName,
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
        borderRadius: BorderRadius.circular(20), // Rounded square design
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trip Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildActionChip(
                    icon: Icons.visibility,
                    label: 'View',
                    onTap: _viewTripDetails,
                    color: const Color(0xFF0088cc),
                  ),
                  const SizedBox(width: 8),
                  _buildActionChip(
                    icon: Icons.edit,
                    label: 'Edit',
                    onTap: _editTripDetails,
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Destination',
            _tripDetails['destination']!,
            Icons.location_on,
          ),
          _buildDetailRow(
            'Start Date',
            _tripDetails['startDate']!,
            Icons.calendar_today,
          ),
          _buildDetailRow(
            'End Date',
            _tripDetails['endDate']!,
            Icons.calendar_month,
          ),
          _buildDetailRow(
            'Budget',
            _tripDetails['budget']!,
            Icons.account_balance_wallet,
          ),
          _buildDetailRow(
            'Trip Type',
            _tripDetails['tripType']!,
            Icons.category,
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0088cc).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10), // Rounded square
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
                    fontWeight: FontWeight.w500,
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
        borderRadius: BorderRadius.circular(20), // Rounded square design
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Members (${widget.members.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isCreator)
                _buildActionChip(
                  icon: Icons.person_add,
                  label: 'Add',
                  onTap: _addMember,
                  color: Colors.green,
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.members.map((member) => _buildMemberTile(member)),
        ],
      ),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16), // Rounded square design
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Member Avatar - Rounded Square
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), // Rounded square
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.network(
                member['avatar'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              member['name'],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          if (widget.isCreator && member['id'] != 'current_user')
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'remove') {
                  _removeMember(member);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.more_vert,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Rounded square design
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.isCreator ? _deleteGroup : _leaveGroup,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.isCreator ? Icons.delete : Icons.exit_to_app,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.isCreator ? 'Delete Group' : 'Leave Group',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Trip Details Methods
  void _viewTripDetails() {
    if (_tripFormData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailsWidget(
            tripData: _tripFormData!,
            customTitle: '${widget.groupName} - Trip Details',
            showEditButton: false,
            isGroupMember: false,
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }

  void _editTripDetails() {
    if (_tripFormData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripFormWidget(
            mode: TripFormMode.edit,
            initialData: _tripFormData,
            isGroupMember: false,
            customTitle: 'Edit ${widget.groupName} Trip',
            onSubmit: (updatedData) {
              setState(() {
                _tripFormData = updatedData;
                _tripDetails = {
                  'destination':
                      updatedData['destination'] ??
                      _tripDetails['destination']!,
                  'startDate':
                      updatedData['startDate'] ?? _tripDetails['startDate']!,
                  'endDate': updatedData['endDate'] ?? _tripDetails['endDate']!,
                  'budget': 'Not specified',
                  'tripType':
                      updatedData['tripType'] ?? _tripDetails['tripType']!,
                };
              });
            },
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }

  // Helper methods
  void _changeGroupImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Group Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption('Camera', Icons.camera_alt, () {
                  Navigator.pop(context);
                  // Implement camera functionality
                }),
                _buildImageOption('Gallery', Icons.photo_library, () {
                  Navigator.pop(context);
                  // Implement gallery functionality
                }),
                _buildImageOption('Default', Icons.landscape, () {
                  Navigator.pop(context);
                  // Set default location-based image
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF0088cc).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15), // Rounded square
            ),
            child: Icon(icon, color: const Color(0xFF0088cc), size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Group details saved successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addMember() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FollowerSelectionSheet(
        tripData: _tripFormData ?? {},
        onSendRequests: (selectedFollowers) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invitations sent to ${selectedFollowers.length} followers!',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _removeMember(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove ${member['name']} from the group?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member['name']} removed from group'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Group'),
        content: const Text(
          'Are you sure you want to delete this group? This action cannot be undone. All trip details and member data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close group details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Group deleted successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _leaveGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Leave Group'),
        content: const Text(
          'Are you sure you want to leave this group? You will lose access to all trip details and group chats.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close group details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have left the group'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
class FollowerSelectionSheet extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final Function(List<Map<String, dynamic>>) onSendRequests;

  const FollowerSelectionSheet({
    super.key,
    required this.tripData,
    required this.onSendRequests,
  });

  @override
  State<FollowerSelectionSheet> createState() => _FollowerSelectionSheetState();
}

class _FollowerSelectionSheetState extends State<FollowerSelectionSheet> {
  List<Map<String, dynamic>> _selectedFollowers = [];

  // Sample Sri Lankan followers data
  final List<Map<String, dynamic>> _followers = [
    {
      'id': 'follower_7',
      'name': 'Tharaka Rathnayake',
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'isOnline': true,
      'location': 'Colombo',
    },
    {
      'id': 'follower_8',
      'name': 'Sanduni Perera',
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
      'isOnline': false,
      'location': 'Galle',
    },
    {
      'id': 'follower_9',
      'name': 'Chaminda Silva',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'isOnline': true,
      'location': 'Kandy',
    },
    {
      'id': 'follower_10',
      'name': 'Malika Fernando',
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'isOnline': false,
      'location': 'Nuwara Eliya',
    },
    {
      'id': 'follower_11',
      'name': 'Dinesh Wickramasinghe',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      'isOnline': true,
      'location': 'Sigiriya',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Add Members to Group',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Text(
            'Select followers to invite to this trip group',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          if (_selectedFollowers.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16), // Rounded square
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, color: Color(0xFF0088cc), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedFollowers.length} followers selected',
                    style: const TextStyle(
                      color: Color(0xFF0088cc),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child: ListView.builder(
              itemCount: _followers.length,
              itemBuilder: (context, index) {
                final follower = _followers[index];
                final isSelected = _selectedFollowers.any(
                  (f) => f['id'] == follower['id'],
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    borderRadius: BorderRadius.circular(16), // Rounded square
                    border: Border.all(
                      color: isSelected ? Colors.blue[200]! : Colors.grey[200]!,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value ?? false) {
                          _selectedFollowers.add(follower);
                        } else {
                          _selectedFollowers.removeWhere(
                            (f) => f['id'] == follower['id'],
                          );
                        }
                      });
                    },
                    activeColor: const Color(0xFF0088cc),
                    title: Row(
                      children: [
                        Stack(
                          children: [
                            // Avatar - Rounded Square
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Rounded square
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.network(
                                  follower['avatar'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (follower['isOnline'])
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            follower['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded square
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedFollowers.isEmpty
                      ? null
                      : () => widget.onSendRequests(_selectedFollowers),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded square
                    ),
                  ),
                  child: Text(
                    _selectedFollowers.isEmpty
                        ? 'Select Followers'
                        : 'Send Invitations (${_selectedFollowers.length})',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}