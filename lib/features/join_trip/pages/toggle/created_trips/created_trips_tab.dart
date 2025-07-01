import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_details_widget.dart';
import 'package:journeyq/features/join_trip/pages/toggle/created_trips/trip_deletion_helper.dart';

class CreatedTripsTab extends StatefulWidget {
  final VoidCallback onCreateTrip;

  const CreatedTripsTab({
    super.key,
    required this.onCreateTrip,
  });

  @override
  State<CreatedTripsTab> createState() => _CreatedTripsTabState();
}

class _CreatedTripsTabState extends State<CreatedTripsTab> {
  @override
  Widget build(BuildContext context) {
    final createdTripForms = SampleData.createdTripForms;

    if (createdTripForms.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: createdTripForms.length,
      itemBuilder: (context, index) {
        final tripForm = createdTripForms[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tripForm['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tripForm['destination']!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'view_details':
                            _viewTripDetails(tripForm);
                            break;
                          case 'edit':
                            _editTripForm(tripForm, index);
                            break;
                          case 'delete':
                            _deleteTripForm(index);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view_details',
                          child: Row(
                            children: [
                              Icon(Icons.info, size: 20),
                              SizedBox(width: 12),
                              Text('View Full Details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 12),
                              Text('Edit Trip Details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Essential Trip Details Only
                _buildDetailRow(Icons.calendar_today, 'Start Date', tripForm['startDate']!),
                _buildDetailRow(Icons.schedule, 'Duration', tripForm['duration'] ?? '14 days'),
                _buildDetailRow(Icons.attach_money, 'Budget', tripForm['budget'] ?? '\$2,500 per person'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_location_alt,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Created Trips Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first trip form and start receiving join requests!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.onCreateTrip,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      'Create Trip',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  // 👁️ VIEW: Use optimized TripDetailsWidget for viewing
  void _viewTripDetails(Map<String, dynamic> tripForm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsWidget(
          tripData: tripForm,
          customTitle: 'Trip Details',
          showEditButton: true, // Show edit button since user created this trip
          onEditPressed: () {
            // Navigate back and then to edit mode
            Navigator.pop(context);
            _editTripForm(tripForm, SampleData.createdTripForms.indexOf(tripForm));
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  // ✏️ EDIT: Use TripFormWidget for editing
  void _editTripForm(Map<String, dynamic> tripForm, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormWidget(
          mode: TripFormMode.edit,
          initialData: tripForm,
          onSubmit: (updatedData) {
            // Update the trip in the list
            setState(() {
              SampleData.createdTripForms[index] = {
                ...tripForm,
                ...updatedData,
              };
            });
          },
        ),
        fullscreenDialog: true,
      ),
    ).then((_) {
      // Refresh the page when returning from edit
      setState(() {});
    });
  }

  // 🗑️ DELETE: Use deletion helper
  void _deleteTripForm(int index) {
    TripDeletionHelper.showDeleteConfirmation(
      context: context,
      tripIndex: index,
      onTripDeleted: () {
        setState(() {});
      },
    );
  }
}