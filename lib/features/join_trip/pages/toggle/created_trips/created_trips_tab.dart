import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_details_widget.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/trip_repository.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/follow_repository.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/trip_request_repository.dart';

class CreatedTripsTab extends StatefulWidget {
  final VoidCallback? onCreateTrip;
  
  const CreatedTripsTab({super.key, this.onCreateTrip});

  @override
  State<CreatedTripsTab> createState() => CreatedTripsTabState();
}

class CreatedTripsTabState extends State<CreatedTripsTab>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> _createdTrips = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCreatedTrips();
  }

  Future<void> _loadCreatedTrips() async {
    if (_isLoading) {
      print('Already loading trips, skipping duplicate request');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Loading user created trips...');
      
      final trips = await TripRepository.getUserCreatedTrips()
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout - please try again')
          );
      
      if (mounted) {
        setState(() {
          _createdTrips = trips;
          _isLoading = false;
          _hasInitialized = true;
        });
        
        print('Loaded ${trips.length} trips for user');
      }
    } catch (e) {
      print('Error loading trips: $e');
      if (mounted) {
        setState(() {
          _createdTrips = [];
          _isLoading = false;
          _hasInitialized = true;
          _errorMessage = _getErrorMessage(e);
        });
      }
    }
  }

  Future<void> refreshTrips() async {
    print('🔄 Manually refreshing trips from external call...');
    await _loadCreatedTrips();
    print('✅ Manual refresh completed');
  }

  String _getErrorMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();
    
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please check your internet connection and try again.';
    } else if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorString.contains('500')) {
      return 'Server error occurred. Please try again in a few moments.';
    } else {
      return 'Failed to load trips: ${error.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && !_hasInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your trips...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCreatedTrips,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
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
      );
    }

    if (_createdTrips.isEmpty && _hasInitialized) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadCreatedTrips,
      child: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _createdTrips.length,
            itemBuilder: (context, index) {
              return _buildTripCard(_createdTrips[index]);
            },
          ),
          if (_isLoading && _hasInitialized)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                child: const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No trips created yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first trip to get started!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          if (widget.onCreateTrip != null)
            ElevatedButton.icon(
              onPressed: widget.onCreateTrip,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Create Trip', style: TextStyle(color: Colors.white)),
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
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088cc).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.luggage,
                        color: Color(0xFF0088cc),
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
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: trip['status'] == 'Active' 
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        trip['status'] ?? 'Draft',
                        style: TextStyle(
                          color: trip['status'] == 'Active' ? Colors.green : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Destination: ${trip['destination'] ?? 'TBD'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Start: ${trip['startDate'] ?? 'TBD'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Duration: ${trip['duration'] ?? 'TBD'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: Colors.grey[200]),
          
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.visibility,
                    label: 'View',
                    color: Colors.blue,
                    onTap: () => _viewTripDetails(trip),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    color: Colors.green,
                    onTap: () => _editTrip(trip),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.send,
                    label: 'Send',
                    color: Colors.orange,
                    onTap: () => _sendTripRequest(trip),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.delete,
                    label: 'Delete',
                    color: Colors.red,
                    onTap: () => _deleteTrip(trip),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendTripRequest(Map<String, dynamic> trip) async {
    try {
      // Show loading dialog while fetching followers
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
          ),
        ),
      );

      // Fetch the list of people the user follows
      final following = await FollowRepository.getMyFollowing(page: 0, size: 100);

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (following.isEmpty) {
        // No followers to send to
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are not following anyone yet. Follow users to send trip requests.'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Show dialog with follower selection
      if (mounted) {
        _showFollowerSelectionDialog(trip, following);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }

      print('Error fetching followers: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load followers: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _sendTripRequest(trip),
            ),
          ),
        );
      }
    }
  }

  void _showFollowerSelectionDialog(
    Map<String, dynamic> trip,
    List<Map<String, dynamic>> following,
  ) {
    // Track selected followers
    Set<String> selectedFollowers = {};

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.send, color: Color(0xFF0088cc)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Send "${trip['title']}"',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select followers to send this trip request:',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: following.isEmpty
                        ? const Center(
                            child: Text(
                              'No followers found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: following.length,
                            itemBuilder: (context, index) {
                              final follower = following[index];
                              final userId = follower['userId'] ?? '';
                              final isSelected = selectedFollowers.contains(userId);

                              return CheckboxListTile(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedFollowers.add(userId);
                                    } else {
                                      selectedFollowers.remove(userId);
                                    }
                                  });
                                },
                                title: Text(
                                  follower['displayName'] ?? 'Unknown User',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                secondary: CircleAvatar(
                                  backgroundColor: const Color(0xFF0088cc).withOpacity(0.1),
                                  backgroundImage: follower['profileImageUrl'] != null &&
                                          follower['profileImageUrl'].toString().isNotEmpty
                                      ? NetworkImage(follower['profileImageUrl'])
                                      : null,
                                  child: follower['profileImageUrl'] == null ||
                                          follower['profileImageUrl'].toString().isEmpty
                                      ? Text(
                                          (follower['displayName'] ?? 'U')[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF0088cc),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                activeColor: const Color(0xFF0088cc),
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  if (selectedFollowers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088cc).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${selectedFollowers.length} follower(s) selected',
                        style: const TextStyle(
                          color: Color(0xFF0088cc),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton.icon(
                onPressed: selectedFollowers.isEmpty
                    ? null
                    : () async {
                        Navigator.pop(dialogContext); // Close selection dialog

                        // Show loading with context reference
                        final scaffoldContext = context;
                        bool isLoadingDialogOpen = true;
                        
                        showDialog(
                          context: scaffoldContext,
                          barrierDismissible: false,
                          builder: (loadingContext) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
                            ),
                          ),
                        );

                        try {
                          print('Starting trip request send process...');
                          
                          // Convert string IDs to integers
                          final List<int> receiverIds = selectedFollowers
                              .map((id) => int.tryParse(id) ?? 0)
                              .where((id) => id > 0)
                              .toList();

                          print('Receiver IDs: $receiverIds');

                          // Get trip ID
                          final tripId = int.tryParse(trip['id']?.toString() ?? '');
                          
                          if (tripId == null || tripId == 0) {
                            throw Exception('Invalid trip ID: ${trip['id']}');
                          }

                          print('Trip ID: $tripId');

                          // Generate group ID (same as trip ID)
                          final groupId = tripId;
                          print('Group ID: $groupId');

                          // Send trip requests via API with timeout
                          final result = await TripRequestRepository.sendTripRequests(
                            tripId: tripId,
                            groupId: groupId,
                            receiverIds: receiverIds,
                          ).timeout(
                            const Duration(seconds: 30),
                            onTimeout: () => throw Exception('Request timeout - please try again'),
                          );

                          print('Trip request sent successfully: $result');

                          // Close loading dialog
                          if (mounted && isLoadingDialogOpen) {
                            Navigator.of(scaffoldContext).pop();
                            isLoadingDialogOpen = false;
                          }

                          // Show success message
                          if (mounted) {
                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Trip request sent to ${selectedFollowers.length} follower(s)!',
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error sending trip request: $e');
                          
                          // Close loading dialog if still open
                          if (mounted && isLoadingDialogOpen) {
                            try {
                              Navigator.of(scaffoldContext).pop();
                              isLoadingDialogOpen = false;
                            } catch (navError) {
                              print('Error closing loading dialog: $navError');
                            }
                          }

                          // Show error message
                          if (mounted) {
                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                              SnackBar(
                                content: Text('Failed to send trip requests: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      },
                icon: const Icon(Icons.send, size: 18, color: Colors.white),
                label: const Text('Send', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088cc),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _viewTripDetails(Map<String, dynamic> trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsWidget(
          tripData: trip,
          customTitle: trip['title'],
          isGroupMember: true,
        ),
      ),
    );
  }

  void _editTrip(Map<String, dynamic> trip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripFormWidget(
          mode: TripFormMode.edit,
          initialData: trip,
          isGroupMember: true,
          customTitle: 'Edit ${trip['title']}',
          onSubmit: (updatedData) async {
            try {
              final tripId = int.parse(trip['id'].toString());
              await TripRepository.updateTrip(tripId, updatedData);
            } catch (e) {
              throw Exception('Failed to update trip: $e');
            }
          },
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == true || result == null) {
      await refreshTrips();
    }
  }

  void _deleteTrip(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final dialogContext = context;
              final scaffoldContext = this.context;
              
              Navigator.pop(dialogContext);
              
              if (mounted) {
                showDialog(
                  context: scaffoldContext,
                  barrierDismissible: false,
                  builder: (loadingContext) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
                    ),
                  ),
                );
              }
              
              try {
                final tripIdStr = trip['id']?.toString();
                if (tripIdStr == null || tripIdStr.isEmpty) {
                  throw Exception('Invalid trip ID');
                }
                
                final tripId = int.tryParse(tripIdStr);
                if (tripId == null) {
                  throw Exception('Invalid trip ID format: $tripIdStr');
                }
                
                print('🗑️ Deleting trip with ID: $tripId');
                
                await TripRepository.deleteTrip(tripId);
                
                if (mounted) {
                  Navigator.pop(scaffoldContext);
                }
                
                if (mounted) {
                  setState(() {
                    _createdTrips.removeWhere((t) => t['id'].toString() == tripIdStr);
                  });
                }
                
                if (mounted) {
                  Future.delayed(const Duration(milliseconds: 100), () async {
                    if (mounted) {
                      await _loadCreatedTrips();
                    }
                  });
                }
                
                if (mounted) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text('Trip deleted successfully'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  try {
                    Navigator.pop(scaffoldContext);
                  } catch (navError) {
                    print('Loading dialog already closed: $navError');
                  }
                }
                
                print('❌ Error deleting trip: $e');
                
                if (mounted) {
                  String errorMessage = _getErrorMessage(e);
                  
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () => _deleteTrip(trip),
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}