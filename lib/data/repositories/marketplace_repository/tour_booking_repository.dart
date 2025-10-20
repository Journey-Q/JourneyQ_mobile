// File: lib/data/repositories/marketplace_repository/tour_booking_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:journeyq/core/services/marketplace_service.dart';

// Create Tour Booking DTO
class CreateTourBookingDTO {
  final int tourId;
  final int userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime tourDate;
  final int numberOfPeople;
  final String specialRequests;

  CreateTourBookingDTO({
    required this.tourId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tourDate,
    required this.numberOfPeople,
    required this.specialRequests,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'tourId': tourId,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'tourDate': tourDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
    };

    debugPrint('📋 Tour Booking JSON: $json');
    return json;
  }
}

// Tour Booking Response
class TourBookingResponse {
  final String bookingId;
  final String status;
  final String message;
  final DateTime bookedDate;
  final int? id;
  final int? tourId;
  final int? userId;
  final String? customerName;
  final String? customerEmail;
  final int? numberOfPeople;
  final double? totalAmount;
  final double? pricePerPerson;

  TourBookingResponse({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.bookedDate,
    this.id,
    this.tourId,
    this.userId,
    this.customerName,
    this.customerEmail,
    this.numberOfPeople,
    this.totalAmount,
    this.pricePerPerson,
  });

  factory TourBookingResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing TourBookingResponse from JSON: $json');

    final id = json['id'] as int?;
    final bookingId = id != null ? 'TB-$id' : 'TB-${DateTime.now().millisecondsSinceEpoch}';
    final status = (json['status'] ?? 'CONFIRMED').toString();
    final customerName = json['customerName']?.toString();
    final message = customerName != null
        ? 'Tour booking confirmed for $customerName'
        : 'Tour booking created successfully';

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

    final tourId = json['tourId'] as int?;
    final userId = json['userId'] as int?;
    final numberOfPeople = json['numberOfPeople'] as int?;
    final pricePerPerson = (json['pricePerPerson'] as num?)?.toDouble();
    final totalAmount = (json['totalAmount'] as num?)?.toDouble();

    debugPrint('✅ Parsed TourBookingResponse: bookingId=$bookingId, totalAmount=$totalAmount');

    return TourBookingResponse(
      bookingId: bookingId,
      status: status,
      message: message,
      bookedDate: bookedDate,
      id: id,
      tourId: tourId,
      userId: userId,
      customerName: customerName,
      customerEmail: json['customerEmail']?.toString(),
      numberOfPeople: numberOfPeople,
      pricePerPerson: pricePerPerson,
      totalAmount: totalAmount,
    );
  }
}

// Repository
class TourBookingRepository {
  // Create tour booking - Endpoint: /service/tour-bookings/create
  static Future<TourBookingResponse> createTourBooking(CreateTourBookingDTO bookingData) async {
    try {
      debugPrint('🎫 Creating tour booking...');
      debugPrint('📋 Booking data: ${jsonEncode(bookingData.toJson())}');

      final response = await MarketplaceService.post(
        '/service/tour-bookings/create',
        data: bookingData.toJson(),
      );

      debugPrint('✅ Tour booking response status: ${response.statusCode}');
      debugPrint('📦 Tour booking response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : jsonDecode(response.data.toString());
        return TourBookingResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to create tour booking: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ Tour booking creation error: $e');
      rethrow;
    }
  }

  // Helper method to create booking from form data
  static CreateTourBookingDTO createBookingData({
    required int tourId,
    required int userId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required DateTime tourDate,
    required int numberOfPeople,
    required String specialRequests,
  }) {
    return CreateTourBookingDTO(
      tourId: tourId,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      tourDate: tourDate,
      numberOfPeople: numberOfPeople,
      specialRequests: specialRequests,
    );
  }
}
