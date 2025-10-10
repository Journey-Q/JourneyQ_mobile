import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:dio/dio.dart';

class HomepageRepository {
  static final authProvider = AuthProvider();

  // API endpoints
  static const String _hotelProfilesBasePath = '/service/hotel-profiles';
  static const String _agencyProfilesBasePath = '/service/agency-profiles';
  static const String _tourGuideProfilesBasePath = '/service/tour-guide-profiles';

  /// Initialize the service
  static Future<void> initialize() async {
    try {
      await MarketplaceService.initialize(authProvider);
    } catch (e) {
      throw ServerException('Failed to initialize service: $e');
    }
  }

  /// Get homepage data (all three categories) with fallback
  static Future<Map<String, dynamic>> getHomepageData() async {
    try {
      // Initialize service if not already done
      try {
        await initialize();
      } catch (e) {
        // Continue even if initialization fails
      }

      // Try to fetch all data, but continue even if some fail
      List<HotelProfile> hotels = [];
      List<TravelAgency> agencies = [];
      List<TourGuide> tourGuides = [];

      try {
        hotels = await getPopularHotels();
        print('✅ Hotels loaded: ${hotels.length}');
      } catch (e) {
        print('❌ Error loading hotels: $e');
        hotels = [];
      }

      try {
        agencies = await getPopularTravelAgencies();
        print('✅ Agencies loaded: ${agencies.length}');
      } catch (e) {
        print('❌ Error loading agencies: $e');
        agencies = [];
      }

      try {
        tourGuides = await getPopularTourGuides();
        print('✅ Tour Guides loaded: ${tourGuides.length}');
      } catch (e) {
        print('❌ Error loading tour guides: $e');
        tourGuides = [];
      }

      return {
        'hotels': hotels,
        'agencies': agencies,
        'tourGuides': tourGuides,
      };
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch homepage data: $e');
    }
  }

  /// Get popular hotels with comprehensive field mapping
  static Future<List<HotelProfile>> getPopularHotels({int limit = 6}) async {
    try {
      print('🔍 Fetching hotels from: $_hotelProfilesBasePath/all');
      final response = await MarketplaceService.get('$_hotelProfilesBasePath/all');

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> hotelData = [];

        // Extract data based on response structure
        if (response.data is List) {
          hotelData = response.data as List<dynamic>;
          print('📊 Found ${hotelData.length} hotels in list response');
        } else if (response.data is Map) {
          // Try common response wrappers
          if (response.data.containsKey('data')) {
            hotelData = response.data['data'] as List<dynamic>;
            print('📊 Found ${hotelData.length} hotels in data field');
          } else if (response.data.containsKey('hotels')) {
            hotelData = response.data['hotels'] as List<dynamic>;
            print('📊 Found ${hotelData.length} hotels in hotels field');
          } else if (response.data.containsKey('content')) {
            hotelData = response.data['content'] as List<dynamic>;
            print('📊 Found ${hotelData.length} hotels in content field');
          } else {
            // If it's a single hotel object, wrap in list
            hotelData = [response.data];
            print('📊 Single hotel object wrapped in list');
          }
        }

        // Debug: Print first hotel to see actual fields
        if (hotelData.isNotEmpty) {
          print('🔍 First hotel raw data:');
          print(hotelData[0]);
          if (hotelData[0] is Map) {
            final firstHotel = hotelData[0] as Map;
            print('🔍 First hotel keys: ${firstHotel.keys.toList()}');
            print('🔍 First hotel values:');
            firstHotel.forEach((key, value) {
              print('   $key: $value (${value.runtimeType})');
            });
          }
        } else {
          print('⚠️ No hotel data found in response');
          return [];
        }

        // Parse hotels with comprehensive field mapping
        final hotels = hotelData.map((hotelJson) {
          try {
            Map<String, dynamic> jsonMap = {};

            if (hotelJson is Map<String, dynamic>) {
              jsonMap = hotelJson;
            } else if (hotelJson is Map) {
              jsonMap = Map<String, dynamic>.from(hotelJson);
            } else {
              print('❌ Invalid hotel data type: ${hotelJson.runtimeType}');
              return null;
            }

            final hotel = HotelProfile.fromJson(jsonMap);
            print('✅ Parsed hotel: ${hotel.name}');
            return hotel;
          } catch (e) {
            print('❌ Error parsing hotel: $e');
            print('❌ Problematic hotel data: $hotelJson');
            return null;
          }
        }).where((hotel) => hotel != null).cast<HotelProfile>().toList();

        print('✅ Successfully parsed ${hotels.length} hotels');

        // Sort by rating (highest first) and limit
        hotels.sort((a, b) => b.rating.compareTo(a.rating));
        final result = hotels.take(limit).toList();

        // Debug final result
        print('🎯 Final hotel results:');
        for (var hotel in result) {
          print('🏨 ${hotel.name} | ${hotel.location} | ⭐${hotel.rating} | Image: ${hotel.imageUrl != null ? "Yes" : "No"}');
        }

        return result;

      } else {
        print('❌ API error: ${response.statusCode}');
        throw ServerException('Hotel API returned ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in getPopularHotels: $e');
      print('❌ Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  /// Get popular travel agencies
  static Future<List<TravelAgency>> getPopularTravelAgencies({int limit = 6}) async {
    try {
      print('🚗 Fetching agencies...');
      final response = await MarketplaceService.get('$_agencyProfilesBasePath/all');

      if (response.statusCode == 200) {
        List<dynamic> agencyData = [];

        if (response.data is List) {
          agencyData = response.data as List<dynamic>;
        } else if (response.data is Map) {
          if (response.data.containsKey('data')) {
            agencyData = response.data['data'] as List<dynamic>;
          } else if (response.data.containsKey('agencies')) {
            agencyData = response.data['agencies'] as List<dynamic>;
          } else if (response.data.containsKey('content')) {
            agencyData = response.data['content'] as List<dynamic>;
          } else {
            agencyData = response.data.values.where((item) => item is Map).toList();
          }
        }

        if (agencyData.isEmpty) {
          print('⚠️ No agency data found');
          return [];
        }

        final agencies = agencyData.map((agencyJson) {
          try {
            if (agencyJson is! Map<String, dynamic>) {
              if (agencyJson is Map) {
                return TravelAgency.fromJson(Map<String, dynamic>.from(agencyJson));
              }
              return null;
            }
            return TravelAgency.fromJson(agencyJson);
          } catch (e) {
            return null;
          }
        }).where((agency) => agency != null).cast<TravelAgency>().toList();

        if (agencies.isEmpty) {
          return [];
        }

        agencies.sort((a, b) => b.rating.compareTo(a.rating));
        final result = agencies.take(limit).toList();
        print('✅ Agencies loaded: ${result.length}');
        return result;
      } else {
        throw ServerException('Agency API returned ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading agencies: $e');
      return [];
    }
  }

  /// Get popular tour guides
  static Future<List<TourGuide>> getPopularTourGuides({int limit = 6}) async {
    try {
      print('👨‍🏫 Fetching tour guides...');
      final response = await MarketplaceService.get('$_tourGuideProfilesBasePath/all');

      if (response.statusCode == 200) {
        List<dynamic> tourGuideData = [];

        if (response.data is List) {
          tourGuideData = response.data as List<dynamic>;
        } else if (response.data is Map) {
          if (response.data.containsKey('data')) {
            tourGuideData = response.data['data'] as List<dynamic>;
          } else if (response.data.containsKey('tourGuides')) {
            tourGuideData = response.data['tourGuides'] as List<dynamic>;
          } else if (response.data.containsKey('content')) {
            tourGuideData = response.data['content'] as List<dynamic>;
          } else {
            tourGuideData = response.data.values.where((item) => item is Map).toList();
          }
        }

        if (tourGuideData.isEmpty) {
          print('⚠️ No tour guide data found');
          return [];
        }

        final tourGuides = tourGuideData.map((tourGuideJson) {
          try {
            if (tourGuideJson is! Map<String, dynamic>) {
              if (tourGuideJson is Map) {
                return TourGuide.fromJson(Map<String, dynamic>.from(tourGuideJson));
              }
              return null;
            }
            return TourGuide.fromJson(tourGuideJson);
          } catch (e) {
            return null;
          }
        }).where((guide) => guide != null).cast<TourGuide>().toList();

        if (tourGuides.isEmpty) {
          return [];
        }

        tourGuides.sort((a, b) => b.rating.compareTo(a.rating));
        final result = tourGuides.take(limit).toList();
        print('✅ Tour Guides loaded: ${result.length}');
        return result;
      } else {
        throw ServerException('Tour Guide API returned ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading tour guides: $e');
      return [];
    }
  }
}

// Enhanced HotelProfile model with comprehensive field mapping
class HotelProfile {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String? imageUrl;

  HotelProfile({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    this.imageUrl,
  });

  factory HotelProfile.fromJson(Map<String, dynamic> json) {
    print('🔧 Parsing hotel JSON with keys: ${json.keys.toList()}');

    // Parse ID - try multiple possible field names
    String parseId() {
      // Try all possible ID field names
      final possibleIdFields = [
        'service_provider_id',
        'id',
        'hotelId',
        'hotel_id',
        'profileId',
        'profile_id'
      ];

      for (var field in possibleIdFields) {
        if (json[field] != null) {
          final id = json[field].toString();
          print('   🆔 Using ID from $field: $id');
          return id;
        }
      }

      // Fallback: generate unique ID
      final fallbackId = 'hotel-${DateTime.now().millisecondsSinceEpoch}';
      print('   ⚠️ No ID found, using fallback: $fallbackId');
      return fallbackId;
    }

    // Parse name - try multiple possible field names
    String parseName() {
      final possibleNameFields = [
        'hotel_name',
        'name',
        'hotelName',
        'title',
        'hotelTitle',
        'establishment_name'
      ];

      for (var field in possibleNameFields) {
        if (json[field] != null && json[field].toString().isNotEmpty) {
          final name = json[field].toString();
          print('   🏷️ Using name from $field: $name');
          return name;
        }
      }

      print('   ⚠️ No name found, using fallback');
      return 'Unknown Hotel';
    }

    // Parse location - try multiple possible field names
    String parseLocation() {
      final possibleLocationFields = [
        'location',
        'address',
        'city',
        'district',
        'area',
        'establishment_location'
      ];

      for (var field in possibleLocationFields) {
        if (json[field] != null && json[field].toString().isNotEmpty) {
          final location = json[field].toString();
          print('   📍 Using location from $field: $location');
          return location;
        }
      }

      print('   ⚠️ No location found, using fallback');
      return 'Unknown Location';
    }

    // Parse rating - try multiple possible field names with default
    double parseRating() {
      final possibleRatingFields = [
        'rating',
        'average_rating',
        'averageRating',
        'star_rating',
        'starRating',
        'review_rating'
      ];

      for (var field in possibleRatingFields) {
        if (json[field] != null) {
          try {
            double rating;
            if (json[field] is double) {
              rating = json[field];
            } else if (json[field] is int) {
              rating = json[field].toDouble();
            } else if (json[field] is String) {
              rating = double.tryParse(json[field]) ?? 4.0;
            } else {
              continue;
            }
            print('   ⭐ Using rating from $field: $rating');
            return rating;
          } catch (e) {
            continue;
          }
        }
      }

      print('   ⚠️ No rating found, using default 4.0');
      return 4.0; // Default rating
    }

    // Parse image URL - try multiple possible field names
    String? parseImageUrl() {
      final possibleImageFields = [
        'hotel_photo',
        'imageUrl',
        'image_url',
        'image',
        'photo',
        'profile_image',
        'profile_image_url',
        'hotel_image',
        'main_photo'
      ];

      for (var field in possibleImageFields) {
        if (json[field] != null && json[field].toString().isNotEmpty) {
          final imageUrl = json[field].toString();
          print('   🖼️ Using image from $field: $imageUrl');
          return imageUrl;
        }
      }

      print('   ⚠️ No image URL found');
      return null;
    }

    final hotel = HotelProfile(
      id: parseId(),
      name: parseName(),
      location: parseLocation(),
      rating: parseRating(),
      imageUrl: parseImageUrl(),
    );

    print('   ✅ Created Hotel: ${hotel.name}');
    return hotel;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'HotelProfile(id: $id, name: $name, location: $location, rating: $rating, imageUrl: $imageUrl)';
  }
}

class TravelAgency {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviewCount;
  final String? description;
  final String? imageUrl;
  final List<String> services;
  final String contactNumber;
  final String email;
  final String? website;
  final int yearsOfExperience;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TravelAgency({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.description,
    this.imageUrl,
    required this.services,
    required this.contactNumber,
    required this.email,
    this.website,
    required this.yearsOfExperience,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TravelAgency.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic id) {
      if (id == null) return 'unknown-${DateTime.now().millisecondsSinceEpoch}';
      if (id is String) return id;
      return id.toString();
    }

    double parseRating(dynamic rating) {
      if (rating == null) return 0.0;
      if (rating is double) return rating;
      if (rating is int) return rating.toDouble();
      if (rating is String) return double.tryParse(rating) ?? 0.0;
      return 0.0;
    }

    int parseReviewCount(dynamic count) {
      if (count == null) return 0;
      if (count is int) return count;
      if (count is String) return int.tryParse(count) ?? 0;
      return 0;
    }

    String? parseImageUrl(Map<String, dynamic> json) {
      return json['imageUrl'] ??
          json['profileImageUrl'] ??
          json['image'];
    }

    List<String> parseServices(dynamic services) {
      if (services == null) return [];
      if (services is List) {
        return services.map((item) => item.toString()).toList();
      }
      return [];
    }

    int parseExperience(dynamic experience) {
      if (experience == null) return 1;
      if (experience is int) return experience;
      if (experience is String) return int.tryParse(experience) ?? 1;
      return 1;
    }

    return TravelAgency(
      id: parseId(json['id']),
      name: json['name']?.toString() ?? 'Unknown Agency',
      location: json['location']?.toString() ?? 'Unknown Location',
      rating: parseRating(json['rating'] ?? json['averageRating']),
      reviewCount: parseReviewCount(json['reviewCount'] ?? json['totalReviews']),
      description: json['description']?.toString(),
      imageUrl: parseImageUrl(json),
      services: parseServices(json['services']),
      contactNumber: json['contactNumber']?.toString() ??
          json['phone']?.toString() ??
          'Not available',
      email: json['email']?.toString() ?? 'Not available',
      website: json['website']?.toString(),
      yearsOfExperience: parseExperience(json['yearsOfExperience']),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ??
            json['updated_at'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  String get experienceText {
    if (yearsOfExperience >= 15) return '15+ years experience';
    if (yearsOfExperience >= 10) return '10+ years experience';
    if (yearsOfExperience >= 5) return '5+ years experience';
    return '$yearsOfExperience years experience';
  }
}

class TourGuide {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviewCount;
  final String? description;
  final String? imageUrl;
  final List<String>? specialties;
  final String contactNumber;
  final String email;
  final double hourlyRate;
  final List<String> languages;
  final int yearsOfExperience;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TourGuide({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.description,
    this.imageUrl,
    this.specialties,
    required this.contactNumber,
    required this.email,
    required this.hourlyRate,
    required this.languages,
    required this.yearsOfExperience,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TourGuide.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic id) {
      if (id == null) return 'unknown-${DateTime.now().millisecondsSinceEpoch}';
      if (id is String) return id;
      return id.toString();
    }

    double parseRating(dynamic rating) {
      if (rating == null) return 0.0;
      if (rating is double) return rating;
      if (rating is int) return rating.toDouble();
      if (rating is String) return double.tryParse(rating) ?? 0.0;
      return 0.0;
    }

    int parseReviewCount(dynamic count) {
      if (count == null) return 0;
      if (count is int) return count;
      if (count is String) return int.tryParse(count) ?? 0;
      return 0;
    }

    String? parseImageUrl(Map<String, dynamic> json) {
      return json['imageUrl'] ??
          json['profileImageUrl'] ??
          json['image'];
    }

    List<String>? parseSpecialties(dynamic specialties) {
      if (specialties == null) return [];
      if (specialties is List) {
        return specialties.map((item) => item.toString()).toList();
      }
      return [];
    }

    double parseHourlyRate(dynamic rate) {
      if (rate == null) return 25.0;
      if (rate is double) return rate;
      if (rate is int) return rate.toDouble();
      if (rate is String) return double.tryParse(rate) ?? 25.0;
      return 25.0;
    }

    List<String> parseLanguages(dynamic languages) {
      if (languages == null) return ['English'];
      if (languages is List) {
        return languages.map((item) => item.toString()).toList();
      }
      return ['English'];
    }

    int parseExperience(dynamic experience) {
      if (experience == null) return 1;
      if (experience is int) return experience;
      if (experience is String) return int.tryParse(experience) ?? 1;
      return 1;
    }

    return TourGuide(
      id: parseId(json['id']),
      name: json['name']?.toString() ?? 'Unknown Guide',
      location: json['location']?.toString() ?? 'Unknown Location',
      rating: parseRating(json['rating'] ?? json['averageRating']),
      reviewCount: parseReviewCount(json['reviewCount'] ?? json['totalReviews']),
      description: json['description']?.toString(),
      imageUrl: parseImageUrl(json),
      specialties: parseSpecialties(json['specialties']),
      contactNumber: json['contactNumber']?.toString() ??
          json['phone']?.toString() ??
          'Not available',
      email: json['email']?.toString() ?? 'Not available',
      hourlyRate: parseHourlyRate(json['hourlyRate']),
      languages: parseLanguages(json['languages']),
      yearsOfExperience: parseExperience(json['yearsOfExperience']),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ??
            json['updated_at'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  String get priceText => '\$${hourlyRate.toStringAsFixed(0)}/hour';
}