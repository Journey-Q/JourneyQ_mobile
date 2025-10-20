import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class SearchRepository {
  // Search for users and journeys
  static Future<List<Map<String, dynamic>>> searchContent({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/search',
        queryParameters: {
          'query': query,
          'limit': limit.toString(),
        },
      );

      // Handle direct array response
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }

      // Handle wrapped response with results/data key
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['results'] != null && data['results'] is List) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      return [];
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Get all service providers (hotels, tour guides, travel agencies)
  static Future<List<ServiceProvider>> getAllServiceProviders() async {
    try {
      print('🔍 Fetching all service providers...');

      final response = await MarketplaceService.get('/service/providers/profiles/all');

      print('📦 Service providers response: ${response.data}');

      // Handle direct array response
      if (response.data is List) {
        final providers = (response.data as List)
            .map((item) => ServiceProvider.fromJson(item as Map<String, dynamic>))
            .toList();
        print('✅ Found ${providers.length} service providers');
        return providers;
      }

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null && data['data'] is List) {
          final providers = (data['data'] as List)
              .map((item) => ServiceProvider.fromJson(item as Map<String, dynamic>))
              .toList();
          print('✅ Found ${providers.length} service providers');
          return providers;
        }
      }

      return [];
    } on AppException catch (e) {
      print('❌ Error fetching service providers: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error fetching service providers: $e');
      rethrow;
    }
  }

  // Filter service providers by district (checks if district is in address)
  static List<ServiceProvider> filterByDistrict(
    List<ServiceProvider> providers,
    String district,
  ) {
    if (district.isEmpty) return providers;

    final districtLower = district.toLowerCase();
    return providers.where((provider) {
      final addressLower = provider.address.toLowerCase();
      return addressLower.contains(districtLower);
    }).toList();
  }

  // Filter by service type
  static List<ServiceProvider> filterByServiceType(
    List<ServiceProvider> providers,
    String? serviceType,
  ) {
    if (serviceType == null || serviceType.isEmpty || serviceType == 'ALL') {
      return providers;
    }

    return providers.where((provider) {
      return provider.serviceType.toUpperCase() == serviceType.toUpperCase();
    }).toList();
  }
}

// Service Provider Model
class ServiceProvider {
  final int id;
  final String username;
  final String email;
  final String businessRegistrationNumber;
  final String address;
  final String contactNo;
  final String serviceType; // HOTEL, TOUR_GUIDE, TRAVEL_AGENT
  final bool isApproved;
  final bool isActive;
  final bool isProfileCreated;
  final String createdAt;

  // Profile data (only one will be non-null based on serviceType)
  final HotelProfile? hotelProfile;
  final TourGuideProfile? tourGuideProfile;
  final AgencyProfile? agencyProfile;

  ServiceProvider({
    required this.id,
    required this.username,
    required this.email,
    required this.businessRegistrationNumber,
    required this.address,
    required this.contactNo,
    required this.serviceType,
    required this.isApproved,
    required this.isActive,
    required this.isProfileCreated,
    required this.createdAt,
    this.hotelProfile,
    this.tourGuideProfile,
    this.agencyProfile,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] as int,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      businessRegistrationNumber: json['businessRegistrationNumber']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      contactNo: json['contactNo']?.toString() ?? '',
      serviceType: json['serviceType']?.toString() ?? '',
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
      isProfileCreated: json['isProfileCreated'] ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
      hotelProfile: json['hotelProfile'] != null
          ? HotelProfile.fromJson(json['hotelProfile'] as Map<String, dynamic>)
          : null,
      tourGuideProfile: json['tourGuideProfile'] != null
          ? TourGuideProfile.fromJson(json['tourGuideProfile'] as Map<String, dynamic>)
          : null,
      agencyProfile: json['agencyProfile'] != null
          ? AgencyProfile.fromJson(json['agencyProfile'] as Map<String, dynamic>)
          : null,
    );
  }

  // Get display name based on service type
  String get displayName {
    if (hotelProfile != null) return hotelProfile!.hotelName;
    if (tourGuideProfile != null) return tourGuideProfile!.companyName;
    if (agencyProfile != null) return agencyProfile!.agencyName;
    return username;
  }

  // Get profile photo
  String? get profilePhoto {
    if (hotelProfile != null) return hotelProfile!.hotelPhoto;
    if (tourGuideProfile != null) return tourGuideProfile!.profilePhotoUrl;
    if (agencyProfile != null) return agencyProfile!.profilePhoto;
    return null;
  }

  // Get description
  String get description {
    if (hotelProfile != null) return hotelProfile!.description;
    if (tourGuideProfile != null) return tourGuideProfile!.description;
    if (agencyProfile != null) return agencyProfile!.description;
    return '';
  }

  // Get location
  String? get location {
    if (hotelProfile != null) return hotelProfile!.location;
    if (tourGuideProfile != null) return tourGuideProfile!.contactAddress;
    if (agencyProfile != null) return agencyProfile!.contactAddress;
    return address;
  }
}

// Hotel Profile Model
class HotelProfile {
  final int serviceProviderId;
  final String hotelName;
  final String location;
  final double? latitude;
  final double? longitude;
  final String description;
  final String hotelPhoto;
  final List<String> amenities;
  final String contactPhone;
  final String contactEmail;

  HotelProfile({
    required this.serviceProviderId,
    required this.hotelName,
    required this.location,
    this.latitude,
    this.longitude,
    required this.description,
    required this.hotelPhoto,
    required this.amenities,
    required this.contactPhone,
    required this.contactEmail,
  });

  factory HotelProfile.fromJson(Map<String, dynamic> json) {
    return HotelProfile(
      serviceProviderId: json['serviceProviderId'] as int,
      hotelName: json['hotelName']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description']?.toString() ?? '',
      hotelPhoto: json['hotelPhoto']?.toString() ?? '',
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'] as List)
          : [],
      contactPhone: json['contactPhone']?.toString() ?? '',
      contactEmail: json['contactEmail']?.toString() ?? '',
    );
  }
}

// Tour Guide Profile Model
class TourGuideProfile {
  final int serviceProviderId;
  final String companyName;
  final String profilePhotoUrl;
  final String description;
  final int establishedYear;
  final int numberOfGuides;
  final String contactPhone;
  final String contactEmail;
  final String contactAddress;

  TourGuideProfile({
    required this.serviceProviderId,
    required this.companyName,
    required this.profilePhotoUrl,
    required this.description,
    required this.establishedYear,
    required this.numberOfGuides,
    required this.contactPhone,
    required this.contactEmail,
    required this.contactAddress,
  });

  factory TourGuideProfile.fromJson(Map<String, dynamic> json) {
    return TourGuideProfile(
      serviceProviderId: json['serviceProviderId'] as int,
      companyName: json['companyName']?.toString() ?? '',
      profilePhotoUrl: json['profilePhotoUrl']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      establishedYear: json['establishedYear'] as int? ?? 0,
      numberOfGuides: json['numberOfGuides'] as int? ?? 0,
      contactPhone: json['contactPhone']?.toString() ?? '',
      contactEmail: json['contactEmail']?.toString() ?? '',
      contactAddress: json['contactAddress']?.toString() ?? '',
    );
  }
}

// Agency Profile Model
class AgencyProfile {
  final int serviceProviderId;
  final String agencyName;
  final String profilePhoto;
  final String description;
  final String establishedYear;
  final String fleetSize;
  final String contactPhone;
  final String contactEmail;
  final String contactAddress;

  AgencyProfile({
    required this.serviceProviderId,
    required this.agencyName,
    required this.profilePhoto,
    required this.description,
    required this.establishedYear,
    required this.fleetSize,
    required this.contactPhone,
    required this.contactEmail,
    required this.contactAddress,
  });

  factory AgencyProfile.fromJson(Map<String, dynamic> json) {
    return AgencyProfile(
      serviceProviderId: json['serviceProviderId'] as int,
      agencyName: json['agencyName']?.toString() ?? '',
      profilePhoto: json['profilePhoto']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      establishedYear: json['establishedYear']?.toString() ?? '',
      fleetSize: json['fleetSize']?.toString() ?? '',
      contactPhone: json['contactPhone']?.toString() ?? '',
      contactEmail: json['contactEmail']?.toString() ?? '',
      contactAddress: json['contactAddress']?.toString() ?? '',
    );
  }
}