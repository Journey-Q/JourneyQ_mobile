import 'dart:convert';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class TripRequestRepository {
  // Send trip requests to followers
  static Future<Map<String, dynamic>> sendTripRequests({
    required int tripId,
    required int groupId,
    required List<int> receiverIds,
  }) async {
    try {
      print('Sending trip request for trip $tripId (group $groupId) to users: $receiverIds');

      final response = await ApiService.post(
        '/trip-requests/send',
        data: {
          'tripId': tripId,
          'groupId': groupId,
          'receiverIds': receiverIds,
        },
      );

      print('Backend response for sendTripRequests: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Trip requests sent successfully',
          'count': response.data['count'] ?? 0,
          'data': response.data['data'] ?? [],
        };
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to send trip requests';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error sending trip requests: $e');
      rethrow;
    } catch (e) {
      print('Error sending trip requests: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get received trip requests (requests sent to current user)
  static Future<List<Map<String, dynamic>>> getReceivedRequests() async {
    try {
      final response = await ApiService.get('/trip-requests/received');

      print('Backend response for getReceivedRequests: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final requestsList = response.data['data'] as List? ?? [];

        return requestsList.map<Map<String, dynamic>>((request) {
          return {
            'requestId': request['requestId'],
            'tripId': request['tripId'],
            'tripTitle': request['tripTitle'] ?? 'Unknown Trip',
            'tripDestination': request['tripDestination'] ?? '',
            'senderId': request['senderId'],
            'senderName': request['senderName'] ?? 'Unknown User',
            'receiverId': request['receiverId'],
            'receiverName': request['receiverName'] ?? '',
            'requestStatus': request['requestStatus'] ?? 'PENDING',
            'createdAt': request['createdAt'] ?? '',
            'respondedAt': request['respondedAt'],
          };
        }).toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch received requests';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching received requests: $e');
      rethrow;
    } catch (e) {
      print('Error fetching received requests: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get sent trip requests (requests sent by current user)
  static Future<List<Map<String, dynamic>>> getSentRequests() async {
    try {
      final response = await ApiService.get('/trip-requests/sent');

      print('Backend response for getSentRequests: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final requestsList = response.data['data'] as List? ?? [];

        return requestsList.map<Map<String, dynamic>>((request) {
          return {
            'requestId': request['requestId'],
            'tripId': request['tripId'],
            'tripTitle': request['tripTitle'] ?? 'Unknown Trip',
            'tripDestination': request['tripDestination'] ?? '',
            'senderId': request['senderId'],
            'senderName': request['senderName'] ?? '',
            'receiverId': request['receiverId'],
            'receiverName': request['receiverName'] ?? 'Unknown User',
            'requestStatus': request['requestStatus'] ?? 'PENDING',
            'createdAt': request['createdAt'] ?? '',
            'respondedAt': request['respondedAt'],
          };
        }).toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch sent requests';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching sent requests: $e');
      rethrow;
    } catch (e) {
      print('Error fetching sent requests: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get pending requests
  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      final response = await ApiService.get('/trip-requests/pending');

      print('Backend response for getPendingRequests: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final requestsList = response.data['data'] as List? ?? [];

        return requestsList.map<Map<String, dynamic>>((request) {
          return {
            'requestId': request['requestId'],
            'tripId': request['tripId'],
            'tripTitle': request['tripTitle'] ?? 'Unknown Trip',
            'tripDestination': request['tripDestination'] ?? '',
            'senderId': request['senderId'],
            'senderName': request['senderName'] ?? '',
            'receiverId': request['receiverId'],
            'receiverName': request['receiverName'] ?? '',
            'requestStatus': request['requestStatus'] ?? 'PENDING',
            'createdAt': request['createdAt'] ?? '',
            'respondedAt': request['respondedAt'],
          };
        }).toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch pending requests';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching pending requests: $e');
      rethrow;
    } catch (e) {
      print('Error fetching pending requests: $e');
      throw Exception('Network error: $e');
    }
  }

  // Accept trip request
  static Future<Map<String, dynamic>> acceptRequest(int requestId) async {
    try {
      print('Accepting trip request: $requestId');

      final response = await ApiService.put('/trip-requests/$requestId/accept');

      print('Backend response for acceptRequest: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Request accepted successfully',
          'data': response.data['data'],
        };
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to accept request';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error accepting request: $e');
      rethrow;
    } catch (e) {
      print('Error accepting request: $e');
      throw Exception('Network error: $e');
    }
  }

  // Reject trip request
  static Future<Map<String, dynamic>> rejectRequest(int requestId) async {
    try {
      print('Rejecting trip request: $requestId');

      final response = await ApiService.put('/trip-requests/$requestId/reject');

      print('Backend response for rejectRequest: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Request rejected successfully',
          'data': response.data['data'],
        };
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to reject request';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error rejecting request: $e');
      rethrow;
    } catch (e) {
      print('Error rejecting request: $e');
      throw Exception('Network error: $e');
    }
  }

  // Cancel trip request (sender cancels their own request)
  static Future<void> cancelRequest(int requestId) async {
    try {
      print('Cancelling trip request: $requestId');

      final response = await ApiService.delete('/trip-requests/$requestId/cancel');

      print('Backend response for cancelRequest: ${response.data}');

      if (response.data != null && response.data['success'] == false) {
        final errorMessage = response.data['message'] ?? 'Failed to cancel request';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error cancelling request: $e');
      rethrow;
    } catch (e) {
      print('Error cancelling request: $e');
      throw Exception('Network error: $e');
    }
  }
}