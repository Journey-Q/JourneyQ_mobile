import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class TourGuideRepository {
  // Tour Guide Profile API endpoints
  static const String _tourGuideProfilesBasePath = '/service/tour-guide-profiles';

  /// Get tour guide profile by ID
  static Future<TourGuideProfile> getTourGuideProfileById(String guideId) async {
    try {
      final response = await MarketplaceService.get('$_tourGuideProfilesBasePath/$guideId');

      print('Get Tour Guide by ID Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('data') && responseData['data'] != null) {
          return TourGuideProfile.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return TourGuideProfile.fromJson(responseData);
        }
      } else {
        throw ServerException('Invalid response format from server');
      }
    } on AppException catch (e) {
      print('AppException in getTourGuideProfileById: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getTourGuideProfileById: $e');
      throw ServerException('Failed to fetch tour guide profile: $e');
    }
  }

  /// Get all tour guide profiles
  static Future<List<TourGuideProfile>> getAllTourGuideProfiles() async {
    try {
      print('Fetching all tour guide profiles from: $_tourGuideProfilesBasePath/all');

      final response = await MarketplaceService.get('$_tourGuideProfilesBasePath/all');

      print('Get All Tour Guides Raw Response: ${response.data}');
      print('Response Type: ${response.data.runtimeType}');
      print('Status Code: ${response.statusCode}');

      List<dynamic> guideData = [];

      // Handle different response formats
      if (response.data is List) {
        guideData = response.data as List<dynamic>;
        print('✓ Response is directly a List with ${guideData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        print('Response is a Map with keys: ${responseMap.keys.toList()}');

        // Try multiple possible keys where guide data might be
        if (responseMap.containsKey('data') && responseMap['data'] != null) {
          if (responseMap['data'] is List) {
            guideData = responseMap['data'] as List<dynamic>;
            print('✓ Found guides in data field: ${guideData.length} items');
          }
        } else if (responseMap.containsKey('guides') && responseMap['guides'] != null) {
          if (responseMap['guides'] is List) {
            guideData = responseMap['guides'] as List<dynamic>;
            print('✓ Found guides in guides field: ${guideData.length} items');
          }
        } else if (responseMap.containsKey('tourGuideProfiles') && responseMap['tourGuideProfiles'] != null) {
          if (responseMap['tourGuideProfiles'] is List) {
            guideData = responseMap['tourGuideProfiles'] as List<dynamic>;
            print('✓ Found guides in tourGuideProfiles field: ${guideData.length} items');
          }
        } else {
          // Try to find any list in the response recursively
          guideData = _findListInResponse(responseMap);
          if (guideData.isNotEmpty) {
            print('✓ Found list recursively with ${guideData.length} items');
          }
        }
      } else {
        print('⚠ Unexpected response format: ${response.data.runtimeType}');
      }

      if (guideData.isEmpty) {
        print('⚠ No tour guide data found in response');
        return [];
      }

      // Print first item for debugging
      if (guideData.isNotEmpty) {
        print('First tour guide data: ${guideData[0]}');
      }

      final guides = <TourGuideProfile>[];

      for (var i = 0; i < guideData.length; i++) {
        try {
          if (guideData[i] is Map<String, dynamic>) {
            final guide = TourGuideProfile.fromJson(guideData[i] as Map<String, dynamic>);
            guides.add(guide);
          } else {
            print('⚠ Item $i is not a Map: ${guideData[i].runtimeType}');
          }
        } catch (e) {
          print('⚠ Error parsing tour guide at index $i: $e');
          print('⚠ Problematic data: ${guideData[i]}');
        }
      }

      print('✓ Successfully parsed ${guides.length} out of ${guideData.length} tour guides');

      if (guides.isNotEmpty) {
        print('Sample tour guide: ${guides[0]}');
      }

      return guides;
    } on AppException catch (e) {
      print('❌ AppException in getAllTourGuideProfiles: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getAllTourGuideProfiles: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch tour guide profiles: $e');
    }
  }

  /// Get popular tour guides (limited number for homepage)
  static Future<List<TourGuideProfile>> getPopularTourGuides({int limit = 6}) async {
    try {
      print('═══════════════════════════════════════');
      print('Fetching popular tour guides with limit: $limit');
      print('═══════════════════════════════════════');

      final allGuides = await getAllTourGuideProfiles();

      print('Total tour guides fetched: ${allGuides.length}');

      if (allGuides.isEmpty) {
        print('⚠ No tour guides found, returning empty list');
        return [];
      }

      final popularGuides = allGuides.take(limit).toList();
      print('✓ Returning ${popularGuides.length} popular tour guides');
      print('═══════════════════════════════════════');

      return popularGuides;
    } on AppException catch (e) {
      print('❌ AppException in getPopularTourGuides: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getPopularTourGuides: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch popular tour guides: $e');
    }
  }

  /// Get tour guides by location
  static Future<List<TourGuideProfile>> getTourGuidesByLocation(String location) async {
    try {
      final allGuides = await getAllTourGuideProfiles();

      final filteredGuides = allGuides.where((guide) =>
      guide.location != null && guide.location!.toLowerCase().contains(location.toLowerCase())
      ).toList();

      print('Found ${filteredGuides.length} tour guides in $location');
      return filteredGuides;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour guides by location: $e');
    }
  }

  /// Search tour guides by name, specialty or location
  static Future<List<TourGuideProfile>> searchTourGuides(String query) async {
    try {
      final allGuides = await getAllTourGuideProfiles();

      final searchResults = allGuides.where((guide) =>
      guide.name.toLowerCase().contains(query.toLowerCase()) ||
          guide.specialty.toLowerCase().contains(query.toLowerCase()) ||
          (guide.location != null && guide.location!.toLowerCase().contains(query.toLowerCase()))
      ).toList();

      print('Search found ${searchResults.length} tour guides for query: $query');
      return searchResults;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search tour guides: $e');
    }
  }

  /// Get featured tour guides
  static Future<List<TourGuideProfile>> getFeaturedTourGuides({int limit = 4}) async {
    try {
      final allGuides = await getAllTourGuideProfiles();
      final featuredGuides = allGuides.take(limit).toList();

      print('Returning ${featuredGuides.length} featured tour guides');
      return featuredGuides;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch featured tour guides: $e');
    }
  }

  /// Get tour guides by specialty
  static Future<List<TourGuideProfile>> getTourGuidesBySpecialty(String specialty) async {
    try {
      final allGuides = await getAllTourGuideProfiles();

      final filteredGuides = allGuides.where((guide) =>
          guide.specialty.toLowerCase().contains(specialty.toLowerCase())
      ).toList();

      print('Found ${filteredGuides.length} tour guides with specialty: $specialty');
      return filteredGuides;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour guides by specialty: $e');
    }
  }

  /// Get highly rated tour guides
  static Future<List<TourGuideProfile>> getHighlyRatedTourGuides({double minRating = 4.0}) async {
    try {
      final allGuides = await getAllTourGuideProfiles();

      final highlyRatedGuides = allGuides.where((guide) {
        if (guide.rating != null) {
          final rating = double.tryParse(guide.rating!);
          return rating != null && rating >= minRating;
        }
        return false;
      }).toList();

      print('Found ${highlyRatedGuides.length} tour guides with rating >= $minRating');
      return highlyRatedGuides;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch highly rated tour guides: $e');
    }
  }

  /// Get tour guide statistics
  static Future<TourGuideStatistics> getTourGuideStatistics() async {
    try {
      final allGuides = await getAllTourGuideProfiles();

      return TourGuideStatistics(
        totalGuides: allGuides.length,
        featuredGuides: allGuides.length > 4 ? 4 : allGuides.length,
        popularGuides: allGuides.length > 6 ? 6 : allGuides.length,
        lastUpdated: DateTime.now(),
      );
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour guide statistics: $e');
    }
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_tourGuideProfilesBasePath/all');
      print('Tour Guide API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Tour Guide API Connection Test Failed: $e');
      return false;
    }
  }

  /// Helper method to find list in response recursively
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      final value = response[key];

      if (value is List && value.isNotEmpty) {
        // Check if the list contains maps (guide objects)
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
}

/// Tour Guide Profile Model
class TourGuideProfile {
  final String id;
  final String name;
  final String specialty;
  final String? imageUrl;
  final String? location;
  final String? rating;
  final String? experience;
  final String? languages;
  final String? contactNumber;
  final String? email;

  TourGuideProfile({
    required this.id,
    required this.name,
    required this.specialty,
    this.imageUrl,
    this.location,
    this.rating,
    this.experience,
    this.languages,
    this.contactNumber,
    this.email,
  });

  factory TourGuideProfile.fromJson(Map<String, dynamic> json) {
    print('─────────────────────────────────────');
    print('Parsing tour guide JSON: $json');

    // Extract ID - try multiple possible field names
    String id = _extractField(json, [
      'id',
      'guide_id',
      'guideId',
      '_id',
      'service_provider_id'
    ]) ?? 'unknown_id';

    // Extract name - try multiple possible field names
    String name = _extractField(json, [
      'guide_name',
      'name',
      'guideName',
      'full_name',
      'title'
    ]) ?? 'Unknown Guide';

    // Extract specialty - try multiple possible field names
    String specialty = _extractField(json, [
      'specialty',
      'specialization',
      'expertise',
      'skills',
      'description'
    ]) ?? 'Tour Guide';

    // Extract location - try multiple possible field names
    String? location = _extractField(json, [
      'location',
      'address',
      'city',
      'district',
      'area',
      'base_location'
    ]);

    // Extract rating - try multiple possible field names
    String? rating = _extractField(json, [
      'rating',
      'guide_rating',
      'score',
      'review_score'
    ]);

    // Extract experience - try multiple possible field names
    String? experience = _extractField(json, [
      'experience',
      'years_experience',
      'experience_years',
      'yearsExperience'
    ]);

    // Extract languages - try multiple possible field names
    String? languages = _extractField(json, [
      'languages',
      'spoken_languages',
      'language_skills'
    ]);

    // Extract contact number
    String? contactNumber = _extractField(json, [
      'contact_number',
      'phone',
      'phone_number',
      'contact',
      'telephone'
    ]);

    // Extract email
    String? email = _extractField(json, [
      'email',
      'contact_email',
      'email_address'
    ]);

    // Extract image URL - try multiple possible field names
    String? imageUrl = _extractField(json, [
      'guide_photo',
      'guide_image',
      'imageUrl',
      'profileImageUrl',
      'image',
      'photo',
      'image_url',
      'photoUrl',
      'profile_picture'
    ]);

    print('✓ Extracted:');
    print('  ID: $id');
    print('  Name: $name');
    print('  Specialty: $specialty');
    print('  Location: ${location ?? "null"}');
    print('  Rating: ${rating ?? "null"}');
    print('  Experience: ${experience ?? "null"}');
    print('  Languages: ${languages ?? "null"}');
    print('  Contact: ${contactNumber ?? "null"}');
    print('  Email: ${email ?? "null"}');
    print('  Image: ${imageUrl ?? "null"}');
    print('─────────────────────────────────────');

    return TourGuideProfile(
      id: id,
      name: name,
      specialty: specialty,
      location: location,
      rating: rating,
      experience: experience,
      languages: languages,
      contactNumber: contactNumber,
      email: email,
      imageUrl: imageUrl,
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
      'specialty': specialty,
      'location': location,
      'rating': rating,
      'experience': experience,
      'languages': languages,
      'contactNumber': contactNumber,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  TourGuideProfile copyWith({
    String? id,
    String? name,
    String? specialty,
    String? imageUrl,
    String? location,
    String? rating,
    String? experience,
    String? languages,
    String? contactNumber,
    String? email,
  }) {
    return TourGuideProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      languages: languages ?? this.languages,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'TourGuideProfile(id: $id, name: $name, specialty: $specialty, location: $location, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TourGuideProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tour Guide Statistics Model
class TourGuideStatistics {
  final int totalGuides;
  final int featuredGuides;
  final int popularGuides;
  final DateTime lastUpdated;

  TourGuideStatistics({
    required this.totalGuides,
    required this.featuredGuides,
    required this.popularGuides,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalGuides': totalGuides,
      'featuredGuides': featuredGuides,
      'popularGuides': popularGuides,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TourGuideStatistics(totalGuides: $totalGuides, featuredGuides: $featuredGuides, popularGuides: $popularGuides, lastUpdated: $lastUpdated)';
  }
}

/// Response wrapper for tour guide profile API
class TourGuideProfileResponse {
  final bool success;
  final String message;
  final TourGuideProfile? guide;
  final List<TourGuideProfile>? guides;

  TourGuideProfileResponse({
    required this.success,
    required this.message,
    this.guide,
    this.guides,
  });

  factory TourGuideProfileResponse.fromJson(Map<String, dynamic> json) {
    return TourGuideProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      guide: json['guide'] != null ? TourGuideProfile.fromJson(json['guide']) : null,
      guides: json['guides'] != null
          ? (json['guides'] as List).map((g) => TourGuideProfile.fromJson(g)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'guide': guide?.toJson(),
      'guides': guides?.map((g) => g.toJson()).toList(),
    };
  }
}