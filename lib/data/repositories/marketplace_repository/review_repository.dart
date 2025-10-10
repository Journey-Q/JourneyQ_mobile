import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';

class ReviewRepository {
  static final authProvider = AuthProvider();

  // Cloudinary folder configuration for review images
  static const String _reviewImagesFolder = 'review_images';

  // ===================== CREATE REVIEW =====================

  /// Create a new review for a service
  static Future<Map<String, dynamic>> createReview({
    required String serviceType,
    required String serviceId,
    required int rating,
    required String comment,
    List<File>? reviewImages,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (!validateReviewData(
        serviceType: serviceType,
        serviceId: serviceId,
        rating: rating,
        comment: comment,
      )) {
        throw ValidationException('Invalid review data provided');
      }

      final reviewData = <String, dynamic>{
        'service_type': serviceType,
        'service_id': serviceId,
        'rating': rating,
        'comment': comment,
        ...?additionalData,
      };

      if (reviewImages != null && reviewImages.isNotEmpty) {
        final imageUrls = await uploadMultipleReviewImages(
          reviewImages,
          serviceType: serviceType,
          serviceId: serviceId,
        );
        reviewData['image_urls'] = imageUrls;
      }

      final response = await MarketplaceService.post(
        '/service/reviews/create',
        data: reviewData,
      );

      if (response.data != null && response.data['review'] != null) {
        await cacheReviewData(
          key: 'latest_review_${serviceType}_$serviceId',
          data: response.data['review'],
        );
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create review: $e');
    }
  }

  // ===================== GET REVIEWS =====================

  /// Get review by ID
  static Future<Map<String, dynamic>> getReviewById({
    required String reviewId,
  }) async {
    try {
      final response = await MarketplaceService.get('/service/reviews/$reviewId');

      if (response.data != null) {
        await cacheReviewData(
          key: 'review_$reviewId',
          data: response.data,
        );
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get review: $e');
    }
  }

  /// Get review by booking ID
  static Future<Map<String, dynamic>> getReviewByBookingId({
    required String bookingId,
  }) async {
    try {
      final response = await MarketplaceService.get('/service/reviews/booking/$bookingId');
      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get review by booking ID: $e');
    }
  }

  /// Get all reviews
  static Future<List<Map<String, dynamic>>> getAllReviews({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await MarketplaceService.get(
        '/service/reviews/all',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map && response.data['reviews'] != null) {
        return List<Map<String, dynamic>>.from(response.data['reviews']);
      }

      return [];
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get all reviews: $e');
    }
  }

  // Continue with all other methods, replacing ApiService with MarketplaceService
  // ... (I'll show a few more examples)

  /// Update a review
  static Future<Map<String, dynamic>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<File>? newReviewImages,
    List<String>? imagesToDelete,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final updateData = <String, dynamic>{
        ...?additionalData,
      };

      if (rating != null) updateData['rating'] = rating;
      if (comment != null) updateData['comment'] = comment;

      // Delete old images if specified
      if (imagesToDelete != null && imagesToDelete.isNotEmpty) {
        await deleteMultipleReviewImages(imagesToDelete);
        updateData['images_to_delete'] = imagesToDelete;
      }

      // Upload new images if provided
      if (newReviewImages != null && newReviewImages.isNotEmpty) {
        final imageUrls = await uploadMultipleReviewImages(
          newReviewImages,
          serviceType: 'review_update',
          serviceId: reviewId,
        );
        updateData['new_image_urls'] = imageUrls;
      }

      final response = await MarketplaceService.put(
        '/service/reviews/$reviewId',
        data: updateData,
      );

      if (response.data != null) {
        await cacheReviewData(
          key: 'review_$reviewId',
          data: response.data,
        );
      }

      return response.data;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update review: $e');
    }
  }

  /// Delete a review
  static Future<Map<String, dynamic>> deleteReview({
    required String reviewId,
  }) async {
    try {
      final response = await MarketplaceService.delete('/service/reviews/$reviewId');

      // Clear cached review data
      await clearCachedReviewData(specificKey: 'review_$reviewId');

      return response.data ?? {'message': 'Review deleted successfully'};
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete review: $e');
    }
  }

  // ===================== IMAGE HANDLING METHODS =====================

  /// Upload multiple review images to Cloudinary
  static Future<List<String>> uploadMultipleReviewImages(
      List<File> imageFiles, {
        required String serviceType,
        required String serviceId,
      }) async {
    try {
      final userId = authProvider.user?.userId ?? 'anonymous';
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final customFileNames = imageFiles.asMap().entries.map((entry) {
        final index = entry.key;
        return 'review_${serviceType}_${serviceId}_${userId}_${timestamp}_$index';
      }).toList();

      final imageUrls = await MarketplaceService.uploadMultipleImages(
        imageFiles: imageFiles,
        subfolderName: _reviewImagesFolder,
        customFileNames: customFileNames,
      );

      return imageUrls;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upload review images: $e');
    }
  }

  /// Delete multiple review images
  static Future<void> deleteMultipleReviewImages(List<String> imageUrls) async {
    try {
      await MarketplaceService.deleteMultipleImages(imageUrls: imageUrls);
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete review images: $e');
    }
  }

  // ===================== CACHING METHODS =====================

  /// Cache review data locally
  static Future<void> cacheReviewData({
    required String key,
    required Map<String, dynamic> data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('review_cache_$key', jsonEncode(data));
    } catch (e) {
      // Continue even if caching fails
    }
  }

  /// Get cached review data
  static Future<Map<String, dynamic>?> getCachedReviewData({
    required String key,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('review_cache_$key');
      if (cachedData != null) {
        return jsonDecode(cachedData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Clear cached review data
  static Future<void> clearCachedReviewData({String? specificKey}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (specificKey != null) {
        await prefs.remove('review_cache_$specificKey');
      } else {
        final keys = prefs.getKeys().where((key) => key.startsWith('review_cache_'));
        for (final key in keys) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      // Continue even if clearing cache fails
    }
  }

  // ===================== UTILITY METHODS =====================

  /// Validate review data before sending
  static bool validateReviewData({
    required String serviceType,
    required String serviceId,
    required int rating,
    required String comment,
  }) {
    if (!['hotel', 'tour_package', 'travel_agency'].contains(serviceType)) {
      return false;
    }

    if (serviceId.trim().isEmpty) return false;
    if (rating < 1 || rating > 5) return false;
    if (comment.trim().length < 10) return false;

    return true;
  }

  /// Get current user ID for operations
  static String? get currentUserId => authProvider.user?.userId?.toString();

  /// Check if user is authenticated
  static bool get isUserAuthenticated => authProvider.user != null;
}

/// Model class for Review Response
class ReviewResponse {
  final bool success;
  final String message;
  final Review? review;

  ReviewResponse({
    required this.success,
    required this.message,
    this.review,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'review': review?.toJson(),
    };
  }
}

/// Model class for Review
class Review {
  final String id;
  final String userId;
  final String serviceType;
  final String serviceId;
  final int rating;
  final String comment;
  final List<String> imageUrls;
  final String status;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.serviceId,
    required this.rating,
    required this.comment,
    required this.imageUrls,
    required this.status,
    required this.isVerified,
    required this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      serviceType: json['service_type'] ?? json['serviceType'] ?? '',
      serviceId: json['service_id']?.toString() ?? json['serviceId']?.toString() ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      imageUrls: List<String>.from(
        json['image_urls'] ?? json['imageUrls'] ?? [],
      ),
      status: json['status'] ?? 'ACTIVE',
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.parse(json['updated_at'] ?? json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_type': serviceType,
      'service_id': serviceId,
      'rating': rating,
      'comment': comment,
      'image_urls': imageUrls,
      'status': status,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Model class for Review Statistics
class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final int verifiedReviews;
  final int activeReviews;

  ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.verifiedReviews,
    required this.activeReviews,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      averageRating: (json['average_rating'] ?? json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? json['totalReviews'] ?? 0,
      ratingDistribution: Map<int, int>.from(
        json['rating_distribution'] ?? json['ratingDistribution'] ?? {},
      ),
      verifiedReviews: json['verified_reviews'] ?? json['verifiedReviews'] ?? 0,
      activeReviews: json['active_reviews'] ?? json['activeReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'rating_distribution': ratingDistribution,
      'verified_reviews': verifiedReviews,
      'active_reviews': activeReviews,
    };
  }
}

/// Custom exception for validation errors
class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}