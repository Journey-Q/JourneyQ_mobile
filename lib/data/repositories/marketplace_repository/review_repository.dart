import 'package:journeyq/core/services/marketplace_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class ReviewRepository {
  // Review API endpoints
  static const String _reviewsBasePath = '/service/reviews';

  /// Get review statistics by service provider ID
  static Future<ReviewStats> getReviewStatsByServiceProviderId(String serviceProviderId) async {
    try {
      if (serviceProviderId.isEmpty) {
        throw ServerException('Invalid service provider ID');
      }

      print('📊 Fetching review statistics for service provider ID: $serviceProviderId');

      final response = await MarketplaceService.get('$_reviewsBasePath/service-provider/$serviceProviderId/stats');

      print('Get Review Stats Response: ${response.data}');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;

          // Handle different response formats
          if (responseData.containsKey('totalReviews')) {
            return ReviewStats.fromJson(responseData);
          } else if (responseData.containsKey('data') && responseData['data'] != null) {
            return ReviewStats.fromJson(responseData['data'] as Map<String, dynamic>);
          } else {
            // If no reviews exist, return empty stats
            return ReviewStats(
              totalReviews: 0,
              averageRating: 0.0,
              fiveStarCount: 0,
              fourStarCount: 0,
              threeStarCount: 0,
              twoStarCount: 0,
              oneStarCount: 0,
            );
          }
        }
      } else if (response.statusCode == 404) {
        // No reviews found for this service provider
        print('⚠️ No reviews found for service provider: $serviceProviderId');
        return ReviewStats(
          totalReviews: 0,
          averageRating: 0.0,
          fiveStarCount: 0,
          fourStarCount: 0,
          threeStarCount: 0,
          twoStarCount: 0,
          oneStarCount: 0,
        );
      }

      throw ServerException('Failed to fetch review statistics: ${response.statusCode}');
    } on AppException catch (e) {
      print('AppException in getReviewStatsByServiceProviderId: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getReviewStatsByServiceProviderId: $e');
      // Return empty stats instead of throwing error
      return ReviewStats(
        totalReviews: 0,
        averageRating: 0.0,
        fiveStarCount: 0,
        fourStarCount: 0,
        threeStarCount: 0,
        twoStarCount: 0,
        oneStarCount: 0,
      );
    }
  }

  /// Get reviews by service provider ID
  static Future<List<Review>> getReviewsByServiceProviderId(String serviceProviderId) async {
    try {
      if (serviceProviderId.isEmpty) {
        throw ServerException('Invalid service provider ID');
      }

      print('📝 Fetching reviews for service provider ID: $serviceProviderId');

      final response = await MarketplaceService.get('$_reviewsBasePath/service-provider/$serviceProviderId');

      print('Get Reviews Response: ${response.data}');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return _parseReviewsResponse(response);
      } else if (response.statusCode == 404) {
        // No reviews found
        print('⚠️ No reviews found for service provider: $serviceProviderId');
        return [];
      }

      throw ServerException('Failed to fetch reviews: ${response.statusCode}');
    } on AppException catch (e) {
      print('AppException in getReviewsByServiceProviderId: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getReviewsByServiceProviderId: $e');
      // Return empty list instead of throwing error
      return [];
    }
  }

  /// Get active reviews by service provider ID
  static Future<List<Review>> getActiveReviewsByServiceProviderId(String serviceProviderId) async {
    try {
      if (serviceProviderId.isEmpty) {
        throw ServerException('Invalid service provider ID');
      }

      print('📝 Fetching active reviews for service provider ID: $serviceProviderId');

      final response = await MarketplaceService.get('$_reviewsBasePath/service-provider/$serviceProviderId/active');

      print('Get Active Reviews Response: ${response.data}');

      if (response.statusCode == 200) {
        return _parseReviewsResponse(response);
      } else if (response.statusCode == 404) {
        return [];
      }

      throw ServerException('Failed to fetch active reviews: ${response.statusCode}');
    } on AppException catch (e) {
      print('AppException in getActiveReviewsByServiceProviderId: $e');
      rethrow;
    } catch (e) {
      print('General Exception in getActiveReviewsByServiceProviderId: $e');
      return [];
    }
  }

  /// Helper method to parse reviews response
  static List<Review> _parseReviewsResponse(dynamic response) {
    List<dynamic> reviewData = [];

    print('Parsing reviews response...');
    print('Response data type: ${response.data.runtimeType}');

    if (response.data is List) {
      reviewData = response.data as List<dynamic>;
      print('✓ Response is directly a List with ${reviewData.length} items');
    } else if (response.data is Map<String, dynamic>) {
      final responseMap = response.data as Map<String, dynamic>;
      print('Response is a Map with keys: ${responseMap.keys.toList()}');

      // Try multiple possible keys where review data might be
      if (responseMap.containsKey('data') && responseMap['data'] != null) {
        if (responseMap['data'] is List) {
          reviewData = responseMap['data'] as List<dynamic>;
          print('✓ Found reviews in data field: ${reviewData.length} items');
        }
      } else if (responseMap.containsKey('reviews') && responseMap['reviews'] != null) {
        if (responseMap['reviews'] is List) {
          reviewData = responseMap['reviews'] as List<dynamic>;
          print('✓ Found reviews in reviews field: ${reviewData.length} items');
        }
      } else {
        // Try to find any list in the response recursively
        reviewData = _findListInResponse(responseMap);
        if (reviewData.isNotEmpty) {
          print('✓ Found list recursively with ${reviewData.length} items');
        }
      }
    } else {
      print('⚠ Unexpected response format: ${response.data.runtimeType}');
    }

    if (reviewData.isEmpty) {
      print('⚠ No review data found in response');
      return [];
    }

    final reviews = <Review>[];
    for (var i = 0; i < reviewData.length; i++) {
      try {
        if (reviewData[i] is Map<String, dynamic>) {
          final review = Review.fromJson(reviewData[i] as Map<String, dynamic>);
          reviews.add(review);
          print('✓ Parsed review $i: ${review.customerName} - ${review.rating} stars');
        } else {
          print('⚠ Item $i is not a Map: ${reviewData[i].runtimeType}');
        }
      } catch (e) {
        print('⚠ Error parsing review at index $i: $e');
        print('⚠ Problematic data: ${reviewData[i]}');
      }
    }

    print('✓ Successfully parsed ${reviews.length} out of ${reviewData.length} reviews');
    return reviews;
  }

  /// Helper method to find list in response recursively
  static List<dynamic> _findListInResponse(Map<String, dynamic> response) {
    for (var key in response.keys) {
      final value = response[key];

      if (value is List && value.isNotEmpty) {
        // Check if the list contains maps (review objects)
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

  /// Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await MarketplaceService.get('$_reviewsBasePath/all');
      print('Review API Connection Test: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Review API Connection Test Failed: $e');
      return false;
    }
  }
}

/// Review Model
class Review {
  final String id;
  final String bookingId;
  final String serviceProviderId;
  final String userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final int rating;
  final String reviewText;
  final bool isVerified;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.bookingId,
    required this.serviceProviderId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.rating,
    required this.reviewText,
    required this.isVerified,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    print('─────────────────────────────────────');
    print('Parsing review JSON: $json');

    // Extract ID
    String id = _extractField(json, [
      'id',
      'reviewId',
      '_id'
    ]) ?? 'unknown_id';

    // Extract booking ID
    String bookingId = _extractField(json, [
      'bookingId',
      'booking_id',
      'bookingId'
    ]) ?? '';

    // Extract service provider ID
    String serviceProviderId = _extractField(json, [
      'serviceProviderId',
      'service_provider_id',
      'serviceProviderId'
    ]) ?? '';

    // Extract user ID
    String userId = _extractField(json, [
      'userId',
      'user_id',
      'userId'
    ]) ?? '';

    // Extract customer details
    String customerName = _extractField(json, [
      'customerName',
      'customer_name',
      'userName',
      'user_name'
    ]) ?? 'Anonymous';

    String customerEmail = _extractField(json, [
      'customerEmail',
      'customer_email',
      'email'
    ]) ?? '';

    String customerPhone = _extractField(json, [
      'customerPhone',
      'customer_phone',
      'phone'
    ]) ?? '';

    // Extract rating
    int rating = json['rating'] ?? 5;

    // Extract review text
    String reviewText = _extractField(json, [
      'reviewText',
      'review_text',
      'comment',
      'text'
    ]) ?? '';

    // Extract verification status
    bool isVerified = json['isVerified'] ?? json['is_verified'] ?? false;

    // Extract status
    String status = _extractField(json, [
      'status',
      'reviewStatus'
    ]) ?? 'ACTIVE';

    // Extract timestamps
    DateTime createdAt = _parseDateTime(json['createdAt'] ?? json['created_at']);
    DateTime updatedAt = _parseDateTime(json['updatedAt'] ?? json['updated_at']);

    print('✓ Extracted Review:');
    print('  ID: $id');
    print('  Booking ID: $bookingId');
    print('  Service Provider ID: $serviceProviderId');
    print('  User ID: $userId');
    print('  Customer: $customerName');
    print('  Rating: $rating');
    print('  Verified: $isVerified');
    print('  Status: $status');
    print('  Created: $createdAt');
    print('─────────────────────────────────────');

    return Review(
      id: id,
      bookingId: bookingId,
      serviceProviderId: serviceProviderId,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      rating: rating,
      reviewText: reviewText,
      isVerified: isVerified,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
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

  /// Helper method to parse DateTime
  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'serviceProviderId': serviceProviderId,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'rating': rating,
      'reviewText': reviewText,
      'isVerified': isVerified,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert Review to Map for navigation (serializable)
  Map<String, dynamic> toNavigationMap() {
    return toJson();
  }

  /// Create Review from navigation map
  factory Review.fromNavigationMap(Map<String, dynamic> map) {
    return Review.fromJson(map);
  }

  Review copyWith({
    String? id,
    String? bookingId,
    String? serviceProviderId,
    String? userId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    int? rating,
    String? reviewText,
    bool? isVerified,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, rating: $rating, customer: $customerName, serviceProvider: $serviceProviderId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Review Statistics Model
class ReviewStats {
  final int totalReviews;
  final double averageRating;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;

  ReviewStats({
    required this.totalReviews,
    required this.averageRating,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      fiveStarCount: json['fiveStarCount'] ?? 0,
      fourStarCount: json['fourStarCount'] ?? 0,
      threeStarCount: json['threeStarCount'] ?? 0,
      twoStarCount: json['twoStarCount'] ?? 0,
      oneStarCount: json['oneStarCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'fiveStarCount': fiveStarCount,
      'fourStarCount': fourStarCount,
      'threeStarCount': threeStarCount,
      'twoStarCount': twoStarCount,
      'oneStarCount': oneStarCount,
    };
  }

  double get fiveStarPercentage => totalReviews > 0 ? fiveStarCount / totalReviews : 0;
  double get fourStarPercentage => totalReviews > 0 ? fourStarCount / totalReviews : 0;
  double get threeStarPercentage => totalReviews > 0 ? threeStarCount / totalReviews : 0;
  double get twoStarPercentage => totalReviews > 0 ? twoStarCount / totalReviews : 0;
  double get oneStarPercentage => totalReviews > 0 ? oneStarCount / totalReviews : 0;
}

/// Create Review Request Model
class CreateReviewRequest {
  final String bookingId;
  final String serviceProviderId;
  final int rating;
  final String reviewText;
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  CreateReviewRequest({
    required this.bookingId,
    required this.serviceProviderId,
    required this.rating,
    required this.reviewText,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'serviceProviderId': serviceProviderId,
      'rating': rating,
      'reviewText': reviewText,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
    };
  }
}

/// Update Review Request Model
class UpdateReviewRequest {
  final int? rating;
  final String? reviewText;
  final String? status;

  UpdateReviewRequest({
    this.rating,
    this.reviewText,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (rating != null) data['rating'] = rating;
    if (reviewText != null) data['reviewText'] = reviewText;
    if (status != null) data['status'] = status;
    return data;
  }
}

/// Response wrapper for review API
class ReviewResponse {
  final bool success;
  final String message;
  final Review? review;
  final List<Review>? reviews;
  final ReviewStats? stats;

  ReviewResponse({
    required this.success,
    required this.message,
    this.review,
    this.reviews,
    this.stats,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((r) => Review.fromJson(r)).toList()
          : null,
      stats: json['stats'] != null ? ReviewStats.fromJson(json['stats']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'review': review?.toJson(),
      'reviews': reviews?.map((r) => r.toJson()).toList(),
      'stats': stats?.toJson(),
    };
  }
}