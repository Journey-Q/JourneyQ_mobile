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
      // Convert group data to trip form format with all member-accessible fields
      _tripFormData = {
        'title': groupData['title'] ?? widget.groupName,
        'destination': _tripDetails['destination'],
        'startDate': _tripDetails['startDate'],
        'endDate': _tripDetails['endDate'],
        'tripType': _tripDetails['tripType'],
        'description': widget.description,
        'duration': groupData['duration'] ?? '7 days',
        'maxMembers': widget.members.length,
        'currentMembers': widget.members.length,
        'meetingPoint': 'TBD',
        'activities': <String>[],
        'travelBudget': '',
        'foodBudget': '',
        'hotelBudget': '',
        'otherBudget': '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isCreator ? 'Manage Group' : 'Group Details',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.isCreator)
            TextButton(
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
                  color: Color(0xFF0088cc),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Profile Section
            _buildGroupProfileSection(),
            const SizedBox(height: 24),
            
            // Trip Details Section with View/Edit (Now accessible to all members)
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
    );
  }

  Widget _buildGroupProfileSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.groupImage),
              ),
              if (widget.isCreator && _isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeGroupImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0088cc),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing && widget.isCreator)
            TextField(
              controller: _groupNameController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Group Name',
              ),
            )
          else
            Text(
              widget.groupName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
        borderRadius: BorderRadius.circular(16),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _viewTripDetails,
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0088cc),
                    ),
                  ),
                  // All group members can edit trip details now
                  TextButton.icon(
                    onPressed: _editTripDetails,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0088cc),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Destination', _tripDetails['destination']!),
          _buildDetailRow('Start Date', _tripDetails['startDate']!),
          _buildDetailRow('End Date', _tripDetails['endDate']!),
          _buildDetailRow('Budget', _tripDetails['budget']!),
          _buildDetailRow('Trip Type', _tripDetails['tripType']!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
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
        borderRadius: BorderRadius.circular(16),
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
                TextButton.icon(
                  onPressed: _addMember,
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0088cc),
                  ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(member['avatar']),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  member['role'] ?? 'Member',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isCreator && member['id'] != 'current_user')
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'remove') {
                  _removeMember(member);
                } else if (value == 'admin') {
                  _makeAdmin(member);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'admin',
                  child: Text('Make Admin'),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove from Group'),
                ),
              ],
              child: const Icon(Icons.more_vert, color: Colors.grey),
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
        borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          onTap: widget.isCreator ? _deleteGroup : _leaveGroup,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isCreator ? Icons.delete : Icons.exit_to_app,
                  color: Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.isCreator ? 'Delete Group' : 'Leave',
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
            isGroupMember: true, // All group members can see advanced details
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
            isGroupMember: true, // Show all advanced options for group members
            customTitle: 'Edit ${widget.groupName} Trip',
            onSubmit: (updatedData) {
              setState(() {
                _tripFormData = updatedData;
                // Update trip details for display
                _tripDetails = {
                  'destination': updatedData['destination'] ?? _tripDetails['destination']!,
                  'startDate': updatedData['startDate'] ?? _tripDetails['startDate']!,
                  'endDate': updatedData['endDate'] ?? _tripDetails['endDate']!,
                  'budget': _calculateDisplayBudget(updatedData),
                  'tripType': updatedData['tripType'] ?? _tripDetails['tripType']!,
                };
              });
            },
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }

  String _calculateDisplayBudget(Map<String, dynamic> data) {
    int total = 0;
    
    if (data['travelBudget'] != null && data['travelBudget'].toString().isNotEmpty) {
      total += int.tryParse(data['travelBudget'].toString()) ?? 0;
    }
    if (data['foodBudget'] != null && data['foodBudget'].toString().isNotEmpty) {
      total += int.tryParse(data['foodBudget'].toString()) ?? 0;
    }
    if (data['hotelBudget'] != null && data['hotelBudget'].toString().isNotEmpty) {
      total += int.tryParse(data['hotelBudget'].toString()) ?? 0;
    }
    if (data['otherBudget'] != null && data['otherBudget'].toString().isNotEmpty) {
      total += int.tryParse(data['otherBudget'].toString()) ?? 0;
    }
    
    return total > 0 ? '\${total} total' : 'Not specified';
  }

  // Helper methods
  void _changeGroupImage() {
    print('Change group image');
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });
    print('Saving changes...');
  }

  void _addMember() {
    // Show follower selection for adding members
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
              content: Text('Invitations sent to ${selectedFollowers.length} followers!'),
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
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member['name']} from the group?'),
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

  void _makeAdmin(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Admin'),
        content: Text('Make ${member['name']} an admin of this group?'),
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
                  content: Text('${member['name']} is now an admin'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Make Admin'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group? This action cannot be undone. All trip details and member data will be lost.'),
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
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave this group? You will lose access to all trip details and group chats.'),
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

// Follower Selection Sheet Widget (for adding members to group)
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
  
  // Sample followers data (excluding current group members)
  final List<Map<String, dynamic>> _followers = [
    {
      'id': 'follower_7',
      'name': 'David Kim',
      'avatar': 'https://i.pravatar.cc/150?img=18',
      'isOnline': true,
    },
    {
      'id': 'follower_8',
      'name': 'Anna White',
      'avatar': 'https://i.pravatar.cc/150?img=20',
      'isOnline': false,
    },
    {
      'id': 'follower_9',
      'name': 'Tom Brown',
      'avatar': 'https://i.pravatar.cc/150?img=22',
      'isOnline': true,
    },
    {
      'id': 'follower_10',
      'name': 'Lisa Park',
      'avatar': 'https://i.pravatar.cc/150?img=14',
      'isOnline': false,
    },
    {
      'id': 'follower_11',
      'name': 'James Wilson',
      'avatar': 'https://i.pravatar.cc/150?img=25',
      'isOnline': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Select followers to invite to this trip group',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          if (_selectedFollowers.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Color(0xFF0088cc),
                    size: 20,
                  ),
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
                final isSelected = _selectedFollowers.any((f) => f['id'] == follower['id']);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                          _selectedFollowers.removeWhere((f) => f['id'] == follower['id']);
                        }
                      });
                    },
                    activeColor: const Color(0xFF0088cc),
                    title: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(follower['avatar']),
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
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                follower['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                follower['isOnline'] ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: follower['isOnline'] ? Colors.green : Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
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