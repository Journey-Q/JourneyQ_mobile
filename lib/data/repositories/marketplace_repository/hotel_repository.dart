import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class HotelRepository {
  // Hotel Profile API endpoints
  static const String _hotelProfilesBasePath = '/service/hotel-profiles';

  /// Get hotel profile by ID
  static Future<HotelProfile> getHotelProfileById(String hotelId) async {
    try {
      // Validate hotel ID
      if (hotelId.isEmpty || hotelId == 'unknown_id') {
        throw ServerException('Invalid hotel ID');
      }

      print('🏨 Fetching hotel profile for ID: $hotelId');

      final response = await MarketplaceService.get('$_hotelProfilesBasePath/$hotelId');

      print('Get Hotel by ID Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        // Handle the actual API response structure from your Postman example
        if (responseData.containsKey('serviceProviderId')) {
          return HotelProfile.fromJson(responseData);
        } else if (responseData.containsKey('data') && responseData['data'] != null) {
          return HotelProfile.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return HotelProfile.fromJson(responseData);
        }
      } else {
        throw ServerException('Invalid response format from server');
      }
    } on AppException catch (e) {
      print('AppException in getHotelProfileById: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getHotelProfileById: $e');
      throw ServerException('Failed to fetch hotel profile: $e');
    }
  }

  /// Get all hotel profiles
  static Future<List<HotelProfile>> getAllHotelProfiles() async {
    try {
      print('Fetching all hotel profiles from: $_hotelProfilesBasePath/all');

      final response = await MarketplaceService.get('$_hotelProfilesBasePath/all');

      print('Get All Hotels Raw Response: ${response.data}');
      print('Response Type: ${response.data.runtimeType}');
      print('Status Code: ${response.statusCode}');

      List<dynamic> hotelData = [];

      // Handle different response formats
      if (response.data is List) {
        hotelData = response.data as List<dynamic>;
        print('✓ Response is directly a List with ${hotelData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        print('Response is a Map with keys: ${responseMap.keys.toList()}');

        // Try multiple possible keys where hotel data might be
        if (responseMap.containsKey('data') && responseMap['data'] != null) {
          if (responseMap['data'] is List) {
            hotelData = responseMap['data'] as List<dynamic>;
            print('✓ Found hotels in data field: ${hotelData.length} items');
          }
        } else if (responseMap.containsKey('hotels') && responseMap['hotels'] != null) {
          if (responseMap['hotels'] is List) {
            hotelData = responseMap['hotels'] as List<dynamic>;
            print('✓ Found hotels in hotels field: ${hotelData.length} items');
          }
        } else if (responseMap.containsKey('hotelProfiles') && responseMap['hotelProfiles'] != null) {
          if (responseMap['hotelProfiles'] is List) {
            hotelData = responseMap['hotelProfiles'] as List<dynamic>;
            print('✓ Found hotels in hotelProfiles field: ${hotelData.length} items');
          }
        } else {
          // Try to find any list in the response recursively
          hotelData = _findListInResponse(responseMap);
          if (hotelData.isNotEmpty) {
            print('✓ Found list recursively with ${hotelData.length} items');
          }
        }
      } else {
        print('⚠ Unexpected response format: ${response.data.runtimeType}');
      }

      if (hotelData.isEmpty) {
        print('⚠ No hotel data found in response');
        return [];
      }

      // Print first item for debugging
      if (hotelData.isNotEmpty) {
        print('First hotel data: ${hotelData[0]}');
      }

      final hotels = <HotelProfile>[];

      for (var i = 0; i < hotelData.length; i++) {
        try {
          if (hotelData[i] is Map<String, dynamic>) {
            final hotel = HotelProfile.fromJson(hotelData[i] as Map<String, dynamic>);
            hotels.add(hotel);
          } else {
            print('⚠ Item $i is not a Map: ${hotelData[i].runtimeType}');
          }
        } catch (e) {
          print('⚠ Error parsing hotel at index $i: $e');
          print('⚠ Problematic data: ${hotelData[i]}');
        }
      }

      print('✓ Successfully parsed ${hotels.length} out of ${hotelData.length} hotels');

      if (hotels.isNotEmpty) {
        print('Sample hotel: ${hotels[0]}');
      }

      return hotels;
    } on AppException catch (e) {
      print('❌ AppException in getAllHotelProfiles: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getAllHotelProfiles: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch hotel profiles: $e');
    }
  }

  /// Helper method to find list in response recursively
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      final value = response[key];

      if (value is List && value.isNotEmpty) {
        // Check if the list contains maps (hotel objects)
        if (value[0] is Map<String, dynamic>) {
          print('Found list under key: $key');
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

  /// Get popular hotels (limited number for homepage)
  static Future<List<HotelProfile>> getPopularHotels({int limit = 6}) async {
    try {
      print('═══════════════════════════════════════');
      print('Fetching popular hotels with limit: $limit');
      print('═══════════════════════════════════════');

      final allHotels = await getAllHotelProfiles();

      print('Total hotels fetched: ${allHotels.length}');

      if (allHotels.isEmpty) {
        print('⚠ No hotels found, returning empty list');
        return [];
      }

      final popularHotels = allHotels.take(limit).toList();
      print('✓ Returning ${popularHotels.length} popular hotels');
      print('═══════════════════════════════════════');

      return popularHotels;
    } on AppException catch (e) {
      print('❌ AppException in getPopularHotels: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getPopularHotels: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch popular hotels: $e');
    }
  }

  /// Get hotels by location
  static Future<List<HotelProfile>> getHotelsByLocation(String location) async {
    try {
      final allHotels = await getAllHotelProfiles();

      final filteredHotels = allHotels.where((hotel) =>
          hotel.location.toLowerCase().contains(location.toLowerCase())
      ).toList();

      print('Found ${filteredHotels.length} hotels in $location');
      return filteredHotels;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch hotels by location: $e');
    }
  }

  /// Search hotels by name or location
  static Future<List<HotelProfile>> searchHotels(String query) async {
    try {
      final allHotels = await getAllHotelProfiles();

      final searchResults = allHotels.where((hotel) =>
      hotel.name.toLowerCase().contains(query.toLowerCase()) ||
          hotel.location.toLowerCase().contains(query.toLowerCase())
      ).toList();

      print('Search found ${searchResults.length} hotels for query: $query');
      return searchResults;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search hotels: $e');
    }
  }

  /// Get featured hotels
  static Future<List<HotelProfile>> getFeaturedHotels({int limit = 4}) async {
    try {
      final allHotels = await getAllHotelProfiles();
      final featuredHotels = allHotels.take(limit).toList();

      print('Returning ${featuredHotels.length} featured hotels');
      return featuredHotels;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch featured hotels: $e');
    }
  }

  /// Get hotel amenities
  static Future<List<String>> getHotelAmenities(String hotelId) async {
    try {
      final response = await MarketplaceService.get('/service/hotel-amenities/$hotelId');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        List<String> amenities = [];

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final amenitiesData = responseData['data'] as List<dynamic>;
          for (var amenity in amenitiesData) {
            if (amenity is Map<String, dynamic> && amenity.containsKey('amenity')) {
              amenities.add(amenity['amenity'].toString());
            }
          }
        }

        return amenities;
      }
      return [];
    } catch (e) {
      print('Error fetching hotel amenities: $e');
      return [];
    }
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_hotelProfilesBasePath/all');
      print('API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('API Connection Test Failed: $e');
      return false;
    }
  }
}

/// Hotel Profile Model
class HotelProfile {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;
  final String? phone;
  final String? email;
  final bool isActive;
  final String? description;
  final List<String> amenities;

  HotelProfile({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
    this.phone,
    this.email,
    this.isActive = true,
    this.description,
    this.amenities = const [],
  });

  factory HotelProfile.fromJson(Map<String, dynamic> json) {
    print('─────────────────────────────────────');
    print('Parsing hotel JSON: $json');

    // Extract ID from serviceProviderId (the actual field from API)
    String id = '';
    if (json.containsKey('serviceProviderId')) {
      id = json['serviceProviderId'].toString();
    } else {
      id = _extractField(json, [
        'id',
        'service_provider_id',
        'hotelId',
        'hotel_id',
        '_id'
      ]) ?? 'unknown_id';
    }

    // Extract name from hotelName (the actual field from API)
    String name = '';
    if (json.containsKey('hotelName')) {
      name = json['hotelName'].toString();
    } else {
      name = _extractField(json, [
        'hotel_name',
        'name',
        'hotelName',
        'title'
      ]) ?? 'Unknown Hotel';
    }

    // Extract location
    String location = _extractField(json, [
      'location',
      'address',
      'city',
      'district',
      'area'
    ]) ?? 'Unknown Location';

    // Extract image URL from hotelPhoto (the actual field from API)
    String? imageUrl = '';
    if (json.containsKey('hotelPhoto')) {
      imageUrl = json['hotelPhoto']?.toString();
    } else {
      imageUrl = _extractField(json, [
        'hotel_photo',
        'hotel_image',
        'imageUrl',
        'profileImageUrl',
        'image',
        'photo',
        'image_url',
        'photoUrl'
      ]);
    }

    // Extract phone from contactInfo (the actual field from API)
    String? phone = '';
    if (json.containsKey('contactInfo') && json['contactInfo'] is Map) {
      final contactInfo = json['contactInfo'] as Map<String, dynamic>;
      phone = contactInfo['phone']?.toString();
    } else {
      phone = _extractField(json, [
        'phone',
        'phone_number',
        'contact_number',
        'telephone'
      ]);
    }

    // Extract email from contactInfo (the actual field from API)
    String? email = '';
    if (json.containsKey('contactInfo') && json['contactInfo'] is Map) {
      final contactInfo = json['contactInfo'] as Map<String, dynamic>;
      email = contactInfo['email']?.toString();
    } else {
      email = _extractField(json, [
        'email',
        'contact_email',
        'email_address'
      ]);
    }

    // Extract description
    String? description = _extractField(json, [
      'description',
      'about',
      'details',
      'info'
    ]);

    // Extract amenities
    List<String> amenities = [];
    if (json['amenities'] is List) {
      amenities = (json['amenities'] as List).map((item) => item.toString()).toList();
    }

    // Default to active since the API doesn't provide this field
    bool isActive = true;

    print('✓ Extracted Hotel Profile:');
    print('  ID: $id');
    print('  Name: $name');
    print('  Location: $location');
    print('  Description: ${description ?? "null"}');
    print('  Phone: ${phone ?? "null"}');
    print('  Email: ${email ?? "null"}');
    print('  Active: $isActive');
    print('  Image: ${imageUrl ?? "null"}');
    print('  Amenities: ${amenities.length} items: $amenities');
    print('─────────────────────────────────────');

    return HotelProfile(
      id: id,
      name: name,
      location: location,
      imageUrl: imageUrl,
      phone: phone,
      email: email,
      isActive: isActive,
      description: description,
      amenities: amenities,
    );
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
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'phone': phone,
      'email': email,
      'isActive': isActive,
      'description': description,
      'amenities': amenities,
    };
  }

  HotelProfile copyWith({
    String? id,
    String? name,
    String? location,
    String? imageUrl,
    String? phone,
    String? email,
    bool? isActive,
    String? description,
    List<String>? amenities,
  }) {
    return HotelProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
    );
  }

  @override
  String toString() {
    return 'HotelProfile(id: $id, name: $name, location: $location, phone: $phone, active: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HotelProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Response wrapper for hotel profile API
class HotelProfileResponse {
  final bool success;
  final String message;
  final HotelProfile? hotel;
  final List<HotelProfile>? hotels;

  HotelProfileResponse({
    required this.success,
    required this.message,
    this.hotel,
    this.hotels,
  });

  factory HotelProfileResponse.fromJson(Map<String, dynamic> json) {
    return HotelProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      hotel: json['hotel'] != null ? HotelProfile.fromJson(json['hotel']) : null,
      hotels: json['hotels'] != null
          ? (json['hotels'] as List).map((h) => HotelProfile.fromJson(h)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'hotel': hotel?.toJson(),
      'hotels': hotels?.map((h) => h.toJson()).toList(),
    };
  }
}