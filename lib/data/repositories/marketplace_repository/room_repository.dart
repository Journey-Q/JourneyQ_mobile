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

      debugPrint('Get Rooms by Service Provider Raw Response: ${response.data}');
      debugPrint('Response Type: ${response.data.runtimeType}');

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
          } else if (responseMap['data'] is Map) {
            // Handle case where data is a single room object
            roomData = [responseMap['data']];
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
          } else {
            // If no list found, check if the response itself contains room data
            if (responseMap.containsKey('id') || responseMap.containsKey('roomNumber')) {
              roomData = [responseMap];
              debugPrint('✓ Response contains single room data');
            }
          }
        }
      }

      if (roomData.isEmpty) {
        debugPrint('⚠ No room data found in response for service provider: $serviceProviderId');
        return [];
      }

      final rooms = <Room>[];
      for (var i = 0; i < roomData.length; i++) {
        try {
          if (roomData[i] is Map<String, dynamic>) {
            final roomJson = roomData[i] as Map<String, dynamic>;

            // Log the raw room data for debugging
            debugPrint('Raw room data at index $i: $roomJson');

            final room = Room.fromJson(roomJson);
            rooms.add(room);
            debugPrint('✓ Successfully parsed room: ${room.roomNumber}');
          } else {
            debugPrint('⚠ Item $i is not a Map: ${roomData[i].runtimeType}');
            debugPrint('⚠ Problematic item: ${roomData[i]}');
          }
        } catch (e, stackTrace) {
          debugPrint('❌ Error parsing room at index $i: $e');
          debugPrint('❌ Stack trace: $stackTrace');
          debugPrint('❌ Problematic data: ${roomData[i]}');
        }
      }

      debugPrint('✅ Successfully parsed ${rooms.length} out of ${roomData.length} rooms for service provider $serviceProviderId');

      if (rooms.isNotEmpty) {
        debugPrint('Sample parsed room:');
        debugPrint('  - ID: ${rooms[0].id}');
        debugPrint('  - Number: ${rooms[0].roomNumber}');
        debugPrint('  - Type: ${rooms[0].roomType}');
        debugPrint('  - Price: ${rooms[0].price}');
        debugPrint('  - Status: ${rooms[0].status}');
        debugPrint('  - Image URL: ${rooms[0].imageUrl}');
      }

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

  // FIXED: Use the actual roomType from database for display
  String get displayRoomType {
    // Use the roomType directly from database, don't override with custom logic
    if (roomType.isNotEmpty && roomType != 'Unknown' && roomType != 'Standard') {
      // Capitalize first letter of each word for better display
      return roomType.split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }

    // If roomType is empty or default, use the original logic as fallback
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

    // Call debug method first to check image data
    _debugImageData(json);

    // Extract ID - handle both string and numeric IDs
    String id = _extractField(json, ['id', 'roomId', '_id']) ?? 'unknown_id';

    // Extract service provider ID - handle both string and numeric
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
      'number',
      'name' // Database shows 'name' instead of roomNumber
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

    // Extract price - handle different field names and types
    double price = 0.0;
    if (json['price'] != null) {
      price = (json['price'] is num) ? json['price'].toDouble() : double.tryParse(json['price'].toString()) ?? 0.0;
    } else if (json['room_price'] != null) {
      price = (json['room_price'] is num) ? json['room_price'].toDouble() : double.tryParse(json['room_price'].toString()) ?? 0.0;
    }

    // Extract capacity - handle max_docupancy from database
    int capacity = json['capacity'] ??
        json['guest_capacity'] ??
        json['max_docupancy'] ?? // Database column name
        2;

    // Extract status - handle database status values
    RoomStatus status = _parseRoomStatus(json['status'] ?? 'AVAILABLE');

    // Extract amenities - handle both list and string formats
    List<String> amenities = [];
    if (json['amenities'] is List) {
      amenities = (json['amenities'] as List).whereType<String>().toList();
    } else if (json['amenities'] is String) {
      amenities = [json['amenities']];
    }

    // EXTRACT IMAGE URL - IMPROVED VERSION
    String? imageUrl = _extractImageUrl(json);

    // Extract size (area from database)
    int? size = json['size'] ?? json['room_size'] ?? json['area'];

    // Extract bedrooms
    int? bedrooms = json['bedrooms'] ?? json['bedroom_count'];

    // Extract bathrooms
    int? bathrooms = json['bathrooms'] ?? json['bathroom_count'];

    debugPrint('✓ Successfully parsed room from database:');
    debugPrint('  ID: $id');
    debugPrint('  Service Provider ID: $serviceProviderId');
    debugPrint('  Room Number/Name: $roomNumber');
    debugPrint('  Type: $roomType');
    debugPrint('  Price: $price');
    debugPrint('  Capacity: $capacity');
    debugPrint('  Status: $status');
    debugPrint('  Image URL: ${imageUrl ?? "null"}');
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

  /// IMPROVED: Extract image URL with better validation
  static String? _extractImageUrl(Map<String, dynamic> json) {
    // Try all possible image field names from database
    final possibleImageFields = [
      'image', 'imageUrl', 'image_url', 'room_image', 'photo',
      'image_path', 'img', 'picture', 'url', 'imageURL'
    ];

    for (var field in possibleImageFields) {
      if (json.containsKey(field) &&
          json[field] != null &&
          json[field].toString().trim().isNotEmpty) {

        String potentialUrl = json[field].toString().trim();

        // Skip obviously invalid values
        if (potentialUrl.toLowerCase() == 'null' ||
            potentialUrl.toLowerCase() == '<null>' ||
            potentialUrl.toLowerCase() == 'undefined' ||
            potentialUrl.isEmpty) {
          continue;
        }

        // Enhanced URL validation
        bool isValidUrl = _isValidImageUrl(potentialUrl);

        if (isValidUrl) {
          debugPrint('✅ Found valid image URL in "$field" field: $potentialUrl');

          // Ensure proper URL format
          if (potentialUrl.startsWith('www.')) {
            potentialUrl = 'https://$potentialUrl';
          }

          return potentialUrl;
        } else {
          debugPrint('⚠ Found image data in "$field" but not a valid URL: $potentialUrl');
        }
      }
    }

    debugPrint('❌ No valid image URL found in room data. Checked fields: $possibleImageFields');
    return null;
  }

  /// Check if a string is a valid image URL
  static bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;

    // Check for common URL patterns
    bool hasUrlPattern = url.startsWith('http://') ||
        url.startsWith('https://') ||
        url.startsWith('www.') ||
        url.contains('.com') ||
        url.contains('.net') ||
        url.contains('.org') ||
        url.contains('.io') ||
        url.contains('.cloudinary') ||
        url.contains('storage.googleapis.com');

    // Check for common image file extensions
    bool hasImageExtension = url.toLowerCase().contains('.jpg') ||
        url.toLowerCase().contains('.jpeg') ||
        url.toLowerCase().contains('.png') ||
        url.toLowerCase().contains('.webp') ||
        url.toLowerCase().contains('.gif') ||
        url.toLowerCase().contains('.bmp') ||
        url.toLowerCase().contains('.svg');

    // Check if it looks like a base64 image (data:image)
    bool isBase64 = url.startsWith('data:image/');

    return hasUrlPattern || hasImageExtension || isBase64;
  }

  /// Debug method to check what image data exists in the database response
  static void _debugImageData(Map<String, dynamic> json) {
    debugPrint('🔍 DEBUGGING IMAGE DATA IN ROOM RESPONSE:');
    debugPrint('Full JSON keys: ${json.keys.toList()}');

    // Check all potential image-related fields
    final imageFields = ['image', 'imageUrl', 'image_url', 'room_image', 'photo', 'img', 'picture'];

    for (var field in imageFields) {
      if (json.containsKey(field)) {
        final value = json[field];
        debugPrint('$field: $value (type: ${value.runtimeType})');

        if (value != null && value.toString().isNotEmpty && value.toString() != 'null') {
          debugPrint('✅ Found potential image data in $field');
        }
      }
    }

    // Also check all fields for any URL-like values
    debugPrint('🔍 Checking all fields for URL patterns:');
    for (var key in json.keys) {
      final value = json[key];
      if (value != null && value is String) {
        if (value.contains('http') || value.contains('.jpg') || value.contains('.png') || value.contains('image')) {
          debugPrint('⚠️ Found URL-like value in $key: $value');
        }
      }
    }
  }

  static RoomStatus _parseRoomStatus(dynamic status) {
    if (status == null) return RoomStatus.AVAILABLE;

    final statusStr = status.toString().toUpperCase();

    // Handle database status values
    switch (statusStr) {
      case 'AVAILABLE':
      case 'ACTIVE':
        return RoomStatus.AVAILABLE;
      case 'OCCUPIED':
      case 'BOOKED':
        return RoomStatus.OCCUPIED;
      case 'MAINTENANCE':
      case 'UNDER_MAINTENANCE':
      case 'MANTENANCE': // Handle typo in database
        return RoomStatus.MAINTENANCE;
      case 'RESERVED':
        return RoomStatus.RESERVED;
      default:
        debugPrint('⚠ Unknown room status: $statusStr, defaulting to AVAILABLE');
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

  /// Convert Room to Map for navigation (serializable)
  Map<String, dynamic> toNavigationMap() {
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
      'displayRoomType': displayRoomType,
      'formattedPrice': formattedPrice,
      'statusText': statusText,
      'statusColor': statusColor.value, // Convert Color to int
    };
  }

  /// Create Room from navigation map
  factory Room.fromNavigationMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? 'unknown_id',
      serviceProviderId: map['serviceProviderId'] ?? 'unknown_provider',
      roomNumber: map['roomNumber'] ?? 'Unknown',
      roomType: map['roomType'] ?? 'Standard',
      description: map['description'] ?? 'No description available',
      price: (map['price'] ?? 0.0).toDouble(),
      capacity: map['capacity'] ?? 2,
      status: _parseRoomStatus(map['status'] ?? 'AVAILABLE'),
      amenities: List<String>.from(map['amenities'] ?? []),
      imageUrl: map['imageUrl'],
      size: map['size'],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
    );
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

  // FIXED: Change currency from $ to LKR
  String get formattedPrice {
    // Format price with LKR symbol and commas
    return 'LKR ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}/night';
  }

  String get capacityText => '$capacity ${capacity == 1 ? 'guest' : 'guests'}';

  @override
  String toString() {
    return 'Room(id: $id, number: $roomNumber, type: $roomType, displayType: $displayRoomType, price: $price, status: $status, imageUrl: $imageUrl)';
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