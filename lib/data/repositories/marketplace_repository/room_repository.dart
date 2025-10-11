// File: lib/data/repositories/marketplace_repository/room_repository.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class RoomRepository {
  // Room API endpoints
  static const String _roomsBasePath = '/service/rooms';

  /// Get room by ID
  static Future<Room> getRoomById(String roomId) async {
    try {
      final response = await MarketplaceService.get('$_roomsBasePath/$roomId');

      debugPrint('Get Room by ID Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('data') && responseData['data'] != null) {
          return Room.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return Room.fromJson(responseData);
        }
      } else {
        throw ServerException('Invalid response format from server');
      }
    } on AppException catch (e) {
      debugPrint('AppException in getRoomById: $e');
      rethrow;
    } catch (e) {
      debugPrint('General Exception in getRoomById: $e');
      throw ServerException('Failed to fetch room: $e');
    }
  }

  /// Get all rooms
  static Future<List<Room>> getAllRooms() async {
    try {
      debugPrint('Fetching all rooms from: $_roomsBasePath/all');

      final response = await MarketplaceService.get('$_roomsBasePath/all');

      debugPrint('Get All Rooms Raw Response: ${response.data}');
      debugPrint('Response Type: ${response.data.runtimeType}');
      debugPrint('Status Code: ${response.statusCode}');

      List<dynamic> roomData = [];

      // Handle different response formats
      if (response.data is List) {
        roomData = response.data as List<dynamic>;
        debugPrint('✓ Response is directly a List with ${roomData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        debugPrint('Response is a Map with keys: ${responseMap.keys.toList()}');

        if (responseMap.containsKey('data') && responseMap['data'] != null) {
          if (responseMap['data'] is List) {
            roomData = responseMap['data'] as List<dynamic>;
            debugPrint('✓ Found rooms in data field: ${roomData.length} items');
          }
        } else if (responseMap.containsKey('rooms') && responseMap['rooms'] != null) {
          if (responseMap['rooms'] is List) {
            roomData = responseMap['rooms'] as List<dynamic>;
            debugPrint('✓ Found rooms in rooms field: ${roomData.length} items');
          }
        } else {
          // Try to find any list in the response recursively
          roomData = _findListInResponse(responseMap);
          if (roomData.isNotEmpty) {
            debugPrint('✓ Found list recursively with ${roomData.length} items');
          }
        }
      } else {
        debugPrint('⚠ Unexpected response format: ${response.data.runtimeType}');
      }

      if (roomData.isEmpty) {
        debugPrint('⚠ No room data found in response');
        return [];
      }

      // Print first item for debugging
      if (roomData.isNotEmpty) {
        debugPrint('First room data: ${roomData[0]}');
      }

      final rooms = <Room>[];

      for (var i = 0; i < roomData.length; i++) {
        try {
          if (roomData[i] is Map<String, dynamic>) {
            final room = Room.fromJson(roomData[i] as Map<String, dynamic>);
            rooms.add(room);
          } else {
            debugPrint('⚠ Item $i is not a Map: ${roomData[i].runtimeType}');
          }
        } catch (e) {
          debugPrint('⚠ Error parsing room at index $i: $e');
          debugPrint('⚠ Problematic data: ${roomData[i]}');
        }
      }

      debugPrint('✓ Successfully parsed ${rooms.length} out of ${roomData.length} rooms');

      if (rooms.isNotEmpty) {
        debugPrint('Sample room: ${rooms[0]}');
      }

      return rooms;
    } on AppException catch (e) {
      debugPrint('❌ AppException in getAllRooms: $e');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ General Exception in getAllRooms: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch rooms: $e');
    }
  }

  /// Get rooms by service provider ID (hotel ID)
  static Future<List<Room>> getRoomsByServiceProvider(String serviceProviderId) async {
    try {
      debugPrint('Fetching rooms for service provider: $serviceProviderId');

      final response = await MarketplaceService.get(
          '$_roomsBasePath/service-provider/$serviceProviderId'
      );

      debugPrint('Get Rooms by Service Provider Response: ${response.data}');

      List<dynamic> roomData = [];

      if (response.data is List) {
        roomData = response.data as List<dynamic>;
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap.containsKey('data') && responseMap['data'] is List) {
          roomData = responseMap['data'] as List<dynamic>;
        } else if (responseMap.containsKey('rooms') && responseMap['rooms'] is List) {
          roomData = responseMap['rooms'] as List<dynamic>;
        }
      }

      final rooms = roomData.map((roomJson) => Room.fromJson(roomJson as Map<String, dynamic>)).toList();

      debugPrint('✓ Found ${rooms.length} rooms for service provider $serviceProviderId');
      return rooms;
    } on AppException catch (e) {
      debugPrint('❌ AppException in getRoomsByServiceProvider: $e');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ General Exception in getRoomsByServiceProvider: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch rooms by service provider: $e');
    }
  }

  /// Get available rooms by service provider ID
  static Future<List<Room>> getAvailableRoomsByServiceProvider(String serviceProviderId) async {
    try {
      debugPrint('Fetching available rooms for service provider: $serviceProviderId');

      final response = await MarketplaceService.get(
          '$_roomsBasePath/service-provider/$serviceProviderId/status/AVAILABLE'
      );

      debugPrint('Get Available Rooms Response: ${response.data}');

      List<dynamic> roomData = [];

      if (response.data is List) {
        roomData = response.data as List<dynamic>;
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap.containsKey('data') && responseMap['data'] is List) {
          roomData = responseMap['data'] as List<dynamic>;
        } else if (responseMap.containsKey('rooms') && responseMap['rooms'] is List) {
          roomData = responseMap['rooms'] as List<dynamic>;
        }
      }

      final rooms = roomData.map((roomJson) => Room.fromJson(roomJson as Map<String, dynamic>)).toList();

      debugPrint('✓ Found ${rooms.length} available rooms for service provider $serviceProviderId');
      return rooms;
    } on AppException catch (e) {
      debugPrint('❌ AppException in getAvailableRoomsByServiceProvider: $e');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ General Exception in getAvailableRoomsByServiceProvider: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch available rooms: $e');
    }
  }

  /// Helper method to find list in response recursively
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      final value = response[key];

      if (value is List && value.isNotEmpty) {
        // Check if the list contains maps (room objects)
        if (value[0] is Map<String, dynamic>) {
          debugPrint('Found list under key: $key');
          return value;
        }
      } else if (value is Map<String, dynamic>) {
        final nestedList = _findListInResponse(value);
        if (nestedList.isNotEmpty) {
          return nestedList;
        }
      }
    }
    return [];
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_roomsBasePath/all');
      debugPrint('Room API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Room API Connection Test Failed: $e');
      return false;
    }
  }
}

/// Room Model
class Room {
  final String id;
  final String serviceProviderId;
  final String roomNumber;
  final String roomType;
  final String description;
  final double price;
  final int capacity;
  final RoomStatus status;
  final List<String> amenities;
  final String? imageUrl;
  final int? size; // in square meters
  final int? bedrooms;
  final int? bathrooms;

  Room({
    required this.id,
    required this.serviceProviderId,
    required this.roomNumber,
    required this.roomType,
    required this.description,
    required this.price,
    required this.capacity,
    required this.status,
    this.amenities = const [],
    this.imageUrl,
    this.size,
    this.bedrooms,
    this.bathrooms,
  });

  // Add this method to handle better room type detection
  String get displayRoomType {
    if (roomType.isNotEmpty && roomType != 'Unknown' && roomType != 'Standard') {
      return roomType;
    }

    // Determine room type based on features
    if (amenities.any((amenity) => amenity.toLowerCase().contains('queen bed'))) {
      return 'Queen Room';
    } else if (amenities.any((amenity) => amenity.toLowerCase().contains('king bed'))) {
      return 'King Room';
    } else if (amenities.any((amenity) => amenity.toLowerCase().contains('single bed'))) {
      return 'Single Room';
    } else if (price > 10000) {
      return 'Deluxe Room';
    } else if (price > 7000) {
      return 'Standard Room';
    } else {
      return 'Budget Room';
    }
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    debugPrint('─────────────────────────────────────');
    debugPrint('Parsing room JSON: $json');

    // Extract ID
    String id = _extractField(json, ['id', 'roomId', '_id']) ?? 'unknown_id';

    // Extract service provider ID
    String serviceProviderId = _extractField(json, [
      'serviceProviderId',
      'service_provider_id',
      'hotelId',
      'hotel_id'
    ]) ?? 'unknown_provider';

    // Extract room number
    String roomNumber = _extractField(json, [
      'roomNumber',
      'room_number',
      'number'
    ]) ?? 'Unknown';

    // Extract room type
    String roomType = _extractField(json, [
      'roomType',
      'room_type',
      'type'
    ]) ?? 'Standard';

    // Extract description
    String description = _extractField(json, [
      'description',
      'details'
    ]) ?? 'No description available';

    // Extract price
    double price = (json['price'] ?? json['room_price'] ?? 0.0).toDouble();

    // Extract capacity
    int capacity = json['capacity'] ?? json['guest_capacity'] ?? 2;

    // Extract status
    RoomStatus status = _parseRoomStatus(json['status'] ?? 'AVAILABLE');

    // Extract amenities
    List<String> amenities = [];
    if (json['amenities'] is List) {
      amenities = (json['amenities'] as List).whereType<String>().toList();
    }

    // Extract image URL
    String? imageUrl = _extractField(json, [
      'imageUrl',
      'image_url',
      'room_image',
      'photo'
    ]);

    // Extract size
    int? size = json['size'] ?? json['room_size'];

    // Extract bedrooms
    int? bedrooms = json['bedrooms'] ?? json['bedroom_count'];

    // Extract bathrooms
    int? bathrooms = json['bathrooms'] ?? json['bathroom_count'];

    debugPrint('✓ Extracted Room:');
    debugPrint('  ID: $id');
    debugPrint('  Service Provider ID: $serviceProviderId');
    debugPrint('  Room Number: $roomNumber');
    debugPrint('  Type: $roomType');
    debugPrint('  Price: $price');
    debugPrint('  Capacity: $capacity');
    debugPrint('  Status: $status');
    debugPrint('  Amenities: ${amenities.length} items');
    debugPrint('  Image: ${imageUrl ?? "null"}');
    debugPrint('─────────────────────────────────────');

    return Room(
      id: id,
      serviceProviderId: serviceProviderId,
      roomNumber: roomNumber,
      roomType: roomType,
      description: description,
      price: price,
      capacity: capacity,
      status: status,
      amenities: amenities,
      imageUrl: imageUrl,
      size: size,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
    );
  }

  static RoomStatus _parseRoomStatus(dynamic status) {
    if (status == null) return RoomStatus.AVAILABLE;

    final statusStr = status.toString().toUpperCase();
    switch (statusStr) {
      case 'AVAILABLE':
        return RoomStatus.AVAILABLE;
      case 'OCCUPIED':
        return RoomStatus.OCCUPIED;
      case 'MAINTENANCE':
        return RoomStatus.MAINTENANCE;
      case 'RESERVED':
        return RoomStatus.RESERVED;
      default:
        return RoomStatus.AVAILABLE;
    }
  }

  /// Helper method to extract field from JSON with multiple possible keys
  static String? _extractField(Map<String, dynamic> json, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (json.containsKey(key) && json[key] != null && json[key].toString().isNotEmpty) {
        return json[key].toString();
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceProviderId': serviceProviderId,
      'roomNumber': roomNumber,
      'roomType': roomType,
      'description': description,
      'price': price,
      'capacity': capacity,
      'status': status.name,
      'amenities': amenities,
      'imageUrl': imageUrl,
      'size': size,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
    };
  }

  String get statusText {
    switch (status) {
      case RoomStatus.AVAILABLE:
        return 'Available';
      case RoomStatus.OCCUPIED:
        return 'Occupied';
      case RoomStatus.MAINTENANCE:
        return 'Maintenance';
      case RoomStatus.RESERVED:
        return 'Reserved';
    }
  }

  Color get statusColor {
    switch (status) {
      case RoomStatus.AVAILABLE:
        return Colors.green;
      case RoomStatus.OCCUPIED:
        return Colors.orange;
      case RoomStatus.MAINTENANCE:
        return Colors.red;
      case RoomStatus.RESERVED:
        return Colors.blue;
    }
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}/night';

  String get capacityText => '$capacity ${capacity == 1 ? 'guest' : 'guests'}';

  @override
  String toString() {
    return 'Room(id: $id, number: $roomNumber, type: $roomType, price: $price, status: $status)';
  }
}

enum RoomStatus {
  AVAILABLE,
  OCCUPIED,
  MAINTENANCE,
  RESERVED,
}

/// Response wrapper for room API
class RoomResponse {
  final bool success;
  final String message;
  final Room? room;
  final List<Room>? rooms;

  RoomResponse({
    required this.success,
    required this.message,
    this.room,
    this.rooms,
  });

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((r) => Room.fromJson(r)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'room': room?.toJson(),
      'rooms': rooms?.map((r) => r.toJson()).toList(),
    };
  }
}