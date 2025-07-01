import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/widget.dart';

class TripDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> tripData;
  final String? customTitle;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  const TripDetailsWidget({
    super.key,
    required this.tripData,
    this.customTitle,
    this.showEditButton = false,
    this.onEditPressed,
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
        actions: showEditButton && onEditPressed != null ? [
          TextButton.icon(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0088cc),
            ),
          ),
          const SizedBox(width: 16),
        ] : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Header Card
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Trip Information Card
            _buildTripInformationCard(),
            const SizedBox(height: 24),

            // Description Card
            _buildDescriptionCard(),
            const SizedBox(height: 24),

            // Activities Card (if has activities)
            if (_hasActivities()) ...[
              _buildActivitiesCard(),
              const SizedBox(height: 24),
            ],

            // Budget & Meeting Card
            _buildBudgetMeetingCard(),
            const SizedBox(height: 32),

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

  Widget _buildTripInformationCard() {
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
          _buildDetailRow('Max Members', '${tripData['maxMembers'] ?? 'Not specified'} people', Icons.people),
          _buildDetailRow('Type', tripData['tripType'] ?? 'Not specified', Icons.category),
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

  Widget _buildBudgetMeetingCard() {
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
            'Budget & Meeting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Budget', tripData['budget'] ?? 'Not specified', Icons.attach_money),
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

  bool _hasActivities() {
    final activities = tripData['activities'];
    return activities != null && activities is List && activities.isNotEmpty;
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