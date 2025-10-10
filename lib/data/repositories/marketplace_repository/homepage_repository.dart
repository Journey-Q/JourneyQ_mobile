import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class HomepageRepository {
  // Hotel Profile API endpoints
  static const String _hotelProfilesBasePath = '/service/hotel-profiles';

  /// Get hotel profile by ID
  static Future<HotelProfile> getHotelProfileById(String hotelId) async {
    try {
      final response = await MarketplaceService.get('$_hotelProfilesBasePath/$hotelId');

      print('Get Hotel by ID Response: ${response.data}'); // Debug log

      // Extract hotel profile data from response
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('data') && responseData['data'] != null) {
          return HotelProfile.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return HotelProfile.fromJson(responseData); // Fallback if response is not wrapped
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
      print('Fetching all hotel profiles from: $_hotelProfilesBasePath/all'); // Debug log

      final response = await MarketplaceService.get('$_hotelProfilesBasePath/all');

      print('Get All Hotels Response: ${response.data}'); // Debug log
      print('Response Type: ${response.data.runtimeType}'); // Debug log

      // Handle different response formats
      List<dynamic> hotelData;

      if (response.data is List) {
        // If response is directly a list
        hotelData = response.data as List<dynamic>;
        print('Response is a List with ${hotelData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;

        if (responseMap.containsKey('data') && responseMap['data'] != null) {
          // If response has data wrapper
          if (responseMap['data'] is List) {
            hotelData = responseMap['data'] as List<dynamic>;
            print('Response has data wrapper with ${hotelData.length} items');
          } else {
            print('Data field is not a list: ${responseMap['data']}');
            hotelData = [];
          }
        } else {
          // Try to find any list in the response
          hotelData = _findListInResponse(responseMap);
          print('Found list in response with ${hotelData.length} items');
        }
      } else {
        print('Unexpected response format: ${response.data.runtimeType}');
        hotelData = [];
      }

      if (hotelData.isEmpty) {
        print('No hotel data found in response');
        return [];
      }

      final hotels = hotelData.map((hotelJson) {
        try {
          return HotelProfile.fromJson(hotelJson as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing hotel JSON: $hotelJson, Error: $e');
          return HotelProfile(
            id: 'error',
            name: 'Error Hotel',
            location: 'Unknown Location',
            imageUrl: null,
          );
        }
      }).toList();

      print('Successfully parsed ${hotels.length} hotels');
      return hotels;
    } on AppException catch (e) {
      print('AppException in getAllHotelProfiles: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getAllHotelProfiles: $e');
      throw ServerException('Failed to fetch hotel profiles: $e');
    }
  }

  /// Helper method to find list in response
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      if (response[key] is List) {
        return response[key] as List<dynamic>;
      } else if (response[key] is Map<String, dynamic>) {
        final nestedList = _findListInResponse(response[key] as Map<String, dynamic>);
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
      print('Fetching popular hotels with limit: $limit'); // Debug log

      final allHotels = await getAllHotelProfiles();

      print('Total hotels fetched: ${allHotels.length}'); // Debug log

      // If we have hotels, return limited number
      if (allHotels.isNotEmpty) {
        final popularHotels = allHotels.take(limit).toList();
        print('Returning ${popularHotels.length} popular hotels');
        return popularHotels;
      }

      print('No hotels found, returning empty list');
      return [];
    } on AppException catch (e) {
      print('AppException in getPopularHotels: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getPopularHotels: $e');
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

  /// Get featured hotels (you can customize the logic for featuring hotels)
  static Future<List<HotelProfile>> getFeaturedHotels({int limit = 4}) async {
    try {
      final allHotels = await getAllHotelProfiles();

      // For now, just return first few hotels as featured
      // You can add custom logic later based on ratings, reviews, etc.
      final featuredHotels = allHotels.take(limit).toList();

      print('Returning ${featuredHotels.length} featured hotels');
      return featuredHotels;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch featured hotels: $e');
    }
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_hotelProfilesBasePath/all');
      return response.statusCode == 200;
    } catch (e) {
      print('API Connection Test Failed: $e');
      return false;
    }
  }
}

/// Simplified Hotel Profile Model - Only what we need for frontend
class HotelProfile {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;

  HotelProfile({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
  });

  factory HotelProfile.fromJson(Map<String, dynamic> json) {
    // Debug: Print the JSON we're trying to parse
    print('Parsing hotel JSON: $json');

    // Extract ID from various possible fields
    String id = '';
    if (json['id'] != null) {
      id = json['id'].toString();
    } else if (json['service_provider_id'] != null) {
      id = json['service_provider_id'].toString();
    } else if (json['hotelId'] != null) {
      id = json['hotelId'].toString();
    }

    // Extract name from various possible fields
    String name = 'Unknown Hotel';
    if (json['hotel_name'] != null) {
      name = json['hotel_name'].toString();
    } else if (json['name'] != null) {
      name = json['name'].toString();
    } else if (json['hotelName'] != null) {
      name = json['hotelName'].toString();
    }

    // Extract location
    String location = 'Unknown Location';
    if (json['location'] != null) {
      location = json['location'].toString();
    } else if (json['address'] != null) {
      location = json['address'].toString();
    } else if (json['city'] != null) {
      location = json['city'].toString();
    }

    // Extract image URL from various possible fields
    String? imageUrl;
    if (json['hotel_photo'] != null) {
      imageUrl = json['hotel_photo'].toString();
    } else if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl'].toString();
    } else if (json['profileImageUrl'] != null) {
      imageUrl = json['profileImageUrl'].toString();
    } else if (json['image'] != null) {
      imageUrl = json['image'].toString();
    } else if (json['photo'] != null) {
      imageUrl = json['photo'].toString();
    }

    // Print what we extracted for debugging
    print('Extracted - ID: $id, Name: $name, Location: $location, Image: $imageUrl');

    return HotelProfile(
      id: id,
      name: name,
      location: location,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
    };
  }

  HotelProfile copyWith({
    String? id,
    String? name,
    String? location,
    String? imageUrl,
  }) {
    return HotelProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'HotelProfile(id: $id, name: $name, location: $location, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HotelProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Response wrapper for hotel profile API (if needed for other endpoints)
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