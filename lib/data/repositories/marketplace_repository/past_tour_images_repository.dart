// File: lib/data/repositories/marketplace_repository/past_tour_images_repository.dart

import 'package:flutter/foundation.dart';
import 'package:journeyq/core/services/marketplace_service.dart';

// Past Tour Image Response DTO
class PastTourImageResponse {
  final int id;
  final int tourId;
  final String imageUrl;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  PastTourImageResponse({
    required this.id,
    required this.tourId,
    required this.imageUrl,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PastTourImageResponse.fromJson(Map<String, dynamic> json) {
    return PastTourImageResponse(
      id: json['id'] as int,
      tourId: json['tourId'] as int,
      imageUrl: json['imageUrl'] as String,
      orderIndex: json['orderIndex'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

// Repository
class PastTourImagesRepository {
  // Get past tour images - Endpoint: /service/tours/{tourId}/past-images
  static Future<List<PastTourImageResponse>> getPastTourImages(int tourId) async {
    try {
      debugPrint('📸 Loading past tour images for tour: $tourId');

      final response = await MarketplaceService.get(
        '/service/tours/$tourId/past-images',
      );

      debugPrint('✅ Past tour images response status: ${response.statusCode}');
      debugPrint('📦 Past tour images response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> imagesJson;

        // Handle different response formats
        if (response.data is List) {
          imagesJson = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            imagesJson = responseMap['data'] as List<dynamic>;
          } else {
            throw Exception('Unexpected response format');
          }
        } else {
          throw Exception('Unexpected response type');
        }

        final images = imagesJson
            .map((json) => PastTourImageResponse.fromJson(json as Map<String, dynamic>))
            .toList();

        // Sort by orderIndex
        images.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        debugPrint('✅ Loaded ${images.length} past tour images');
        return images;
      } else {
        throw Exception('Failed to load past tour images: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error loading past tour images: $e');
      rethrow;
    }
  }
}
