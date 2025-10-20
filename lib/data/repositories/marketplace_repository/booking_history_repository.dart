import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class BookingHistoryRepository {
  /// Get booking history for a specific user
  static Future<List<BookingHistory>> getUserBookingHistory(int userId) async {
    try {
      print('🔍 Fetching booking history for user: $userId');

      final response = await MarketplaceService.get('/api/booking-history/user/$userId');

      print('📦 Booking history response: ${response.data}');

      // Handle direct array response
      if (response.data is List) {
        final bookings = (response.data as List)
            .map((item) => BookingHistory.fromJson(item as Map<String, dynamic>))
            .toList();
        print('✅ Found ${bookings.length} bookings');
        return bookings;
      }

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null && data['data'] is List) {
          final bookings = (data['data'] as List)
              .map((item) => BookingHistory.fromJson(item as Map<String, dynamic>))
              .toList();
          print('✅ Found ${bookings.length} bookings');
          return bookings;
        }
      }

      return [];
    } on AppException catch (e) {
      print('❌ Error fetching booking history: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error fetching booking history: $e');
      rethrow;
    }
  }
}

// Booking History Model
class BookingHistory {
  final int bookingId;
  final String bookingType; // ROOM_BOOKING, TOUR_BOOKING, VEHICLE_BOOKING
  final int serviceProviderId;
  final String serviceProviderName;
  final int userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String startDate;
  final String endDate;
  final double totalAmount;
  final String status; // CONFIRMED, COMPLETED, CANCELLED, PENDING
  final RoomBookingDetails? roomBookingDetails;
  final TourBookingDetails? tourBookingDetails;
  final VehicleBookingDetails? vehicleBookingDetails;
  final String createdAt;
  final String updatedAt;
  final String? specialRequests;
  final String? cancellationReason;

  BookingHistory({
    required this.bookingId,
    required this.bookingType,
    required this.serviceProviderId,
    required this.serviceProviderName,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.status,
    this.roomBookingDetails,
    this.tourBookingDetails,
    this.vehicleBookingDetails,
    required this.createdAt,
    required this.updatedAt,
    this.specialRequests,
    this.cancellationReason,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      bookingId: json['bookingId'] as int,
      bookingType: json['bookingType']?.toString() ?? '',
      serviceProviderId: json['serviceProviderId'] as int,
      serviceProviderName: json['serviceProviderName']?.toString() ?? '',
      userId: json['userId'] as int,
      customerName: json['customerName']?.toString() ?? '',
      customerEmail: json['customerEmail']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      roomBookingDetails: json['roomBookingDetails'] != null
          ? RoomBookingDetails.fromJson(json['roomBookingDetails'] as Map<String, dynamic>)
          : null,
      tourBookingDetails: json['tourBookingDetails'] != null
          ? TourBookingDetails.fromJson(json['tourBookingDetails'] as Map<String, dynamic>)
          : null,
      vehicleBookingDetails: json['vehicleBookingDetails'] != null
          ? VehicleBookingDetails.fromJson(json['vehicleBookingDetails'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      specialRequests: json['specialRequests']?.toString(),
      cancellationReason: json['cancellationReason']?.toString(),
    );
  }

  // Get user-friendly booking type label
  String get bookingTypeLabel {
    switch (bookingType.toUpperCase()) {
      case 'ROOM_BOOKING':
        return 'Hotel';
      case 'TOUR_BOOKING':
        return 'Tour Package';
      case 'VEHICLE_BOOKING':
        return 'Travel Agency';
      default:
        return bookingType;
    }
  }

  // Calculate number of nights for room bookings
  int get numberOfNights {
    if (roomBookingDetails != null) {
      return roomBookingDetails!.numberOfNights;
    }

    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return end.difference(start).inDays;
    } catch (e) {
      return 1;
    }
  }

  // Get check-in date as DateTime
  DateTime? get checkInDate {
    try {
      return DateTime.parse(startDate);
    } catch (e) {
      return null;
    }
  }

  // Get check-out date as DateTime
  DateTime? get checkOutDate {
    try {
      return DateTime.parse(endDate);
    } catch (e) {
      return null;
    }
  }

  // Get created date as DateTime
  DateTime? get bookingCreatedDate {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }
}

// Room Booking Details Model
class RoomBookingDetails {
  final int roomId;
  final String roomType;
  final int numberOfGuests;
  final int numberOfNights;
  final double pricePerNight;

  RoomBookingDetails({
    required this.roomId,
    required this.roomType,
    required this.numberOfGuests,
    required this.numberOfNights,
    required this.pricePerNight,
  });

  factory RoomBookingDetails.fromJson(Map<String, dynamic> json) {
    return RoomBookingDetails(
      roomId: json['roomId'] as int,
      roomType: json['roomType']?.toString() ?? '',
      numberOfGuests: json['numberOfGuests'] as int? ?? 1,
      numberOfNights: json['numberOfNights'] as int? ?? 1,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// Tour Booking Details Model
class TourBookingDetails {
  final int tourId;
  final String tourName;
  final String tourDescription;
  final int numberOfPeople;
  final int duration;

  TourBookingDetails({
    required this.tourId,
    required this.tourName,
    required this.tourDescription,
    required this.numberOfPeople,
    required this.duration,
  });

  factory TourBookingDetails.fromJson(Map<String, dynamic> json) {
    return TourBookingDetails(
      tourId: json['tourId'] as int,
      tourName: json['tourName']?.toString() ?? '',
      tourDescription: json['tourDescription']?.toString() ?? '',
      numberOfPeople: json['numberOfPeople'] as int? ?? 1,
      duration: json['duration'] as int? ?? 1,
    );
  }
}

// Vehicle Booking Details Model
class VehicleBookingDetails {
  final int vehicleId;
  final String vehicleName;
  final String vehicleType;
  final String pickupLocation;
  final String dropoffLocation;
  final int estimatedKilometers;
  final bool withAC;

  VehicleBookingDetails({
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.estimatedKilometers,
    required this.withAC,
  });

  factory VehicleBookingDetails.fromJson(Map<String, dynamic> json) {
    return VehicleBookingDetails(
      vehicleId: json['vehicleId'] as int,
      vehicleName: json['vehicleName']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      pickupLocation: json['pickupLocation']?.toString() ?? '',
      dropoffLocation: json['dropoffLocation']?.toString() ?? '',
      estimatedKilometers: json['estimatedKilometers'] as int? ?? 0,
      withAC: json['withAC'] as bool? ?? false,
    );
  }
}
