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

// Vehicle Booking Response
class VehicleBookingResponse {
  final String bookingId;
  final String status;
  final String message;
  final DateTime bookedDate;
  final int? id;
  final int? vehicleId;
  final int? userId;
  final String? customerName;
  final String? customerEmail;
  final String? pickupLocation;
  final String? dropoffLocation;
  final int? estimatedKilometers;
  final int? numberOfDays;
  final double? totalAmount;
  final double? pricePerDay;
  final bool? withAC;

  VehicleBookingResponse({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.bookedDate,
    this.id,
    this.vehicleId,
    this.userId,
    this.customerName,
    this.customerEmail,
    this.pickupLocation,
    this.dropoffLocation,
    this.estimatedKilometers,
    this.numberOfDays,
    this.totalAmount,
    this.pricePerDay,
    this.withAC,
  });

  factory VehicleBookingResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing VehicleBookingResponse from JSON: $json');

    final id = json['id'] as int?;
    final bookingId = id != null ? 'VB-$id' : 'VB-${DateTime.now().millisecondsSinceEpoch}';
    final status = (json['status'] ?? 'CONFIRMED').toString();
    final customerName = json['customerName']?.toString();
    final message = customerName != null
        ? 'Vehicle booking confirmed for $customerName'
        : 'Vehicle booking created successfully';

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

    final vehicleId = json['vehicleId'] as int?;
    final userId = json['userId'] as int?;
    final estimatedKilometers = json['estimatedKilometers'] as int?;
    final numberOfDays = json['numberOfDays'] as int?;
    final pricePerDay = (json['pricePerDay'] as num?)?.toDouble();
    final totalAmount = (json['totalAmount'] as num?)?.toDouble();
    final withAC = json['withAC'] as bool?;

    debugPrint('✅ Parsed VehicleBookingResponse: bookingId=$bookingId, totalAmount=$totalAmount');

    return VehicleBookingResponse(
      bookingId: bookingId,
      status: status,
      message: message,
      bookedDate: bookedDate,
      id: id,
      vehicleId: vehicleId,
      userId: userId,
      customerName: customerName,
      customerEmail: json['customerEmail']?.toString(),
      pickupLocation: json['pickupLocation']?.toString(),
      dropoffLocation: json['dropoffLocation']?.toString(),
      estimatedKilometers: estimatedKilometers,
      numberOfDays: numberOfDays,
      pricePerDay: pricePerDay,
      totalAmount: totalAmount,
      withAC: withAC,
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
