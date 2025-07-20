import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_details_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/day_itinerary_widget.dart';

class CreatedTripsTab extends StatefulWidget {
  final VoidCallback onCreateTrip;

  const CreatedTripsTab({super.key, required this.onCreateTrip});

  @override
  State<CreatedTripsTab> createState() => _CreatedTripsTabState();
}

class _CreatedTripsTabState extends State<CreatedTripsTab> {
  @override
  Widget build(BuildContext context) {
    if (SampleData.createdTripForms.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshTrips,
      color: const Color(0xFF0088cc),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.createdTripForms.length,
        itemBuilder: (context, index) {
          final trip = SampleData.createdTripForms[index];
          return _buildTripCard(trip, index);
        },
      ),
    );
  }

  Future<void> _refreshTrips() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location_alt_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Created Trips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start planning your first adventure!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: widget.onCreateTrip,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Create Your First Trip',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088cc),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.luggage,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    trip['title'] ?? 'Unknown Trip',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildDetailRow(
              Icons.calendar_today,
              'Start Date',
              trip['startDate'] ?? 'Not specified',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.schedule,
              'Duration',
              trip['duration'] ?? 'Not specified',
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.visibility,
                    color: Colors.blue,
                    onPressed: () => _viewTripDetails(context, trip),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit,
                    color: Colors.green,
                    onPressed: () => _editTripDetails(context, trip),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.send,
                    color: Colors.orange,
                    onPressed: () => _showFollowerSelection(context, trip),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () => _deleteTripConfirmation(context, trip, index),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _viewTripDetails(BuildContext context, Map<String, dynamic> trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsWidget(
          tripData: trip,
          customTitle: 'Trip Details',
          showEditButton: false,
          showSendRequestButton: false,
          isGroupMember: false,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _editTripDetails(BuildContext context, Map<String, dynamic> trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormWidget(
          mode: TripFormMode.edit,
          initialData: trip,
          isGroupMember: false,
          customTitle: 'Edit ${trip['title']}',
          onSubmit: (updatedData) {
            setState(() {
              final index = SampleData.createdTripForms.indexWhere(
                (t) => t['id'] == trip['id']
              );
              if (index != -1) {
                SampleData.createdTripForms[index] = updatedData;
              }
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _showFollowerSelection(BuildContext context, Map<String, dynamic> trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FollowerSelectionSheet(
        tripData: trip,
        onSendRequests: (selectedFollowers) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Requests sent to ${selectedFollowers.length} followers!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _deleteTripConfirmation(BuildContext context, Map<String, dynamic> trip, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Delete Trip',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${trip['title']}"?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone. All trip data will be permanently removed.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                SampleData.createdTripForms.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${trip['title']} deleted successfully'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Follower Selection Sheet Widget
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
  
  final List<Map<String, dynamic>> _followers = [
    {
      'id': 'follower_1',
      'name': 'Alex Johnson',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'isOnline': true,
    },
    {
      'id': 'follower_2',
      'name': 'Maria Rodriguez',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isOnline': false,
    },
    {
      'id': 'follower_3',
      'name': 'John Smith',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'isOnline': true,
    },
    {
      'id': 'follower_4',
      'name': 'Emma Wilson',
      'avatar': 'https://i.pravatar.cc/150?img=16',
      'isOnline': false,
    },
    {
      'id': 'follower_5',
      'name': 'Sarah Lee',
      'avatar': 'https://i.pravatar.cc/150?img=15',
      'isOnline': true,
    },
    {
      'id': 'follower_6',
      'name': 'Mike Chen',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'isOnline': false,
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
            'Send Trip Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Select followers to invite for "${widget.tripData['title']}"',
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
                        : 'Send Requests (${_selectedFollowers.length})',
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