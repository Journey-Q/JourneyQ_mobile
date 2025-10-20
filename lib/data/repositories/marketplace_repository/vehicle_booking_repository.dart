// File: lib/data/repositories/marketplace_repository/vehicle_booking_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:journeyq/core/services/marketplace_service.dart';

// Create Vehicle Booking DTO
class CreateVehicleBookingDTO {
  final int vehicleId;
  final int userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropoffLocation;
  final int estimatedKilometers;
  final bool withAC;
  final String specialRequests;

  CreateVehicleBookingDTO({
    required this.vehicleId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.estimatedKilometers,
    required this.withAC,
    required this.specialRequests,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'vehicleId': vehicleId,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'startDate': startDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'endDate': endDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'estimatedKilometers': estimatedKilometers,
      'withAC': withAC,
      'specialRequests': specialRequests,
    };

    debugPrint('📋 Vehicle Booking JSON: $json');
    return json;
  }
}

// Vehicle Booking Response - matches backend VehicleBookingResponseDTO
class VehicleBookingResponse {
  final int id;
  final int vehicleId;
  final int serviceProviderId;
  final int userId;

  // Customer Information
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  // Booking Details
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropoffLocation;
  final int estimatedKilometers;
  final bool withAC;
  final double pricePerKm;
  final double estimatedTotalAmount;

  // Status and Reasons
  final String status; // BookingStatus enum: PENDING, APPROVED, REJECTED, CANCELLED, COMPLETED
  final String? specialRequests;
  final String? cancellationReason;
  final String? rejectionReason;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? cancelledAt;
  final DateTime? completedAt;

  VehicleBookingResponse({
    required this.id,
    required this.vehicleId,
    required this.serviceProviderId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.estimatedKilometers,
    required this.withAC,
    required this.pricePerKm,
    required this.estimatedTotalAmount,
    required this.status,
    this.specialRequests,
    this.cancellationReason,
    this.rejectionReason,
    required this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.rejectedAt,
    this.cancelledAt,
    this.completedAt,
  });

  // Convenience getters
  String get bookingId => 'VB-$id';

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
        return 'Your vehicle booking is pending approval from $customerName';
      case 'APPROVED':
        return 'Vehicle booking approved for $customerName';
      case 'REJECTED':
        return 'Vehicle booking was rejected${rejectionReason != null ? ": $rejectionReason" : ""}';
      case 'CANCELLED':
        return 'Vehicle booking was cancelled${cancellationReason != null ? ": $cancellationReason" : ""}';
      case 'COMPLETED':
        return 'Vehicle booking completed for $customerName';
      default:
        return 'Vehicle booking created successfully';
    }
  }

  factory VehicleBookingResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing VehicleBookingResponse from JSON: $json');

    return VehicleBookingResponse(
      id: json['id'] as int,
      vehicleId: json['vehicleId'] as int,
      serviceProviderId: json['serviceProviderId'] as int,
      userId: json['userId'] as int,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      pickupLocation: json['pickupLocation'] as String,
      dropoffLocation: json['dropoffLocation'] as String,
      estimatedKilometers: json['estimatedKilometers'] as int,
      withAC: json['withAC'] as bool,
      pricePerKm: (json['pricePerKm'] as num).toDouble(),
      estimatedTotalAmount: (json['estimatedTotalAmount'] as num).toDouble(),
      status: json['status']?.toString() ?? 'PENDING',
      specialRequests: json['specialRequests']?.toString(),
      cancellationReason: json['cancellationReason']?.toString(),
      rejectionReason: json['rejectionReason']?.toString(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      approvedAt: json['approvedAt'] != null ? DateTime.parse(json['approvedAt'] as String) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt'] as String) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }
}

// Repository
class VehicleBookingRepository {
  // Create vehicle booking - Endpoint: /service/vehicle-bookings/create
  static Future<VehicleBookingResponse> createVehicleBooking(CreateVehicleBookingDTO bookingData) async {
    try {
      debugPrint('🚗 Creating vehicle booking...');
      debugPrint('📋 Booking data: ${jsonEncode(bookingData.toJson())}');

      final response = await MarketplaceService.post(
        '/service/vehicle-bookings/create',
        data: bookingData.toJson(),
      );

      debugPrint('✅ Vehicle booking response status: ${response.statusCode}');
      debugPrint('📦 Vehicle booking response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : jsonDecode(response.data.toString());
        return VehicleBookingResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to create vehicle booking: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ Vehicle booking creation error: $e');
      rethrow;
    }
  }

  // Helper method to create booking from form data
  static CreateVehicleBookingDTO createBookingData({
    required int vehicleId,
    required int userId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required DateTime startDate,
    required DateTime endDate,
    required String pickupLocation,
    required String dropoffLocation,
    required int estimatedKilometers,
    required bool withAC,
    required String specialRequests,
  }) {
    return CreateVehicleBookingDTO(
      vehicleId: vehicleId,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      startDate: startDate,
      endDate: endDate,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      estimatedKilometers: estimatedKilometers,
      withAC: withAC,
      specialRequests: specialRequests,
    );
  }
}
