// File: lib/data/repositories/marketplace_repository/booking_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:journeyq/core/services/marketplace_service.dart';

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
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final String specialRequests;
  final CardDetailsDTO cardDetails;

  CreateRoomBookingDTO({
    required this.roomId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.specialRequests,
    required this.cardDetails,
  });

  Map<String, dynamic> toJson() {
    // Ensure all types match backend expectations exactly
    final json = {
      'roomId': roomId,  // Long (number)
      'userId': userId,  // Long (number)
      'customerName': customerName,  // String
      'customerEmail': customerEmail,  // String
      'customerPhone': customerPhone,  // String
      'checkInDate': checkInDate.toIso8601String().split('T')[0],  // LocalDate (YYYY-MM-DD string)
      'checkOutDate': checkOutDate.toIso8601String().split('T')[0],  // LocalDate (YYYY-MM-DD string)
      'numberOfGuests': numberOfGuests,  // Integer (number)
      'specialRequests': specialRequests,  // String
      'cardDetails': cardDetails.toJson(),  // CardDetailsDTO (object)
    };

    debugPrint('📋 Final JSON to send: $json');
    debugPrint('   roomId type: ${json['roomId'].runtimeType}');
    debugPrint('   userId type: ${json['userId'].runtimeType}');

    return json;
  }
}

class BookingResponse {
  final String bookingId;
  final String status;
  final String message;
  final DateTime bookedDate;
  final int? id;
  final int? roomId;
  final int? userId;
  final String? customerName;
  final String? customerEmail;
  final int? numberOfGuests;
  final int? numberOfNights;
  final double? pricePerNight;
  final double? totalAmount;
  final String? maskedCardNumber;

  BookingResponse({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.bookedDate,
    this.id,
    this.roomId,
    this.userId,
    this.customerName,
    this.customerEmail,
    this.numberOfGuests,
    this.numberOfNights,
    this.pricePerNight,
    this.totalAmount,
    this.maskedCardNumber,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing BookingResponse from JSON: $json');

    // Backend returns 'id' as the booking ID
    final id = json['id'] as int?;
    final bookingId = id != null ? 'BK-$id' : 'BK-${DateTime.now().millisecondsSinceEpoch}';

    // Parse status (always string in response)
    final status = (json['status'] ?? 'CONFIRMED').toString();

    // Parse message (use customerName or default message)
    final customerName = json['customerName']?.toString();
    final message = customerName != null
        ? 'Booking confirmed for $customerName'
        : 'Booking created successfully';

    // Parse bookedDate from createdAt or confirmedAt
    DateTime bookedDate;
    final createdAt = json['createdAt'] ?? json['confirmedAt'];
    if (createdAt != null && createdAt is String) {
      try {
        bookedDate = DateTime.parse(createdAt);
      } catch (e) {
        debugPrint('⚠️ Error parsing date: $e');
        bookedDate = DateTime.now();
      }
    } else {
      bookedDate = DateTime.now();
    }

    // Parse numeric fields safely
    final roomId = json['roomId'] as int?;
    final userId = json['userId'] as int?;
    final numberOfGuests = json['numberOfGuests'] as int?;
    final numberOfNights = json['numberOfNights'] as int?;

    // Parse double fields safely
    final pricePerNight = (json['pricePerNight'] as num?)?.toDouble();
    final totalAmount = (json['totalAmount'] as num?)?.toDouble();

    // Parse string fields
    final email = json['customerEmail']?.toString();
    final maskedCard = json['maskedCardNumber']?.toString();

    debugPrint('✅ Parsed BookingResponse:');
    debugPrint('   id: $id');
    debugPrint('   bookingId: $bookingId');
    debugPrint('   status: $status');
    debugPrint('   totalAmount: $totalAmount');
    debugPrint('   bookedDate: $bookedDate');

    return BookingResponse(
      bookingId: bookingId,
      status: status,
      message: message,
      bookedDate: bookedDate,
      id: id,
      roomId: roomId,
      userId: userId,
      customerName: customerName,
      customerEmail: email,
      numberOfGuests: numberOfGuests,
      numberOfNights: numberOfNights,
      pricePerNight: pricePerNight,
      totalAmount: totalAmount,
      maskedCardNumber: maskedCard,
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

// Repository - Uses MarketplaceService for API calls
class BookingRepository {
  // Create a new room booking - Endpoint: /service/room-bookings/create
  static Future<BookingResponse> createRoomBooking(CreateRoomBookingDTO bookingData) async {
    try {
      debugPrint('🏨 Creating room booking...');
      debugPrint('📋 Booking data: ${jsonEncode(bookingData.toJson())}');

      final response = await MarketplaceService.post(
        '/service/room-bookings/create',
        data: bookingData.toJson(),
      );

      debugPrint('✅ Booking response status: ${response.statusCode}');
      debugPrint('📦 Booking response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : jsonDecode(response.data.toString());
        return BookingResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to create booking: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ Booking creation error: $e');
      rethrow;
    }
  }

  // Helper method to create booking from form data - Updated to match Java DTO exactly
  static CreateRoomBookingDTO createBookingData({
    required int roomId,
    required int userId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfGuests,
    required String specialRequests,
    required CardDetailsDTO cardDetails,
  }) {
    return CreateRoomBookingDTO(
      roomId: roomId,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      numberOfGuests: numberOfGuests,
      specialRequests: specialRequests,
      cardDetails: cardDetails,
    );
  }
}
