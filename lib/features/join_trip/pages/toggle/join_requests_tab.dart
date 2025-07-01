import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_details_widget.dart';

class JoinRequestsTab extends StatefulWidget {
  const JoinRequestsTab({super.key});

  @override
  State<JoinRequestsTab> createState() => _JoinRequestsTabState();
}

class _JoinRequestsTabState extends State<JoinRequestsTab> {
  bool _showReceivedRequests = true; // true = Received, false = Sent

  @override
  Widget build(BuildContext context) {
    final receivedRequests = SampleData.pendingRequests; // Requests to my groups
    final sentRequests = SampleData.sentRequests; // My requests to other groups
    
    return Column(
      children: [
        // Toggle Section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                  onTap: () => setState(() => _showReceivedRequests = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: _showReceivedRequests 
                        ? const LinearGradient(colors: [Color(0xFF0088cc), Color(0xFF00B4DB)])
                        : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          color: _showReceivedRequests ? Colors.white : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Received (${receivedRequests.length})',
                          style: TextStyle(
                            color: _showReceivedRequests ? Colors.white : Colors.grey[600],
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
                  onTap: () => setState(() => _showReceivedRequests = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: !_showReceivedRequests 
                        ? const LinearGradient(colors: [Color(0xFF0088cc), Color(0xFF00B4DB)])
                        : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send,
                          color: !_showReceivedRequests ? Colors.white : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sent (${sentRequests.length})',
                          style: TextStyle(
                            color: !_showReceivedRequests ? Colors.white : Colors.grey[600],
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

        // Requests List
        Expanded(
          child: _showReceivedRequests
              ? _buildReceivedRequestsList(receivedRequests)
              : _buildSentRequestsList(sentRequests),
        ),
      ],
    );
  }

  Widget _buildReceivedRequestsList(List<Map<String, dynamic>> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState('No Received Requests', 
          'When people request to join your trips, they\'ll appear here.');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
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
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(request['userImage']!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Highlighted "Wants to join" message
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Wants to join ${request['trip']}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.grey[600]),
                      onPressed: () => _showTripDetails(request['trip']!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Color(0xFF4CAF50)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _acceptRequest(index),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _rejectRequest(index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close, color: Colors.red[600], size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Decline',
                                    style: TextStyle(
                                      color: Colors.red[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentRequestsList(List<Map<String, dynamic>> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState('No Sent Requests', 
          'Your requests to join other trips will appear here.');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(request['tripImage']!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['tripName']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Highlighted "Request sent to" message
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Request sent to ${request['creatorName']}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(request['status']!).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              request['status']!,
                              style: TextStyle(
                                color: _getStatusColor(request['status']!),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            request['sentTime']!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (request['status'] == 'Pending')
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'cancel') {
                        _cancelRequest(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel Request'),
                      ),
                    ],
                    child: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
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
                Icons.person_add,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _acceptRequest(int index) {
    setState(() {
      SampleData.pendingRequests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request accepted!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectRequest(int index) {
    setState(() {
      SampleData.pendingRequests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request declined'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _cancelRequest(int index) {
    setState(() {
      SampleData.sentRequests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request cancelled'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showTripDetails(String tripName) {
    // Find trip data by name from createdTripForms
    Map<String, dynamic>? tripData;
    
    for (var trip in SampleData.createdTripForms) {
      if (trip['title'] == tripName) {
        tripData = trip;
        break;
      }
    }
    
    if (tripData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailsWidget(
            tripData: tripData!,
            customTitle: 'Trip Details',
            showEditButton: false, // Read-only for join requests
          ),
          fullscreenDialog: true,
        ),
      );
    } else {
      // Show a fallback if trip data not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip details not available'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(request['userImage']!),
              ),
              const SizedBox(height: 16),
              Text(
                request['name']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                request['email']!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Trip', request['trip']!),
              _buildDetailRow('Experience', request['experience']!),
              _buildDetailRow('Age', '${request['age']} years old'),
              _buildDetailRow('Request sent', request['requestTimestamp']!),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}