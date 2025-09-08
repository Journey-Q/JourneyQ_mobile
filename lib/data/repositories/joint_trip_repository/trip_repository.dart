import 'dart:convert';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class TripRepository {
  // CRITICAL FIX: Add request deduplication
  static bool _isCreatingTrip = false;

  // Create trip with duplicate prevention
  static Future<Map<String, dynamic>> createTripFromForm(
    Map<String, dynamic> formData,
  ) async {
    // CRITICAL FIX: Prevent duplicate requests
    if (_isCreatingTrip) {
      throw Exception('Trip creation already in progress');
    }

    _isCreatingTrip = true;
    
    try {
      final requestData = _convertFormDataToBackendFormat(formData);
      print('Sending to backend: $requestData');

      // CRITICAL FIX: Validate data before sending
      _validateRequestData(requestData);

      final response = await ApiService.post(
        '/trips/create',
        data: requestData,
      );

      print('Backend response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        final errorMessage = response.data?['message'] ?? 'Unknown error occurred';
        throw Exception('Backend error: $errorMessage');
      }
    } on AppException catch (e) {
      print('API Error creating trip: $e');
      rethrow;
    } catch (e) {
      print('Error creating trip: $e');
      
      // CRITICAL FIX: Better error categorization
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('Network connection error. Please check your internet connection.');
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Invalid data format. Please check your input.');
      } else {
        throw Exception('Failed to create trip: ${e.toString()}');
      }
    } finally {
      // CRITICAL FIX: Always reset the flag
      _isCreatingTrip = false;
    }
  }

  // CRITICAL FIX: Validate request data
  static void _validateRequestData(Map<String, dynamic> data) {
    if (data['title'] == null || data['title'].toString().trim().isEmpty) {
      throw Exception('Trip title is required');
    }
    if (data['destination'] == null || data['destination'].toString().trim().isEmpty) {
      throw Exception('Destination is required');
    }
    if (data['startDate'] == null || data['startDate'].toString().trim().isEmpty) {
      throw Exception('Start date is required');
    }
    if (data['endDate'] == null || data['endDate'].toString().trim().isEmpty) {
      throw Exception('End date is required');
    }
    if (data['tripType'] == null || data['tripType'].toString().trim().isEmpty) {
      throw Exception('Trip type is required');
    }
  }

  // Get user's created trips
  static Future<List<Map<String, dynamic>>> getUserCreatedTrips() async {
    try {
      final response = await ApiService.get('/trips/my-trips');
      print('Backend response for getUserCreatedTrips: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final tripsData = response.data['data'] as List? ?? [];

        return tripsData
            .map((trip) => _convertBackendToFrontendFormat(trip))
            .toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch trips';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching trips: $e');
      rethrow;
    } catch (e) {
      print('Error fetching trips: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get single trip
  static Future<Map<String, dynamic>> getTripById(int tripId) async {
    try {
      final response = await ApiService.get('/trips/$tripId');

      if (response.data != null && response.data['success'] == true) {
        return _convertBackendToFrontendFormat(response.data['data']);
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch trip';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching trip: $e');
      rethrow;
    } catch (e) {
      print('Error fetching trip: $e');
      throw Exception('Network error: $e');
    }
  }

  // Update trip
  static Future<Map<String, dynamic>> updateTrip(
    int tripId,
    Map<String, dynamic> formData,
  ) async {
    try {
      final requestData = _convertFormDataToBackendFormat(formData);

      final response = await ApiService.put(
        '/trips/$tripId',
        data: requestData,
      );

      if (response.data != null && response.data['success'] == true) {
        return _convertBackendToFrontendFormat(response.data['data']);
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to update trip';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error updating trip: $e');
      rethrow;
    } catch (e) {
      print('Error updating trip: $e');
      throw Exception('Network error: $e');
    }
  }

  // Delete trip
  static Future<void> deleteTrip(int tripId) async {
    try {
      print('Deleting trip with ID: $tripId');

      final response = await ApiService.delete('/trips/$tripId');
      print('Delete response: ${response.data}');

      if (response.data != null) {
        if (response.data['success'] == false) {
          final errorMessage = response.data['message'] ?? 'Unknown error occurred';
          throw Exception('Failed to delete trip: $errorMessage');
        }
      }

      print('Trip deleted successfully');
    } on AppException catch (e) {
      print('API Error deleting trip: $e');
      rethrow;
    } catch (e) {
      print('Error deleting trip: $e');

      if (e.toString().contains('500')) {
        throw Exception('Server error: Unable to delete trip. Please try again later.');
      } else if (e.toString().contains('404')) {
        throw Exception('Trip not found: This trip may have been already deleted.');
      } else if (e.toString().contains('403')) {
        throw Exception('Permission denied: You are not authorized to delete this trip.');
      } else {
        throw Exception('Network error: Unable to connect to server. Please check your internet connection.');
      }
    }
  }

  // Get available trips (for browsing)
  static Future<List<Map<String, dynamic>>> getAvailableTrips() async {
    try {
      final response = await ApiService.get('/trips/available');

      if (response.data != null && response.data['success'] == true) {
        final trips = List<Map<String, dynamic>>.from(response.data['data']);
        return trips
            .map((trip) => _convertBackendToFrontendFormat(trip))
            .toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch available trips';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching available trips: $e');
      rethrow;
    } catch (e) {
      print('Error fetching available trips: $e');
      throw Exception('Network error: $e');
    }
  }

  // Search trips
  static Future<List<Map<String, dynamic>>> searchTrips(String query) async {
    try {
      final response = await ApiService.get(
        '/trips/search',
        queryParameters: {'query': query},
      );

      if (response.data != null && response.data['success'] == true) {
        final trips = List<Map<String, dynamic>>.from(response.data['data']);
        return trips
            .map((trip) => _convertBackendToFrontendFormat(trip))
            .toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to search trips';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error searching trips: $e');
      rethrow;
    } catch (e) {
      print('Error searching trips: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get trips by destination
  static Future<List<Map<String, dynamic>>> getTripsByDestination(
    String destination,
  ) async {
    try {
      final response = await ApiService.get('/trips/destination/$destination');

      if (response.data != null && response.data['success'] == true) {
        final trips = List<Map<String, dynamic>>.from(response.data['data']);
        return trips
            .map((trip) => _convertBackendToFrontendFormat(trip))
            .toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch trips by destination';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching trips by destination: $e');
      rethrow;
    } catch (e) {
      print('Error fetching trips by destination: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get trips by type
  static Future<List<Map<String, dynamic>>> getTripsByType(
    String tripType,
  ) async {
    try {
      final response = await ApiService.get('/trips/type/$tripType');

      if (response.data != null && response.data['success'] == true) {
        final trips = List<Map<String, dynamic>>.from(response.data['data']);
        return trips
            .map((trip) => _convertBackendToFrontendFormat(trip))
            .toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch trips by type';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching trips by type: $e');
      rethrow;
    } catch (e) {
      print('Error fetching trips by type: $e');
      throw Exception('Network error: $e');
    }
  }

  // CRITICAL FIX: Better data conversion with null safety
  static Map<String, dynamic> _convertFormDataToBackendFormat(
    Map<String, dynamic> formData,
  ) {
    return {
      'title': formData['title']?.toString().trim() ?? '',
      'destination': formData['destination']?.toString().trim() ?? '',
      'description': formData['description']?.toString().trim() ?? '',
      'startDate': formData['startDate']?.toString().trim() ?? '',
      'endDate': formData['endDate']?.toString().trim() ?? '',
      'tripType': formData['tripType']?.toString().trim() ?? '',
      'duration': formData['duration']?.toString().trim() ?? '',
      'dayByDayItinerary': _cleanItineraryData(formData['dayByDayItinerary']),
    };
  }

  // CRITICAL FIX: Clean itinerary data
  static List<Map<String, dynamic>> _cleanItineraryData(dynamic itineraryData) {
    if (itineraryData == null || itineraryData is! List) {
      return [];
    }

    return (itineraryData as List).where((day) => day != null).map((day) {
      if (day is Map<String, dynamic>) {
        return {
          'day': day['day'] ?? 1,
          'places': _cleanStringList(day['places']),
          'accommodations': _cleanStringList(day['accommodations']),
          'restaurants': _cleanStringList(day['restaurants']),
          'notes': day['notes']?.toString().trim() ?? '',
        };
      }
      return <String, dynamic>{};
    }).where((day) => day.isNotEmpty).toList();
  }

  // CRITICAL FIX: Clean string lists
  static List<String> _cleanStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .where((item) => item != null)
          .map((item) => item.toString().trim())
          .where((str) => str.isNotEmpty)
          .toList();
    }
    return [];
  }

  // Convert backend response to frontend format
  static Map<String, dynamic> _convertBackendToFrontendFormat(
    Map<String, dynamic> backendData,
  ) {
    return {
      'id': backendData['tripId']?.toString() ?? '',
      'title': backendData['title'] ?? '',
      'destination': backendData['destination'] ?? '',
      'description': backendData['description'] ?? '',
      'startDate': backendData['startDate'] ?? '',
      'endDate': backendData['endDate'] ?? '',
      'duration': backendData['duration'] ?? '',
      'tripType': backendData['tripType'] ?? '',
      'status': backendData['isActive'] == true ? 'Active' : 'Inactive',
      'createdDate': _formatDate(backendData['createdAt']),
      'dayByDayItinerary': _convertItineraryData(backendData['dayByDayItinerary']),
      'userId': backendData['userId'],
      'groupId': backendData['groupId'],
      'isActive': backendData['isActive'],
      'isGroupFormed': backendData['isGroupFormed'],
      'createdAt': backendData['createdAt'],
      'updatedAt': backendData['updatedAt'],
    };
  }

  // Convert itinerary data safely
  static List<Map<String, dynamic>> _convertItineraryData(dynamic itineraryData) {
    if (itineraryData == null || itineraryData is! List) {
      return [];
    }

    return (itineraryData as List).map((day) {
      if (day is Map<String, dynamic>) {
        return {
          'day': day['day'] ?? 1,
          'places': _cleanStringList(day['places']),
          'accommodations': _cleanStringList(day['accommodations']),
          'restaurants': _cleanStringList(day['restaurants']),
          'notes': day['notes']?.toString() ?? '',
        };
      }
      return <String, dynamic>{};
    }).toList();
  }

  static String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}