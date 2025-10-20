// File: lib/data/repositories/marketplace_repository/tour_package_repository.dart

import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class TourPackageRepository {
  static const String _toursBasePath = '/service/tours';

  /// Get tour package by ID - This returns all details in one call
  static Future<TourPackage> getTourPackageById(String tourId) async {
    try {
      if (tourId.isEmpty || tourId == 'unknown_id') {
        throw ServerException('Invalid tour ID');
      }

      print('🗺️ Fetching tour package for ID: $tourId');

      final response = await MarketplaceService.get('$_toursBasePath/$tourId');

      print('Get Tour by ID Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('id') || responseData.containsKey('name')) {
          return TourPackage.fromJson(responseData);
        } else if (responseData.containsKey('data') && responseData['data'] != null) {
          return TourPackage.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          return TourPackage.fromJson(responseData);
        }
      } else {
        throw ServerException('Invalid response format from server');
      }
    } on AppException catch (e) {
      print('AppException in getTourPackageById: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getTourPackageById: $e');
      throw ServerException('Failed to fetch tour package: $e');
    }
  }

  /// Get all tour packages
  static Future<List<TourPackage>> getAllTourPackages() async {
    try {
      print('Fetching all tour packages from: $_toursBasePath/all');

      final response = await MarketplaceService.get('$_toursBasePath/all');

      print('Get All Tours Raw Response: ${response.data}');
      print('Response Type: ${response.data.runtimeType}');
      print('Status Code: ${response.statusCode}');

      List<dynamic> tourData = [];

      if (response.data is List) {
        tourData = response.data as List<dynamic>;
        print('✅ Response is directly a List with ${tourData.length} items');
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        print('Response is a Map with keys: ${responseMap.keys.toList()}');

        if (responseMap.containsKey('data') && responseMap['data'] != null) {
          if (responseMap['data'] is List) {
            tourData = responseMap['data'] as List<dynamic>;
            print('✅ Found tours in data field: ${tourData.length} items');
          }
        } else if (responseMap.containsKey('tours') && responseMap['tours'] != null) {
          if (responseMap['tours'] is List) {
            tourData = responseMap['tours'] as List<dynamic>;
            print('✅ Found tours in tours field: ${tourData.length} items');
          }
        } else {
          tourData = _findListInResponse(responseMap);
          if (tourData.isNotEmpty) {
            print('✅ Found list recursively with ${tourData.length} items');
          }
        }
      } else {
        print('⚠️ Unexpected response format: ${response.data.runtimeType}');
      }

      if (tourData.isEmpty) {
        print('⚠️ No tour package data found in response');
        return [];
      }

      final tours = <TourPackage>[];

      for (var i = 0; i < tourData.length; i++) {
        try {
          if (tourData[i] is Map<String, dynamic>) {
            final tour = TourPackage.fromJson(tourData[i] as Map<String, dynamic>);
            tours.add(tour);
          } else {
            print('⚠️ Item $i is not a Map: ${tourData[i].runtimeType}');
          }
        } catch (e) {
          print('⚠️ Error parsing tour package at index $i: $e');
          print('⚠️ Problematic data: ${tourData[i]}');
        }
      }

      print('✅ Successfully parsed ${tours.length} out of ${tourData.length} tour packages');
      return tours;
    } on AppException catch (e) {
      print('❌ AppException in getAllTourPackages: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getAllTourPackages: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch tour packages: $e');
    }
  }

  /// Get popular tour packages (limited number for homepage)
  static Future<List<TourPackage>> getPopularTourPackages({int limit = 6}) async {
    try {
      print('══════════════════════════════════════');
      print('Fetching popular tour packages with limit: $limit');
      print('══════════════════════════════════════');

      final allTours = await getAllTourPackages();

      print('Total tour packages fetched: ${allTours.length}');

      if (allTours.isEmpty) {
        print('⚠️ No tour packages found, returning empty list');
        return [];
      }

      final popularTours = allTours.take(limit).toList();
      print('✅ Returning ${popularTours.length} popular tour packages');
      print('══════════════════════════════════════');

      return popularTours;
    } on AppException catch (e) {
      print('❌ AppException in getPopularTourPackages: $e');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ General Exception in getPopularTourPackages: $e');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to fetch popular tour packages: $e');
    }
  }

  /// Get tour packages by location
  static Future<List<TourPackage>> getTourPackagesByLocation(String location) async {
    try {
      final allTours = await getAllTourPackages();

      final filteredTours = allTours.where((tour) =>
          tour.location.toLowerCase().contains(location.toLowerCase())
      ).toList();

      print('Found ${filteredTours.length} tour packages in $location');
      return filteredTours;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour packages by location: $e');
    }
  }

  /// Search tour packages by name, description or location
  static Future<List<TourPackage>> searchTourPackages(String query) async {
    try {
      final allTours = await getAllTourPackages();

      final searchResults = allTours.where((tour) =>
      tour.name.toLowerCase().contains(query.toLowerCase()) ||
          tour.aboutTour.toLowerCase().contains(query.toLowerCase()) ||
          tour.location.toLowerCase().contains(query.toLowerCase())
      ).toList();

      print('Search found ${searchResults.length} tour packages for query: $query');
      return searchResults;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search tour packages: $e');
    }
  }

  /// Get featured tour packages
  static Future<List<TourPackage>> getFeaturedTourPackages({int limit = 4}) async {
    try {
      final allTours = await getAllTourPackages();
      final featuredTours = allTours.take(limit).toList();

      print('Returning ${featuredTours.length} featured tour packages');
      return featuredTours;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch featured tour packages: $e');
    }
  }

  /// Get tour packages by price range
  static Future<List<TourPackage>> getTourPackagesByPriceRange(double minPrice, double maxPrice) async {
    try {
      final allTours = await getAllTourPackages();

      final filteredTours = allTours.where((tour) {
        double? price;
        if (tour.finalPrice != null) {
          price = tour.finalPrice;
        } else if (tour.originalPrice != null) {
          price = tour.originalPrice;
        } else if (tour.pricePerPerson != null) {
          price = tour.pricePerPerson;
        }

        final effectivePrice = price ?? 0.0;
        return effectivePrice >= minPrice && effectivePrice <= maxPrice;
      }).toList();

      print('Found ${filteredTours.length} tour packages between \$$minPrice and \$$maxPrice');
      return filteredTours;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour packages by price range: $e');
    }
  }

  /// Get tour packages by duration
  static Future<List<TourPackage>> getTourPackagesByDuration(int minDays, int maxDays) async {
    try {
      final allTours = await getAllTourPackages();

      final filteredTours = allTours.where((tour) {
        if (tour.duration != null) {
          final durationMatch = RegExp(r'(\d+)').firstMatch(tour.duration!);
          if (durationMatch != null) {
            final duration = int.tryParse(durationMatch.group(1)!);
            if (duration != null) {
              return duration >= minDays && duration <= maxDays;
            }
          }
        }
        return false;
      }).toList();

      print('Found ${filteredTours.length} tour packages with duration $minDays-$maxDays days');
      return filteredTours;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour packages by duration: $e');
    }
  }

  /// Get tour packages by rating
  static Future<List<TourPackage>> getTourPackagesByRating(double minRating) async {
    try {
      final allTours = await getAllTourPackages();

      final filteredTours = allTours.where((tour) =>
      tour.rating != null && tour.rating! >= minRating
      ).toList();

      print('Found ${filteredTours.length} tour packages with rating >= $minRating');
      return filteredTours;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tour packages by rating: $e');
    }
  }

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_toursBasePath/all');
      print('Tour Package API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Tour Package API Connection Test Failed: $e');
      return false;
    }
  }

  /// Helper method to find list in response recursively
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      final value = response[key];

      if (value is List && value.isNotEmpty) {
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

/// Tour Package Model with all fields included
class TourPackage {
  final String id;
  final String name;
  final String aboutTour;
  final String location;
  final double? originalPrice;
  final double? finalPrice;
  final double? pricePerPerson;
  final int? discount;
  final String? duration;
  final String? imageUrl;
  final double? rating;
  final int? minPeople;
  final int? maxPeople;
  final String status;
  final String serviceProviderId;
  final bool isActive;
  final List<String> highlights;
  final List<String> includedItems;
  final List<String> importantNotes;
  final List<Map<String, dynamic>> itinerary;
  final List<String> photos;

  TourPackage({
    required this.id,
    required this.name,
    required this.aboutTour,
    required this.location,
    this.originalPrice,
    this.finalPrice,
    this.pricePerPerson,
    this.discount,
    this.duration,
    this.imageUrl,
    this.rating,
    this.minPeople,
    this.maxPeople,
    required this.status,
    required this.serviceProviderId,
    this.isActive = true,
    this.highlights = const [],
    this.includedItems = const [],
    this.importantNotes = const [],
    this.itinerary = const [],
    this.photos = const [],
  });

  factory TourPackage.fromJson(Map<String, dynamic> json) {
    print('─────────────────────────────────────');
    print('Parsing tour package JSON: $json');
    print('All JSON keys: ${json.keys.toList()}');

    String id = _extractField(json, ['id', 'tourId', 'tour_id', '_id']) ?? 'unknown_id';
    String name = _extractField(json, ['name', 'tourName', 'title', 'packageName']) ?? 'Unknown Tour Package';
    String aboutTour = _extractField(json, ['about_tour', 'aboutTour', 'description', 'details', 'overview', 'info']) ?? 'No description available';
    String location = _extractField(json, ['location', 'destination', 'city', 'area', 'region']) ?? '';

    double? originalPrice;
    if (json['original_price'] != null) {
      originalPrice = double.tryParse(json['original_price'].toString());
    } else if (json['originalPrice'] != null) {
      originalPrice = double.tryParse(json['originalPrice'].toString());
    }

    double? finalPrice;
    if (json['final_price'] != null) {
      finalPrice = double.tryParse(json['final_price'].toString());
    } else if (json['finalPrice'] != null) {
      finalPrice = double.tryParse(json['finalPrice'].toString());
    }

    double? pricePerPerson;
    if (json['price_per_person'] != null) {
      pricePerPerson = double.tryParse(json['price_per_person'].toString());
    } else if (json['pricePerPerson'] != null) {
      pricePerPerson = double.tryParse(json['pricePerPerson'].toString());
    }

    int? discount;
    if (json['discount'] != null) {
      discount = int.tryParse(json['discount'].toString());
    }

    String? duration = _extractField(json, ['duration', 'tour_duration', 'trip_duration']);
    String? imageUrl = _extractField(json, ['image', 'image_url', 'imageUrl', 'photo', 'photoUrl', 'packageImage', 'tour_image']);

    double? rating;
    if (json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString());
    }

    int? minPeople;
    if (json['min_people'] != null) {
      minPeople = int.tryParse(json['min_people'].toString());
    } else if (json['minPeople'] != null) {
      minPeople = int.tryParse(json['minPeople'].toString());
    }

    int? maxPeople;
    if (json['max_people'] != null) {
      maxPeople = int.tryParse(json['max_people'].toString());
    } else if (json['maxPeople'] != null) {
      maxPeople = int.tryParse(json['maxPeople'].toString());
    }

    String serviceProviderId = _extractField(json, ['service_provider_id', 'serviceProviderId', 'provider_id']) ?? 'unknown_provider';
    String status = _extractField(json, ['status', 'tour_status'])?.toUpperCase() ?? 'ACTIVE';
    bool isActive = status == 'ACTIVE' || status == 'AVAILABLE';

    List<String> highlights = _extractListFromJson(json, ['highlights', 'tour_highlights', 'key_features']);
    List<String> includedItems = _extractListFromJson(json, ['included_items', 'includedItems', 'whats_included', 'includes']);
    List<String> importantNotes = _extractListFromJson(json, ['important_notes', 'importantNotes', 'notes', 'additional_info']);
    List<Map<String, dynamic>> itinerary = _extractItineraryFromJson(json);

    // Extract photos from past_tour_images table
    List<String> photos = _extractPhotosFromJson(json, imageUrl);

    print('✅ Extracted Tour Package:');
    print('  ID: $id');
    print('  Name: $name');
    print('  Location: ${location.isEmpty ? "Not specified" : location}');
    print('  Photos: ${photos.length} items');
    print('─────────────────────────────────────');

    return TourPackage(
      id: id,
      name: name,
      aboutTour: aboutTour,
      location: location,
      originalPrice: originalPrice,
      finalPrice: finalPrice,
      pricePerPerson: pricePerPerson,
      discount: discount,
      duration: duration,
      imageUrl: imageUrl,
      rating: rating,
      minPeople: minPeople,
      maxPeople: maxPeople,
      status: status,
      serviceProviderId: serviceProviderId,
      isActive: isActive,
      highlights: highlights,
      includedItems: includedItems,
      importantNotes: importantNotes,
      itinerary: itinerary,
      photos: photos,
    );
  }

  static String? _extractField(Map<String, dynamic> json, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (json.containsKey(key) && json[key] != null) {
        final value = json[key];
        if (value is String && value.isNotEmpty) {
          return value;
        } else if (value != null) {
          return value.toString();
        }
      }
    }
    return null;
  }

  static List<String> _extractListFromJson(Map<String, dynamic> json, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (json.containsKey(key) && json[key] != null) {
        final value = json[key];
        if (value is List) {
          return value.whereType<String>().where((item) => item.isNotEmpty).toList();
        } else if (value is String) {
          return value.split(',').map((e) => e.trim()).where((item) => item.isNotEmpty).toList();
        }
      }
    }
    return [];
  }

  static List<Map<String, dynamic>> _extractItineraryFromJson(Map<String, dynamic> json) {
    for (var key in ['itinerary', 'tour_itinerary', 'schedule']) {
      if (json.containsKey(key) && json[key] != null) {
        final value = json[key];
        if (value is List) {
          return value.whereType<Map<String, dynamic>>().toList();
        }
      }
    }
    return [];
  }

  static List<String> _extractPhotosFromJson(Map<String, dynamic> json, String? mainImageUrl) {
    List<String> photos = [];

    // Check for pastTourImages array (from backend join)
    for (var key in ['pastTourImages', 'past_tour_images', 'tourImages']) {
      if (json.containsKey(key) && json[key] != null) {
        final value = json[key];
        if (value is List) {
          for (var item in value) {
            if (item is Map<String, dynamic>) {
              // Extract image_url from the past_tour_images object
              String? imgUrl = item['image_url']?.toString() ?? item['imageUrl']?.toString();
              if (imgUrl != null && imgUrl.isNotEmpty && !photos.contains(imgUrl)) {
                photos.add(imgUrl);
              }
            } else if (item is String && item.isNotEmpty && !photos.contains(item)) {
              photos.add(item);
            }
          }
        }
      }
    }

    // Also check for other photo arrays
    for (var key in ['photos', 'tour_photos', 'images', 'gallery']) {
      if (json.containsKey(key) && json[key] != null) {
        final value = json[key];
        if (value is List) {
          for (var item in value) {
            if (item is String && item.isNotEmpty && !photos.contains(item)) {
              photos.add(item);
            }
          }
        }
      }
    }

    // Add main image if available and not already in photos
    if (mainImageUrl != null && mainImageUrl.isNotEmpty && !photos.contains(mainImageUrl)) {
      photos.insert(0, mainImageUrl);
    }

    print('📸 Extracted ${photos.length} photos from JSON');
    return photos;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'aboutTour': aboutTour,
      'location': location,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'pricePerPerson': pricePerPerson,
      'discount': discount,
      'duration': duration,
      'imageUrl': imageUrl,
      'rating': rating,
      'minPeople': minPeople,
      'maxPeople': maxPeople,
      'status': status,
      'serviceProviderId': serviceProviderId,
      'isActive': isActive,
      'highlights': highlights,
      'includedItems': includedItems,
      'importantNotes': importantNotes,
      'itinerary': itinerary,
      'photos': photos,
    };
  }

  TourPackage copyWith({
    String? id,
    String? name,
    String? aboutTour,
    String? location,
    double? originalPrice,
    double? finalPrice,
    double? pricePerPerson,
    int? discount,
    String? duration,
    String? imageUrl,
    double? rating,
    int? minPeople,
    int? maxPeople,
    String? status,
    String? serviceProviderId,
    bool? isActive,
    List<String>? highlights,
    List<String>? includedItems,
    List<String>? importantNotes,
    List<Map<String, dynamic>>? itinerary,
    List<String>? photos,
  }) {
    return TourPackage(
      id: id ?? this.id,
      name: name ?? this.name,
      aboutTour: aboutTour ?? this.aboutTour,
      location: location ?? this.location,
      originalPrice: originalPrice ?? this.originalPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      discount: discount ?? this.discount,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      minPeople: minPeople ?? this.minPeople,
      maxPeople: maxPeople ?? this.maxPeople,
      status: status ?? this.status,
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      isActive: isActive ?? this.isActive,
      highlights: highlights ?? this.highlights,
      includedItems: includedItems ?? this.includedItems,
      importantNotes: importantNotes ?? this.importantNotes,
      itinerary: itinerary ?? this.itinerary,
      photos: photos ?? this.photos,
    );
  }

  @override
  String toString() {
    return 'TourPackage(id: $id, name: $name, location: $location, finalPrice: $finalPrice, photos: ${photos.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TourPackage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}