import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/common/trip_form_widget.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/trip_repository.dart';

class CreateTripForm extends StatefulWidget {
  const CreateTripForm({super.key});

  @override
  State<CreateTripForm> createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  bool _isLoading = false;
  bool _isSubmitted = false;

// Replace the _handleTripSubmission method in create_trip_form.dart

Future<void> _handleTripSubmission(Map<String, dynamic> formData) async {
  if (_isLoading || _isSubmitted) {
    print('Request already in progress, ignoring duplicate submission');
    return;
  }

  setState(() {
    _isLoading = true;
    _isSubmitted = true;
  });

  try {
    print('Frontend Data before sending: $formData');
    
    final cleanedData = _cleanFormData(formData);
    print('Cleaned form data: $cleanedData');
    
    _validateRequiredFields(cleanedData);

    final response = await TripRepository.createTripFromForm(cleanedData)
        .timeout(
          const Duration(seconds: 30), 
          onTimeout: () => throw Exception('Request timeout - please try again')
        );
    
    print('Backend Response: $response');
    
    if (mounted) {
      // CRITICAL FIX: Show success message and navigate back immediately
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
              const Text('Trip created successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      
      // CRITICAL FIX: Navigate back immediately with success result
      Navigator.pop(context, true); // Pass true to indicate success
    }
  } catch (e) {
    print('Error creating trip: $e');
    
    setState(() {
      _isSubmitted = false;
    });
    
    if (mounted) {
      String errorMessage = _getErrorMessage(e);
      
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
                  Icons.error,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _isSubmitted = false;
              });
            },
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  Map<String, dynamic> _cleanFormData(Map<String, dynamic> formData) {
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

  List<Map<String, dynamic>> _cleanItineraryData(dynamic itineraryData) {
    if (itineraryData == null || itineraryData is! List) {
      return [];
    }

    List<Map<String, dynamic>> cleanedItinerary = [];
    
    for (var day in itineraryData) {
      if (day is Map<String, dynamic>) {
        cleanedItinerary.add({
          'day': day['day'] ?? 1,
          'places': _cleanStringList(day['places']),
          'accommodations': _cleanStringList(day['accommodations']),
          'restaurants': _cleanStringList(day['restaurants']),
          'notes': day['notes']?.toString().trim() ?? '',
        });
      }
    }
    
    return cleanedItinerary;
  }

  List<String> _cleanStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((item) => item?.toString().trim() ?? '')
          .where((str) => str.isNotEmpty)
          .toList();
    }
    return [];
  }

  void _validateRequiredFields(Map<String, dynamic> formData) {
    if (formData['title']?.toString().isEmpty ?? true) {
      throw Exception('Trip title is required');
    }
    if (formData['destination']?.toString().isEmpty ?? true) {
      throw Exception('Destination is required');
    }
    if (formData['startDate']?.toString().isEmpty ?? true) {
      throw Exception('Start date is required');
    }
    if (formData['endDate']?.toString().isEmpty ?? true) {
      throw Exception('End date is required');
    }
    if (formData['tripType']?.toString().isEmpty ?? true) {
      throw Exception('Trip type is required');
    }
  }

  String _getErrorMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();
    
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please check your internet connection and try again.';
    } else if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorString.contains('500')) {
      return 'Server error occurred. Please try again in a few moments.';
    } else if (errorString.contains('required')) {
      return 'Please fill in all required fields.';
    } else if (errorString.contains('invalid')) {
      return 'Please check your input data and try again.';
    } else {
      return 'Failed to create trip. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TripFormWidget(
          mode: TripFormMode.create,
          isGroupMember: false,
          onSubmit: _handleTripSubmission,
          submitButtonText: _isLoading ? 'Creating...' : 'Create Trip',
        ),
        
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Creating your trip...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please wait, do not close this screen',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}