// File: lib/features/marketplace/repositories/booking_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// Models - Updated to exactly match Java DTO
class CardDetailsDTO {
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String billingAddress;

  CardDetailsDTO({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.billingAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'billingAddress': billingAddress,
    };
  }
}

class CreateRoomBookingDTO {
  final int roomId;
  final int userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String specialRequests;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final CardDetailsDTO cardDetails;

  CreateRoomBookingDTO({
    required this.roomId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.specialRequests,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.cardDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'specialRequests': specialRequests,
      'checkInDate': checkInDate.toIso8601String().split('T')[0],
      'checkOutDate': checkOutDate.toIso8601String().split('T')[0],
      'numberOfGuests': numberOfGuests,
      'cardDetails': cardDetails.toJson(),
    };
  }
}

class BookingResponse {
  final String bookingId;
  final String status;
  final String message;
  final DateTime bookedDate;

  BookingResponse({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.bookedDate,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookingId: json['bookingId'] ?? json['id'] ?? 'BK-${DateTime.now().millisecondsSinceEpoch}',
      status: json['status'] ?? 'CONFIRMED',
      message: json['message'] ?? 'Booking created successfully',
      bookedDate: DateTime.parse(json['bookedDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class BookingHistory {
  final String bookingId;
  final String type;
  final String serviceName;
  final String? roomType;
  final String? roomNumber;
  final String guestName;
  final String email;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? serviceDate;
  final int guests;
  final int? nights;
  final String? duration;
  final double amount;
  final String currency;
  final String status;
  final DateTime bookedDate;
  final String? image;
  final bool hasReview;
  final double? rating;
  final String? review;
  final String? description;
  final String? service;

  BookingHistory({
    required this.bookingId,
    required this.type,
    required this.serviceName,
    this.roomType,
    this.roomNumber,
    required this.guestName,
    required this.email,
    this.checkIn,
    this.checkOut,
    this.startDate,
    this.endDate,
    this.serviceDate,
    required this.guests,
    this.nights,
    this.duration,
    required this.amount,
    required this.currency,
    required this.status,
    required this.bookedDate,
    this.image,
    this.hasReview = false,
    this.rating,
    this.review,
    this.description,
    this.service,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      bookingId: json['bookingId'] ?? json['id'] ?? '',
      type: json['type'] ?? 'Hotel',
      serviceName: json['serviceName'] ?? json['hotelName'] ?? 'Unknown Service',
      roomType: json['roomType'],
      roomNumber: json['roomNumber'],
      guestName: json['guestName'] ?? '',
      email: json['email'] ?? json['guestEmail'] ?? '',
      checkIn: json['checkIn'] != null ? DateTime.parse(json['checkIn']) : null,
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      serviceDate: json['serviceDate'] != null ? DateTime.parse(json['serviceDate']) : null,
      guests: json['guests'] ?? json['numberOfGuests'] ?? 1,
      nights: json['nights'],
      duration: json['duration'],
      amount: (json['amount'] ?? json['totalAmount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'LKR',
      status: _mapStatus(json['status']),
      bookedDate: DateTime.parse(json['bookedDate'] ?? DateTime.now().toIso8601String()),
      image: json['image'],
      hasReview: json['hasReview'] ?? false,
      rating: json['rating']?.toDouble(),
      review: json['review'],
      description: json['description'],
      service: json['service'],
    );
  }

  static String _mapStatus(String? status) {
    if (status == null) return 'Pending';

    switch (status.toUpperCase()) {
      case 'CONFIRMED':
      case 'ACTIVE':
        return 'Confirmed';
      case 'COMPLETED':
      case 'FINISHED':
        return 'Completed';
      case 'CANCELLED':
      case 'CANCELED':
        return 'Cancelled';
      case 'PENDING':
        return 'Pending';
      default:
        return 'Pending';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'type': type,
      'serviceName': serviceName,
      'roomType': roomType,
      'roomNumber': roomNumber,
      'guestName': guestName,
      'email': email,
      'checkIn': checkIn?.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'serviceDate': serviceDate?.toIso8601String(),
      'guests': guests,
      'nights': nights,
      'duration': duration,
      'amount': amount,
      'currency': currency,
      'status': status,
      'bookedDate': bookedDate.toIso8601String(),
      'image': image,
      'hasReview': hasReview,
      'rating': rating,
      'review': review,
      'description': description,
      'service': service,
    };
  }
}

class ReviewRequest {
  final String bookingId;
  final double rating;
  final String review;

  ReviewRequest({
    required this.bookingId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'rating': rating,
      'review': review,
    };
  }
}

// Repository
class BookingRepository {
  static const String _baseUrl = 'https://your-deployed-backend.com/api'; // Replace with your deployed backend URL

  final http.Client client;
  final String? authToken;

  BookingRepository({http.Client? client, this.authToken})
      : client = client ?? http.Client();

  // Headers for authenticated requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  // Create a new room booking - Updated to exactly match Java DTO
  Future<BookingResponse> createRoomBooking(CreateRoomBookingDTO bookingData) async {
    try {
      print('Sending booking request: ${jsonEncode(bookingData.toJson())}');

      final response = await client.post(
        Uri.parse('$_baseUrl/bookings/room'),
        headers: _headers,
        body: jsonEncode(bookingData.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return BookingResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to create booking: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Booking creation error: $e');
      }
      rethrow;
    }
  }

  // Get booking history for a user
  Future<List<BookingHistory>> getBookingHistory({String? userId}) async {
    try {
      final endpoint = userId != null
          ? '$_baseUrl/bookings/history?userId=$userId'
          : '$_baseUrl/bookings/history';

      final response = await client.get(
        Uri.parse(endpoint),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => BookingHistory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch booking history: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Booking history fetch error: $e');
      }
      rethrow;
    }
  }

  // Get booking by ID
  Future<BookingHistory> getBookingById(String bookingId) async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/bookings/$bookingId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return BookingHistory.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch booking: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Booking fetch error: $e');
      }
      throw Exception('Failed to fetch booking: $e');
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      final response = await client.put(
        Uri.parse('$_baseUrl/bookings/$bookingId/cancel'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to cancel booking: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Booking cancellation error: $e');
      }
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Submit a review for a completed booking
  Future<void> submitReview(ReviewRequest reviewRequest) async {
    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/bookings/review'),
        headers: _headers,
        body: jsonEncode(reviewRequest.toJson()),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to submit review: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Review submission error: $e');
      }
      throw Exception('Failed to submit review: $e');
    }
  }

  // Helper method to create booking from form data - Updated to match Java DTO exactly
  CreateRoomBookingDTO createBookingData({
    required int roomId,
    required int userId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String specialRequests,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfGuests,
    required CardDetailsDTO cardDetails,
  }) {
    return CreateRoomBookingDTO(
      roomId: roomId,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      specialRequests: specialRequests,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      numberOfGuests: numberOfGuests,
      cardDetails: cardDetails,
    );
  }

  void dispose() {
    client.close();
  }
}

// Provider for state management
class BookingProvider with ChangeNotifier {
  final BookingRepository _repository;
  List<BookingHistory> _bookings = [];
  bool _isLoading = false;
  String? _error;

  BookingProvider(this._repository);

  List<BookingHistory> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create booking and refresh history
  Future<BookingResponse> createBooking(CreateRoomBookingDTO bookingData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.createRoomBooking(bookingData);

      // Refresh booking history after successful booking
      await _loadBookingHistory();

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Load booking history
  Future<void> _loadBookingHistory() async {
    try {
      _bookings = await _repository.getBookingHistory();
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading booking history: $e');
      }
    }
    notifyListeners();
  }

  // Initialize and load booking history
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _loadBookingHistory();

    _isLoading = false;
    notifyListeners();
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _repository.cancelBooking(bookingId);
      // Refresh the list after cancellation
      await _loadBookingHistory();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Submit review
  Future<void> submitReview(ReviewRequest reviewRequest) async {
    try {
      await _repository.submitReview(reviewRequest);
      // Refresh to update review status
      await _loadBookingHistory();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}