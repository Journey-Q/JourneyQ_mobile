import 'dart:convert';
import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:dio/dio.dart';

class AgencyRepository {
  // Agency Profile API endpoints
  static const String _agencyProfilesBasePath = '/service/agency-profiles';
  static const String _providersBasePath = '/service/providers';

  /// Get agency profile by ID
  static Future<AgencyProfile> getAgencyProfileById(String agencyId) async {
    try {
      print('📡 Fetching agency profile for ID: $agencyId');

      // Convert agencyId to Long for API
      final longAgencyId = int.tryParse(agencyId);
      if (longAgencyId == null) {
        throw ServerException('Invalid agency ID format: $agencyId');
      }

      Response response;

      // First try the agency-profiles endpoint (primary endpoint)
      try {
        response = await MarketplaceService.get('$_agencyProfilesBasePath/$longAgencyId');
        print('✅ Successfully fetched from agency-profiles endpoint');
      } catch (e) {
        print('⚠ Agency-profiles endpoint failed, trying providers endpoint: $e');
        response = await MarketplaceService.get('$_providersBasePath/$longAgencyId');
        print('✅ Successfully fetched from providers endpoint');
      }

      if (response.statusCode == 200) {
        print('✅ Agency profile fetched successfully');
        print('📦 Raw response data: ${response.data}');

        // Handle response data
        Map<String, dynamic> responseData;
        if (response.data is Map<String, dynamic>) {
          responseData = response.data as Map<String, dynamic>;
        } else if (response.data is String) {
          responseData = json.decode(response.data);
        } else {
          responseData = {'data': response.data};
        }

        print('🔍 Response keys: ${responseData.keys.toList()}');

        // Extract agency data - handle different response structures
        Map<String, dynamic> agencyData;
        if (responseData.containsKey('data')) {
          agencyData = responseData['data'] as Map<String, dynamic>;
        } else {
          agencyData = responseData;
        }

        print('🎯 Agency data keys: ${agencyData.keys.toList()}');
        print('📊 Agency data values:');
        agencyData.forEach((key, value) {
          print('   $key: $value (${value.runtimeType})');
        });

        return AgencyProfile.fromJson(agencyData);
      } else {
        print('❌ Failed to fetch agency profile: ${response.statusCode}');
        print('❌ Response: ${response.data}');
        throw ServerException('Failed to fetch agency profile: ${response.statusCode}');
      }
    } on AppException catch (e) {
      print('❌ AppException in getAgencyProfileById: $e');
      rethrow;
    } catch (e) {
      print('❌ Error fetching agency profile: $e');
      throw ServerException('Failed to fetch agency profile: $e');
    }
  }

  /// Get all agency profiles
  static Future<List<AgencyProfile>> getAllAgencyProfiles() async {
    try {
      print('📡 Fetching all agency profiles from: $_agencyProfilesBasePath/all');

      final response = await MarketplaceService.get('$_agencyProfilesBasePath/all');

      print('✅ Get All Agencies Response Status: ${response.statusCode}');
      print('📦 Raw Response Type: ${response.data.runtimeType}');

      List<dynamic> agencyData = [];

      // Handle different response formats
      if (response.statusCode == 200) {
        if (response.data is List) {
          agencyData = response.data as List<dynamic>;
          print('✅ Response is directly a List with ${agencyData.length} items');
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          print('🔍 Response Map keys: ${responseMap.keys.toList()}');

          // Try to extract agency data from common response structures
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            agencyData = responseMap['data'] as List<dynamic>;
            print('✅ Found agencies in data field: ${agencyData.length} items');
          } else if (responseMap.containsKey('agencies') && responseMap['agencies'] is List) {
            agencyData = responseMap['agencies'] as List<dynamic>;
            print('✅ Found agencies in agencies field: ${agencyData.length} items');
          } else if (responseMap.containsKey('content') && responseMap['content'] is List) {
            agencyData = responseMap['content'] as List<dynamic>;
            print('✅ Found agencies in content field: ${agencyData.length} items');
          } else {
            // Try to find any list in the response
            agencyData = _findListInResponse(responseMap);
            if (agencyData.isNotEmpty) {
              print('✅ Found list recursively with ${agencyData.length} items');
            }
          }
        } else {
          print('⚠ Unexpected response format: ${response.data.runtimeType}');
        }
      } else {
        print('❌ API returned error status: ${response.statusCode}');
        throw ServerException('API returned status: ${response.statusCode}');
      }

      if (agencyData.isEmpty) {
        print('⚠ No agency data found in response');
        return [];
      }

      // Parse agency data
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
          print('❌ Error parsing agency at index $i: $e');
          print('⚠ Problematic data: ${agencyData[i]}');
        }
      }

      print('✅ Successfully parsed ${agencies.length} out of ${agencyData.length} agencies');
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
      print('🚀 Fetching popular agencies with limit: $limit');

      final allAgencies = await getAllAgencyProfiles();
      print('📊 Total agencies fetched: ${allAgencies.length}');

      if (allAgencies.isEmpty) {
        print('⚠ No agencies found, returning empty list');
        return [];
      }

      // Filter active agencies and take the limit
      final activeAgencies = allAgencies.where((agency) => agency.isActive).toList();
      final popularAgencies = activeAgencies.take(limit).toList();

      print('✅ Returning ${popularAgencies.length} popular agencies');
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
          (agency.address != null && agency.address!.toLowerCase().contains(query.toLowerCase())) ||
          (agency.location != null && agency.location!.toLowerCase().contains(query.toLowerCase()))
      ).toList();

      print('🔍 Search found ${searchResults.length} agencies for query: $query');
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
      (agency.location != null && agency.location!.toLowerCase().contains(location.toLowerCase())) ||
          (agency.address != null && agency.address!.toLowerCase().contains(location.toLowerCase()))
      ).toList();

      print('📍 Found ${filteredAgencies.length} agencies in $location');
      return filteredAgencies;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch agencies by location: $e');
    }
  }

  /// Get vehicles for agency
  static Future<List<dynamic>> getAgencyVehicles(String agencyId) async {
    try {
      print('🚗 Fetching vehicles for agency: $agencyId');

      final serviceProviderId = int.tryParse(agencyId);
      if (serviceProviderId == null) {
        print('⚠ Invalid agency ID for vehicles: $agencyId');
        return [];
      }

      final response = await MarketplaceService.get('/service/vehicles/service-provider/$serviceProviderId');

      if (response.statusCode == 200) {
        List<dynamic> vehicles = [];

        if (response.data is List) {
          vehicles = response.data as List<dynamic>;
          print('✅ Loaded ${vehicles.length} vehicles directly from list');
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            vehicles = responseMap['data'] as List<dynamic>;
            print('✅ Loaded ${vehicles.length} vehicles from data field');
          } else if (responseMap.containsKey('vehicles') && responseMap['vehicles'] is List) {
            vehicles = responseMap['vehicles'] as List<dynamic>;
            print('✅ Loaded ${vehicles.length} vehicles from vehicles field');
          } else if (responseMap.containsKey('content') && responseMap['content'] is List) {
            vehicles = responseMap['content'] as List<dynamic>;
            print('✅ Loaded ${vehicles.length} vehicles from content field');
          }
        }

        if (vehicles.isEmpty) {
          print('⚠ No vehicles found for agency $agencyId');
          // Return sample data for demonstration
          vehicles = _getSampleVehicles();
        }

        print('✅ Total vehicles loaded: ${vehicles.length}');
        return vehicles;
      } else {
        print('⚠ Failed to load vehicles: ${response.statusCode}');
        // Return sample data for demonstration
        return _getSampleVehicles();
      }
    } catch (e) {
      print('❌ Error loading vehicles: $e');
      // Return sample data for demonstration
      return _getSampleVehicles();
    }
  }

  /// Get drivers for agency
  static Future<List<dynamic>> getAgencyDrivers(String agencyId) async {
    try {
      print('👨‍💼 Fetching drivers for agency: $agencyId');

      final serviceProviderId = int.tryParse(agencyId);
      if (serviceProviderId == null) {
        print('⚠ Invalid agency ID for drivers: $agencyId');
        return [];
      }

      final response = await MarketplaceService.get('/service/drivers/service-provider/$serviceProviderId');

      if (response.statusCode == 200) {
        List<dynamic> drivers = [];

        if (response.data is List) {
          drivers = response.data as List<dynamic>;
          print('✅ Loaded ${drivers.length} drivers directly from list');
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            drivers = responseMap['data'] as List<dynamic>;
            print('✅ Loaded ${drivers.length} drivers from data field');
          } else if (responseMap.containsKey('drivers') && responseMap['drivers'] is List) {
            drivers = responseMap['drivers'] as List<dynamic>;
            print('✅ Loaded ${drivers.length} drivers from drivers field');
          } else if (responseMap.containsKey('content') && responseMap['content'] is List) {
            drivers = responseMap['content'] as List<dynamic>;
            print('✅ Loaded ${drivers.length} drivers from content field');
          }
        }

        if (drivers.isEmpty) {
          print('⚠ No drivers found for agency $agencyId');
          // Return sample data for demonstration
          drivers = _getSampleDrivers();
        }

        print('✅ Total drivers loaded: ${drivers.length}');
        return drivers;
      } else {
        print('⚠ Failed to load drivers: ${response.statusCode}');
        // Return sample data for demonstration
        return _getSampleDrivers();
      }
    } catch (e) {
      print('❌ Error loading drivers: $e');
      // Return sample data for demonstration
      return _getSampleDrivers();
    }
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_agencyProfilesBasePath/all');
      print('🔌 API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ API Connection Test Failed: $e');
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
          print('✅ Found list under key: $key');
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

  /// Sample vehicles data for demonstration
  static List<dynamic> _getSampleVehicles() {
    return [
      {
        'id': 1,
        'vehicleType': 'CAR',
        'type': 'Sedan',
        'capacity': 4,
        'seats': 4,
        'acPricePerKm': 50.0,
        'nonAcPricePerKm': 40.0,
        'features': ['GPS Navigation', 'Air Conditioning', 'Comfortable Seats', 'Safety Features'],
        'amenities': ['Bottled Water', 'Phone Charger'],
        'status': 'AVAILABLE'
      },
      {
        'id': 2,
        'vehicleType': 'VAN',
        'type': 'Mini Van',
        'capacity': 7,
        'seats': 7,
        'acPricePerKm': 70.0,
        'nonAcPricePerKm': 55.0,
        'features': ['Spacious Interior', 'Air Conditioning', 'Luggage Space', 'Safety Features'],
        'amenities': ['Bottled Water', 'Phone Charger', 'WiFi'],
        'status': 'AVAILABLE'
      }
    ];
  }

  /// Sample drivers data for demonstration
  static List<dynamic> _getSampleDrivers() {
    return [
      {
        'id': 1,
        'name': 'John Silva',
        'driverName': 'John Silva',
        'experience': '5 years',
        'yearsExperience': 5,
        'specialization': 'Sedan & Van',
        'vehicleType': 'All Vehicles',
        'contact': '+94 77 123 4567',
        'phone': '+94 77 123 4567',
        'languages': ['English', 'Sinhala', 'Tamil'],
        'language': 'English, Sinhala, Tamil',
        'status': 'AVAILABLE'
      },
      {
        'id': 2,
        'name': 'Kamal Perera',
        'driverName': 'Kamal Perera',
        'experience': '8 years',
        'yearsExperience': 8,
        'specialization': 'Luxury Vehicles',
        'vehicleType': 'Premium Cars',
        'contact': '+94 76 234 5678',
        'phone': '+94 76 234 5678',
        'languages': ['English', 'Sinhala'],
        'language': 'English, Sinhala',
        'status': 'AVAILABLE'
      }
    ];
  }
}

/// Agency Profile Model - UPDATED to show established year directly
class AgencyProfile {
  final String id;
  final String name;
  final String experience;
  final String? imageUrl;
  final String? location;
  final String? address;
  final String? phone;
  final String? email;
  final String? description;
  final String? establishedYear;
  final String? fleetSize;
  final bool isActive;

  AgencyProfile({
    required this.id,
    required this.name,
    required this.experience,
    this.imageUrl,
    this.location,
    this.address,
    this.phone,
    this.email,
    this.description,
    this.establishedYear,
    this.fleetSize,
    this.isActive = true,
  });

  factory AgencyProfile.fromJson(Map<String, dynamic> json) {
    print('─────────────────────────────────────');
    print('🔄 Parsing agency JSON');
    print('🔍 JSON keys: ${json.keys.toList()}');
    print('📊 JSON values:');
    json.forEach((key, value) {
      print('   $key: $value (${value.runtimeType})');
    });

    // Extract ID - try multiple possible field names
    String? extractedId;
    List<String> idKeys = [
      'id', 'agency_id', 'agencyId', '_id', 'service_provider_id', 'providerId',
      'serviceProviderId', 'userId', 'user_id'
    ];

    for (var key in idKeys) {
      if (json.containsKey(key) && json[key] != null) {
        extractedId = json[key].toString();
        print('✅ Found ID in key "$key": $extractedId');
        break;
      }
    }

    // If no ID found, try to find any numeric field that could be an ID
    if (extractedId == null) {
      for (var key in json.keys) {
        if (json[key] is num && json[key] != null) {
          extractedId = json[key].toString();
          print('✅ Found numeric ID in key "$key": $extractedId');
          break;
        }
      }
    }

    final String id = extractedId ?? 'unknown_id';
    print('🎯 Final ID: $id');

    // Extract name - prioritize agency_name from database
    String name = _extractField(json, [
      'agency_name', 'agentcy_name', 'name', 'agencyName', 'title', 'company_name', 'providerName',
      'companyName', 'businessName', 'serviceProviderName'
    ]) ?? 'Unknown Agency';

    // DEBUG: Print all fields to see what's available
    print('🔍 DEBUG - All available fields:');
    json.forEach((key, value) {
      if (key.toString().toLowerCase().contains('estab') ||
          key.toString().toLowerCase().contains('year') ||
          key.toString().toLowerCase().contains('since')) {
        print('   🎯 POTENTIAL ESTABLISHED YEAR FIELD: "$key": $value');
      }
    });

    // Extract ESTABLISHED YEAR - Check agencyInfo object first, then fallback
    String? establishedYear;
    if (json['agencyInfo'] != null && json['agencyInfo'] is Map) {
      final agencyInfo = json['agencyInfo'] as Map<String, dynamic>;
      establishedYear = _extractField(agencyInfo, ['establishedYear', 'established_year', 'year']);
    }
    establishedYear ??= _extractField(json, [
      'established_year', 'establishedYear', 'year_established', 'established',
      'founding_year', 'yearFounded', 'since_year', 'year', 'establish_year',
      'est_year', 'start_year', 'operation_year', 'since'
    ]);

    // If no established year found, try to find any numeric field that could be a year
    if (establishedYear == null) {
      for (var key in json.keys) {
        var value = json[key];
        if (value != null) {
          String stringValue = value.toString();
          // Check if this looks like a year (4-digit number between 1900-2024)
          if (_looksLikeYear(stringValue)) {
            establishedYear = stringValue;
            print('✅ Found potential year in field "$key": $establishedYear');
            break;
          }
        }
      }
    }

    // Use established year directly, or fallback
    String experience;
    if (establishedYear != null && establishedYear.isNotEmpty) {
      experience = 'Est. $establishedYear';
      print('✅ Using established year: $establishedYear');
    } else {
      experience = 'Established';
      print('⚠️ No established year found, using fallback');
    }

    // Extract PHONE NUMBER - Check contactInfo object first, then fallback
    String? phone;
    if (json['contactInfo'] != null && json['contactInfo'] is Map) {
      final contactInfo = json['contactInfo'] as Map<String, dynamic>;
      phone = _extractField(contactInfo, ['phone', 'phone_number', 'contact_number', 'telephone']);
    }
    phone ??= _extractField(json, [
      'phone', 'phone_number', 'contact_number', 'telephone', 'contactPhone',
      'mobile', 'mobile_number', 'contact', 'phone_no'
    ]);

    // Extract EMAIL - Check contactInfo object first, then fallback
    String? email;
    if (json['contactInfo'] != null && json['contactInfo'] is Map) {
      final contactInfo = json['contactInfo'] as Map<String, dynamic>;
      email = _extractField(contactInfo, ['email', 'contact_email', 'email_address']);
    }
    email ??= _extractField(json, [
      'email', 'contact_email', 'email_address', 'contactEmail',
      'business_email', 'company_email', 'email_id'
    ]);

    // Extract ADDRESS - Check contactInfo object first, then fallback
    String? address;
    if (json['contactInfo'] != null && json['contactInfo'] is Map) {
      final contactInfo = json['contactInfo'] as Map<String, dynamic>;
      address = _extractField(contactInfo, ['address', 'location', 'full_address']);
    }
    address ??= _extractField(json, [
      'address', 'location', 'full_address', 'complete_address', 'physical_address'
    ]);

    // Extract location (city/area)
    String? location = _extractField(json, [
      'location', 'city', 'district', 'area', 'serviceArea', 'operating_area',
      'operatingArea', 'service_area', 'city_name'
    ]);

    // Extract description
    String? description = _extractField(json, [
      'description', 'about', 'details', 'info', 'bio', 'companyDescription',
      'about_us', 'aboutUs', 'business_description', 'profile_description'
    ]);

    // Extract fleet size - Check agencyInfo object first, then fallback
    String? fleetSize;
    if (json['agencyInfo'] != null && json['agencyInfo'] is Map) {
      final agencyInfo = json['agencyInfo'] as Map<String, dynamic>;
      fleetSize = _extractField(agencyInfo, ['fleetSize', 'fleet_size', 'vehicleCount']);
    }
    fleetSize ??= _extractField(json, [
      'fleet_size', 'fleetSize', 'vehicle_count', 'total_vehicles',
      'number_of_vehicles', 'vehicles_count'
    ]);

    // Extract image URL with enhanced handling
    String? imageUrl = _extractImageUrl(json);

    // Extract active status
    bool isActive = true;
    List<String> activeKeys = ['is_active', 'isActive', 'active', 'isAvailable', 'available', 'status'];
    for (var key in activeKeys) {
      if (json.containsKey(key)) {
        if (json[key] is bool) {
          isActive = json[key] as bool;
          print('✅ Found active status in key "$key": $isActive');
          break;
        } else if (json[key] is String) {
          final value = (json[key] as String).toLowerCase();
          isActive = value == 'true' || value == 'active' || value == 'available' || value == '1';
          print('✅ Found active status in key "$key": $value -> $isActive');
          break;
        } else if (json[key] is int) {
          isActive = json[key] == 1;
          print('✅ Found active status in key "$key": ${json[key]} -> $isActive');
          break;
        }
      }
    }

    print('📊 FINAL Extracted Agency Data:');
    print('  ID: $id');
    print('  Name: $name');
    print('  Established Year: ${establishedYear ?? "Not available"}');
    print('  Experience: $experience');
    print('  Address: ${address ?? "Not available"}');
    print('  Phone: ${phone ?? "Not available"}');
    print('  Email: ${email ?? "Not available"}');
    print('  Location: ${location ?? "Not available"}');
    print('  Description: ${description ?? "Not available"}');
    print('  Fleet Size: ${fleetSize ?? "Not available"}');
    print('  Image: ${imageUrl ?? "Not available"}');
    print('  Active: $isActive');
    print('─────────────────────────────────────');

    return AgencyProfile(
      id: id,
      name: name,
      experience: experience,
      location: location,
      address: address,
      phone: phone,
      email: email,
      establishedYear: establishedYear,
      imageUrl: imageUrl,
      isActive: isActive,
      description: description,
      fleetSize: fleetSize,
    );
  }

  /// Check if a string looks like a year (4 digits between 1900-2024)
  static bool _looksLikeYear(String value) {
    if (value.length != 4) return false;

    try {
      int year = int.parse(value);
      return year >= 1900 && year <= DateTime.now().year;
    } catch (e) {
      return false;
    }
  }

  /// Enhanced image URL extraction with better validation
  static String? _extractImageUrl(Map<String, dynamic> json) {
    List<String> imageKeys = [
      'profilePhoto', // ✅ ADDED: Backend uses this field
      'profile_photo', 'agency_photo', 'agency_image', 'imageUrl', 'profileImageUrl',
      'image', 'photo', 'image_url', 'photoUrl', 'profile_picture', 'picture',
      'logo', 'profilePicture', 'profileImage', 'companyLogo', 'profile_pic',
      'hotelPhoto', 'hotel_photo' // Sometimes agencies might use hotel fields
    ];

    for (var key in imageKeys) {
      if (json.containsKey(key) && json[key] != null && json[key].toString().isNotEmpty) {
        String imageUrl = json[key].toString();

        // Validate the image URL
        if (_isValidImageUrl(imageUrl)) {
          print('🖼️ Found valid image URL in key "$key": $imageUrl');

          // Convert relative URL to absolute if needed
          if (!imageUrl.startsWith('http')) {
            imageUrl = 'http://10.0.2.2:8080$imageUrl';
            print('🔄 Converted to absolute URL: $imageUrl');
          }

          return imageUrl;
        } else {
          print('⚠️ Invalid image URL in key "$key": $imageUrl');
        }
      }
    }

    return null;
  }

  /// Validate image URL
  static bool _isValidImageUrl(String url) {
    if (url.isEmpty ||
        url == 'null' ||
        url == '<null>' ||
        url == 'undefined' ||
        url.trim().isEmpty) {
      return false;
    }

    // Check for common image file extensions
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp'];
    final hasValidExtension = validExtensions.any((ext) => url.toLowerCase().contains(ext));

    // Also accept URLs that might be from cloud storage or APIs
    final hasImageIndicator = url.contains('image') ||
        url.contains('photo') ||
        url.contains('cloudinary') ||
        url.contains('storage.googleapis.com') ||
        url.contains('aws') ||
        url.contains('azure');

    return hasValidExtension || hasImageIndicator;
  }

  /// Helper method to extract field from JSON with multiple possible keys
  static String? _extractField(Map<String, dynamic> json, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (json.containsKey(key) && json[key] != null && json[key].toString().isNotEmpty) {
        final value = json[key].toString();
        print('✅ Found field in key "$key": $value');
        return value;
      }
    }
    return null;
  }

  /// Get formatted experience text
  String get formattedExperience {
    return experience;
  }

  /// Get formatted established info
  String get formattedEstablished {
    if (establishedYear != null) {
      return 'Est. $establishedYear';
    }
    return 'Established';
  }

  /// Get formatted fleet info
  String get formattedFleet {
    if (fleetSize != null) {
      return '$fleetSize Vehicles';
    }
    return 'Professional Fleet';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'experience': experience,
      'location': location,
      'address': address,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'phone': phone,
      'email': email,
      'description': description,
      'establishedYear': establishedYear,
      'fleetSize': fleetSize,
    };
  }

  @override
  String toString() {
    return 'AgencyProfile(id: $id, name: $name, experience: $experience, establishedYear: $establishedYear, address: $address, phone: $phone, email: $email)';
  }
}