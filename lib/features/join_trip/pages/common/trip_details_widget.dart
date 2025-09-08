import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/widget.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/day_itinerary_widget.dart';

class TripDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> tripData;
  final String? customTitle;
  final bool showEditButton;
  final bool showSendRequestButton;
  final bool isGroupMember; // New parameter to determine if user is group member
  final VoidCallback? onEditPressed;
  final VoidCallback? onSendRequestPressed;

  const TripDetailsWidget({
    super.key,
    required this.tripData,
    this.customTitle,
    this.showEditButton = false,
    this.showSendRequestButton = false,
    this.isGroupMember = false,
    this.onEditPressed,
    this.onSendRequestPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          customTitle ?? 'Trip Details',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (showEditButton && onEditPressed != null)
            TextButton.icon(
              onPressed: onEditPressed,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0088cc),
              ),
            ),
          if (showSendRequestButton && onSendRequestPressed != null)
            TextButton.icon(
              onPressed: onSendRequestPressed,
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Send Request'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0088cc),
              ),
            ),
          // Only show popup menu if user is group member
          if (isGroupMember)
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit_details',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit Trip Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'send_request',
                  child: Row(
                    children: [
                      Icon(Icons.person_add, size: 18),
                      SizedBox(width: 8),
                      Text('Send Request to Followers'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'view_requests',
                  child: Row(
                    children: [
                      Icon(Icons.pending_actions, size: 18),
                      SizedBox(width: 8),
                      Text('View Pending Requests'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Trip', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Header Card
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Basic Trip Information Card (Always visible)
            _buildBasicTripInformationCard(),
            const SizedBox(height: 24),

            // Description Card (Always visible)
            _buildDescriptionCard(),
            const SizedBox(height: 24),

            // Day-by-Day Itinerary Card (Always visible if exists)
            if (_hasItinerary()) ...[
              _buildItineraryCard(),
              const SizedBox(height: 24),
            ],

            // Advanced Details (Only for group members)
            if (isGroupMember) ...[
              // Group Details Card
              if (_hasGroupDetails()) ...[
                _buildGroupDetailsCard(),
                const SizedBox(height: 24),
              ],

              // Activities Card
              if (_hasActivities()) ...[
                _buildActivitiesCard(),
                const SizedBox(height: 24),
              ],

              // Budget Details Card
              if (_hasBudgetDetails()) ...[
                _buildBudgetDetailsCard(),
                const SizedBox(height: 24),
              ],

              // Meeting Point Card
              if (_hasMeetingPoint()) ...[
                _buildMeetingPointCard(),
                const SizedBox(height: 24),
              ],
            ],

            // Close Button
            buildPrimaryGradientButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
              height: 56,
              gradientColors: const [Color(0xFF0088cc), Color(0xFF00B4DB)],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit_details':
        _editTripDetails(context);
        break;
      case 'send_request':
        _showFollowerSelection(context);
        break;
      case 'view_requests':
        _viewPendingRequests(context);
        break;
      case 'delete':
        _deleteTripConfirmation(context);
        break;
    }
  }

  void _editTripDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormWidget(
          mode: TripFormMode.edit,
          initialData: tripData,
          isGroupMember: isGroupMember,
          customTitle: 'Edit ${tripData['title']}',
          onSubmit: (updatedData) async {
            // Handle trip update
            // Trip updated successfully
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _showFollowerSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FollowerSelectionSheet(
        tripData: tripData,
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

  void _viewPendingRequests(BuildContext context) {
    // Navigate to pending requests view
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pending Requests'),
        content: const Text('View and manage pending join requests for this trip.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteTripConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text('Are you sure you want to delete this trip? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close trip details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip deleted successfully'),
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

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088cc).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tripData['title'] ?? 'Unknown Trip',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tripData['destination'] ?? 'Unknown Destination',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicTripInformationCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
            'Trip Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Start Date', tripData['startDate'] ?? 'Not specified', Icons.calendar_today),
          _buildDetailRow('End Date', tripData['endDate'] ?? 'Not specified', Icons.calendar_month),
          _buildDetailRow('Duration', tripData['duration'] ?? 'Not specified', Icons.schedule),
          _buildDetailRow('Trip Type', tripData['tripType'] ?? 'Not specified', Icons.category),
          if (tripData['status'] != null)
            _buildDetailRow('Status', tripData['status'], Icons.info),
          if (tripData['createdDate'] != null)
            _buildDetailRow('Created', tripData['createdDate'], Icons.schedule),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tripData['description'] ?? 'No description available.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryCard() {
    final itinerary = tripData['dayByDayItinerary'] as List<Map<String, dynamic>>? ?? [];
    final durationText = tripData['duration'] ?? '';
    int totalDays = 0;
    
    // Extract total days from duration
    if (durationText.isNotEmpty) {
      final match = RegExp(r'(\d+)').firstMatch(durationText.toLowerCase());
      if (match != null) {
        totalDays = int.parse(match.group(1)!);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              const Icon(
                Icons.calendar_view_day,
                color: Color(0xFF0088cc),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Day-by-Day Itinerary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (itinerary.isEmpty)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[400], size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'No day-by-day itinerary added',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            DayItineraryWidget(
              initialItinerary: itinerary,
              totalDays: totalDays > 0 ? totalDays : itinerary.length,
              isReadOnly: true,
            ),
        ],
      ),
    );
  }

  Widget _buildGroupDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
            'Group Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          if (tripData['maxMembers'] != null)
            _buildDetailRow('Max Members', '${tripData['maxMembers']} people', Icons.people),
          if (tripData['currentMembers'] != null)
            _buildDetailRow('Current Members', '${tripData['currentMembers']} people', Icons.group),
        ],
      ),
    );
  }

  Widget _buildActivitiesCard() {
    final activities = tripData['activities'] as List<String>? ?? [];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              const Icon(
                Icons.local_activity,
                color: Color(0xFF0088cc),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Activities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088cc).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${activities.length} activities',
                  style: const TextStyle(
                    color: Color(0xFF0088cc),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activities.map((activity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088cc).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0088cc).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getActivityIcon(activity),
                      color: const Color(0xFF0088cc),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      activity,
                      style: const TextStyle(
                        color: Color(0xFF0088cc),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
            'Budget Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          if (tripData['travelBudget'] != null && tripData['travelBudget'].toString().isNotEmpty)
            _buildDetailRow('Travel Budget', '\$${tripData['travelBudget']}', Icons.flight),
          if (tripData['foodBudget'] != null && tripData['foodBudget'].toString().isNotEmpty)
            _buildDetailRow('Food Budget', '\$${tripData['foodBudget']}', Icons.restaurant),
          if (tripData['hotelBudget'] != null && tripData['hotelBudget'].toString().isNotEmpty)
            _buildDetailRow('Hotel Budget', '\$${tripData['hotelBudget']}', Icons.hotel),
          if (tripData['otherBudget'] != null && tripData['otherBudget'].toString().isNotEmpty)
            _buildDetailRow('Other Expenses', '\$${tripData['otherBudget']}', Icons.more_horiz),
          if (_getTotalBudget() > 0) ...[
            const Divider(),
            _buildDetailRow('Total Budget', '\$${_getTotalBudget()}', Icons.attach_money),
          ],
        ],
      ),
    );
  }

  Widget _buildMeetingPointCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
            'Meeting Point',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Meeting Point', tripData['meetingPoint'] ?? 'Not specified', Icons.location_pin),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0088cc).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF0088cc),
            ),
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

  // Helper methods
  bool _hasItinerary() {
    final itinerary = tripData['dayByDayItinerary'];
    return itinerary != null && itinerary is List && itinerary.isNotEmpty;
  }

  bool _hasGroupDetails() {
    return tripData['maxMembers'] != null || tripData['currentMembers'] != null;
  }

  bool _hasActivities() {
    final activities = tripData['activities'];
    return activities != null && activities is List && activities.isNotEmpty;
  }

  bool _hasBudgetDetails() {
    return (tripData['travelBudget'] != null && tripData['travelBudget'].toString().isNotEmpty) ||
           (tripData['foodBudget'] != null && tripData['foodBudget'].toString().isNotEmpty) ||
           (tripData['hotelBudget'] != null && tripData['hotelBudget'].toString().isNotEmpty) ||
           (tripData['otherBudget'] != null && tripData['otherBudget'].toString().isNotEmpty);
  }

  bool _hasMeetingPoint() {
    return tripData['meetingPoint'] != null && tripData['meetingPoint'].toString().isNotEmpty;
  }

  int _getTotalBudget() {
    int total = 0;
    
    if (tripData['travelBudget'] != null) {
      total += int.tryParse(tripData['travelBudget'].toString()) ?? 0;
    }
    if (tripData['foodBudget'] != null) {
      total += int.tryParse(tripData['foodBudget'].toString()) ?? 0;
    }
    if (tripData['hotelBudget'] != null) {
      total += int.tryParse(tripData['hotelBudget'].toString()) ?? 0;
    }
    if (tripData['otherBudget'] != null) {
      total += int.tryParse(tripData['otherBudget'].toString()) ?? 0;
    }
    
    return total;
  }

  IconData _getActivityIcon(String activity) {
    switch (activity.toLowerCase()) {
      case 'hiking':
        return Icons.hiking;
      case 'photography':
        return Icons.camera_alt;
      case 'sightseeing':
        return Icons.visibility;
      case 'food tours':
      case 'food tasting':
        return Icons.restaurant;
      case 'beach activities':
        return Icons.beach_access;
      case 'mountain climbing':
        return Icons.terrain;
      case 'museums':
        return Icons.museum;
      case 'shopping':
        return Icons.shopping_bag;
      case 'nightlife':
        return Icons.nightlife;
      case 'cultural tours':
        return Icons.account_balance;
      case 'wildlife safari':
        return Icons.pets;
      case 'surfing':
        return Icons.surfing;
      case 'spa & wellness':
        return Icons.spa;
      case 'temple visits':
        return Icons.temple_buddhist;
      case 'road trip':
        return Icons.drive_eta;
      case 'cycling':
        return Icons.pedal_bike;
      case 'water sports':
        return Icons.water_drop;
      case 'camping':
        return Icons.forest;
      default:
        return Icons.local_activity;
    }
  }
}

// Follower Selection Sheet Widget (for sending requests from trip details)
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
  
  // Sample followers data
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