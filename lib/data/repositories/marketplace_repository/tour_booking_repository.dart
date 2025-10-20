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

// Tour Booking Response - matches backend TourBookingResponseDTO
class TourBookingResponse {
  final int id;
  final int tourId;
  final int serviceProviderId;
  final int userId;

  // Customer Information
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  // Booking Details
  final DateTime tourDate;
  final int numberOfPeople;
  final double pricePerPerson;
  final double totalAmount;

  // Booking Status
  final String status; // PENDING, APPROVED, REJECTED, CANCELLED, COMPLETED
  final String? specialRequests;
  final String? cancellationReason;
  final String? rejectionReason;

  // Timestamps
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? cancelledAt;
  final DateTime? completedAt;

  TourBookingResponse({
    required this.id,
    required this.tourId,
    required this.serviceProviderId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tourDate,
    required this.numberOfPeople,
    required this.pricePerPerson,
    required this.totalAmount,
    required this.status,
    this.specialRequests,
    this.cancellationReason,
    this.rejectionReason,
    required this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.cancelledAt,
    this.completedAt,
  });

  // Convenience getters
  String get bookingId => 'TB-$id';

  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending Approval';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'CANCELLED':
        return 'Cancelled';
      case 'COMPLETED':
        return 'Completed';
      default:
        return status;
    }
  }

  String get message {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Your tour booking is pending approval';
      case 'APPROVED':
        return 'Tour booking approved for $customerName';
      case 'REJECTED':
        return 'Tour booking was rejected${rejectionReason != null ? ": $rejectionReason" : ""}';
      case 'CANCELLED':
        return 'Tour booking was cancelled${cancellationReason != null ? ": $cancellationReason" : ""}';
      case 'COMPLETED':
        return 'Tour booking completed';
      default:
        return 'Tour booking created successfully';
    }
  }

  factory TourBookingResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing TourBookingResponse from JSON: $json');

    return TourBookingResponse(
      id: json['id'] as int,
      tourId: json['tourId'] as int,
      serviceProviderId: json['serviceProviderId'] as int,
      userId: json['userId'] as int,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String,
      tourDate: DateTime.parse(json['tourDate'] as String),
      numberOfPeople: json['numberOfPeople'] as int,
      pricePerPerson: (json['pricePerPerson'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status']?.toString() ?? 'PENDING',
      specialRequests: json['specialRequests']?.toString(),
      cancellationReason: json['cancellationReason']?.toString(),
      rejectionReason: json['rejectionReason']?.toString(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      approvedAt: json['approvedAt'] != null ? DateTime.parse(json['approvedAt'] as String) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt'] as String) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
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
