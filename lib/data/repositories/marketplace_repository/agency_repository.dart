import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class AgencyRepository {
  // Agency Profile API endpoints
  static const String _agencyProfilesBasePath = '/service/agency-profiles';

  /// Get agency profile by ID
  static Future<AgencyProfile> getAgencyProfileById(String agencyId) async {
    try {
      final response = await MarketplaceService.get('$_agencyProfilesBasePath/$agencyId');

      print('Get Agency by ID Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('data') && responseData['data'] != null) {
          return AgencyProfile.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return AgencyProfile.fromJson(responseData);
        }
      } else {
        throw ServerException('Invalid response format from server');
      }
    } on AppException catch (e) {
      print('AppException in getAgencyProfileById: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getAgencyProfileById: $e');
      throw ServerException('Failed to fetch agency profile: $e');
    }
  }

  /// Get all agency profiles
  static Future<List<AgencyProfile>> getAllAgencyProfiles() async {
    try {
      print('Fetching all agency profiles from: $_agencyProfilesBasePath/all');

      final response = await MarketplaceService.get('$_agencyProfilesBasePath/all');

      print('Get All Agencies Raw Response: ${response.data}');
      print('Response Type: ${response.data.runtimeType}');
      print('Status Code: ${response.statusCode}');

      List<dynamic> agencyData = [];

      // Handle different response formats
      if (response.data is List) {
        agencyData = response.data as List<dynamic>;
        print('✓ Response is directly a List with ${agencyData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        print('Response is a Map with keys: ${responseMap.keys.toList()}');

        // Try multiple possible keys where agency data might be
        if (responseMap.containsKey('data') && responseMap['data'] != null) {
          if (responseMap['data'] is List) {
            agencyData = responseMap['data'] as List<dynamic>;
            print('✓ Found agencies in data field: ${agencyData.length} items');
          }
        } else if (responseMap.containsKey('agencies') && responseMap['agencies'] != null) {
          if (responseMap['agencies'] is List) {
            agencyData = responseMap['agencies'] as List<dynamic>;
            print('✓ Found agencies in agencies field: ${agencyData.length} items');
          }
        } else if (responseMap.containsKey('agencyProfiles') && responseMap['agencyProfiles'] != null) {
          if (responseMap['agencyProfiles'] is List) {
            agencyData = responseMap['agencyProfiles'] as List<dynamic>;
            print('✓ Found agencies in agencyProfiles field: ${agencyData.length} items');
          }
        } else {
          // Try to find any list in the response recursively
          agencyData = _findListInResponse(responseMap);
          if (agencyData.isNotEmpty) {
            print('✓ Found list recursively with ${agencyData.length} items');
          }
        }
      } else {
        print('⚠ Unexpected response format: ${response.data.runtimeType}');
      }

      if (agencyData.isEmpty) {
        print('⚠ No agency data found in response');
        return [];
      }

      // Print first item for debugging
      if (agencyData.isNotEmpty) {
        print('First agency data: ${agencyData[0]}');
      }

      final agencies = <AgencyProfile>[];

      for (var i = 0; i < agencyData.length; i++) {
        try {
          if (agencyData[i] is Map<String, dynamic>) {
            final agency = AgencyProfile.fromJson(agencyData[i] as Map<String, dynamic>);
            agencies.add(agency);
          } else {
            print('⚠ Item $i is not a Map: ${agencyData[i].runtimeType}');
          }
        } catch (e) {
          print('⚠ Error parsing agency at index $i: $e');
          print('⚠ Problematic data: ${agencyData[i]}');
        }
      }

      print('✓ Successfully parsed ${agencies.length} out of ${agencyData.length} agencies');

      if (agencies.isNotEmpty) {
        print('Sample agency: ${agencies[0]}');
      }

      return agencies;
    } on AppException catch (e) {
      print('❌ AppException in getAllAgencyProfiles: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getAllAgencyProfiles: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch agency profiles: $e');
    }
  }

  /// Get popular agencies (limited number for homepage)
  static Future<List<AgencyProfile>> getPopularAgencies({int limit = 6}) async {
    try {
      print('═══════════════════════════════════════');
      print('Fetching popular agencies with limit: $limit');
      print('═══════════════════════════════════════');

      final allAgencies = await getAllAgencyProfiles();

      print('Total agencies fetched: ${allAgencies.length}');

      if (allAgencies.isEmpty) {
        print('⚠ No agencies found, returning empty list');
        return [];
      }

      final popularAgencies = allAgencies.take(limit).toList();
      print('✓ Returning ${popularAgencies.length} popular agencies');
      print('═══════════════════════════════════════');

      return popularAgencies;
    } on AppException catch (e) {
      print('❌ AppException in getPopularAgencies: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getPopularAgencies: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch popular agencies: $e');
    }
  }

  /// Search agencies by name or location
  static Future<List<AgencyProfile>> searchAgencies(String query) async {
    try {
      final allAgencies = await getAllAgencyProfiles();

      final searchResults = allAgencies.where((agency) =>
      agency.name.toLowerCase().contains(query.toLowerCase()) ||
          (agency.location != null && agency.location!.toLowerCase().contains(query.toLowerCase()))
      ).toList();

      print('Search found ${searchResults.length} agencies for query: $query');
      return searchResults;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search agencies: $e');
    }
  }

  /// Get agencies by location
  static Future<List<AgencyProfile>> getAgenciesByLocation(String location) async {
    try {
      final allAgencies = await getAllAgencyProfiles();

      final filteredAgencies = allAgencies.where((agency) =>
      agency.location != null && agency.location!.toLowerCase().contains(location.toLowerCase())
      ).toList();

      print('Found ${filteredAgencies.length} agencies in $location');
      return filteredAgencies;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch agencies by location: $e');
    }
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_agencyProfilesBasePath/all');
      print('API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('API Connection Test Failed: $e');
      return false;
    }
  }

  /// Helper method to find list in response recursively
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      final value = response[key];

      if (value is List && value.isNotEmpty) {
        // Check if the list contains maps (agency objects)
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

/// Agency Profile Model
class AgencyProfile {
  final String id;
  final String name;
  final String experience;
  final String? imageUrl;
  final String? location;
  final bool isActive;
  final String? phone;
  final String? email;
  final String? description;

  AgencyProfile({
    required this.id,
    required this.name,
    required this.experience,
    this.imageUrl,
    this.location,
    this.isActive = true,
    this.phone,
    this.email,
    this.description,
  });

  factory AgencyProfile.fromJson(Map<String, dynamic> json) {
    print('─────────────────────────────────────');
    print('Parsing agency JSON: $json');

    // Extract ID - try multiple possible field names
    String id = _extractField(json, [
      'id',
      'agency_id',
      'agencyId',
      '_id',
      'service_provider_id'
    ]) ?? 'unknown_id';

    // Extract name - try multiple possible field names
    String name = _extractField(json, [
      'agency_name',
      'name',
      'agencyName',
      'title',
      'company_name'
    ]) ?? 'Unknown Agency';

    // Extract experience - try multiple possible field names
    String experience = _extractField(json, [
      'experience',
      'years_experience',
      'experience_years',
      'yearsExperience',
      'rating'
    ]) ?? '0 years';

    // Extract location - try multiple possible field names
    String? location = _extractField(json, [
      'location',
      'address',
      'city',
      'district',
      'area'
    ]);

    // Extract image URL - try multiple possible field names with better debugging
    String? imageUrl;
    List<String> imageKeys = [
      'agency_photo',
      'agency_image',
      'imageUrl',
      'profileImageUrl',
      'image',
      'photo',
      'image_url',
      'photoUrl',
      'profile_picture',
      'picture'
    ];

    for (var key in imageKeys) {
      if (json.containsKey(key) && json[key] != null && json[key].toString().isNotEmpty) {
        imageUrl = json[key].toString();
        print('🖼️ Found image URL in key "$key": $imageUrl');
        break;
      }
    }

    // Extract phone - try multiple possible field names
    String? phone = _extractField(json, [
      'phone',
      'phone_number',
      'contact_number',
      'telephone'
    ]);

    // Extract email - try multiple possible field names
    String? email = _extractField(json, [
      'email',
      'contact_email',
      'email_address'
    ]);

    // Extract active status
    bool isActive = json['is_active'] ?? json['isActive'] ?? json['active'] ?? true;

    // Extract description
    String? description = _extractField(json, [
      'description',
      'about',
      'details',
      'info'
    ]);

    print('✓ Extracted:');
    print('  ID: $id');
    print('  Name: $name');
    print('  Experience: $experience');
    print('  Location: ${location ?? "null"}');
    print('  Phone: ${phone ?? "null"}');
    print('  Email: ${email ?? "null"}');
    print('  Active: $isActive');
    print('  Image: ${imageUrl ?? "null"}');
    print('─────────────────────────────────────');

    return AgencyProfile(
      id: id,
      name: name,
      experience: experience,
      location: location,
      imageUrl: imageUrl,
      isActive: isActive,
      phone: phone,
      email: email,
      description: description,
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
      'experience': experience,
      'location': location,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'phone': phone,
      'email': email,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'AgencyProfile(id: $id, name: $name, experience: $experience, location: $location, active: $isActive)';
  }
}