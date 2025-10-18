import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class FeedRepository {
  // ==================== FEED OPERATIONS ====================

  /// Get personalized feed for a user with pagination
  static Future<FeedResponse> getFeed({
    required String userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('📱 Fetching feed for userId: $userId, page: $page, size: $size');
      final response = await ApiService.get(
        '/feed',
        queryParameters: {
          'userId': userId,
          'page': page,
          'size': size,
        },
      );

      print('✅ Feed fetched successfully: ${response.data['data']['totalPosts']} posts');
      return FeedResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      print('❌ Error fetching feed: $e');
      throw ServerException('Failed to load feed: $e');
    }
  }

  /// Refresh feed (reset to page 0)
  static Future<FeedResponse> refreshFeed({
    required String userId,
    int size = 20,
  }) async {
    return getFeed(userId: userId, page: 0, size: size);
  }
}

// ==================== MODEL CLASSES ====================

class FeedResponse {
  final List<FeedPost> posts;
  final int currentPage;
  final int pageSize;
  final int totalPosts;
  final int totalPages;
  final bool hasMore;

  FeedResponse({
    required this.posts,
    required this.currentPage,
    required this.pageSize,
    required this.totalPosts,
    required this.totalPages,
    required this.hasMore,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((post) => FeedPost.fromJson(post))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 20,
      totalPosts: json['totalPosts'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasMore: json['hasMore'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((post) => post.toJson()).toList(),
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalPosts': totalPosts,
      'totalPages': totalPages,
      'hasMore': hasMore,
    };
  }
}

class FeedPost {
  final int postId;
  final int createdById;
  final String creatorName;
  final String? creatorProfileUrl;
  final String createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByUser;
  final String journeyTitle;
  final int numberOfDays;
  final List<String> placesVisited;
  final BudgetInfo? budgetInfo;
  final List<String> travelTips;
  final List<String> transportationOptions;
  final List<HotelRecommendation> hotelRecommendations;
  final List<RestaurantRecommendation> restaurantRecommendations;
  final List<PlaceWiseContent> placeWiseContent;
  final double rankScore;

  FeedPost({
    required this.postId,
    required this.createdById,
    required this.creatorName,
    this.creatorProfileUrl,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByUser,
    required this.journeyTitle,
    required this.numberOfDays,
    required this.placesVisited,
    this.budgetInfo,
    required this.travelTips,
    required this.transportationOptions,
    required this.hotelRecommendations,
    required this.restaurantRecommendations,
    required this.placeWiseContent,
    required this.rankScore,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      postId: json['postId'] ?? 0,
      createdById: json['createdById'] ?? 0,
      creatorName: json['creatorName'] ?? 'Unknown User',
      creatorProfileUrl: json['creatorProfileUrl'],
      createdAt: json['createdAt'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
      journeyTitle: json['journeyTitle'] ?? 'Untitled Journey',
      numberOfDays: json['numberOfDays'] ?? 0,
      placesVisited: (json['placesVisited'] as List<dynamic>?)
              ?.map((place) => place.toString())
              .toList() ??
          [],
      budgetInfo: json['budgetInfo'] != null
          ? BudgetInfo.fromJson(json['budgetInfo'])
          : null,
      travelTips: (json['travelTips'] as List<dynamic>?)
              ?.map((tip) => tip.toString())
              .toList() ??
          [],
      transportationOptions: (json['transportationOptions'] as List<dynamic>?)
              ?.map((option) => option.toString())
              .toList() ??
          [],
      hotelRecommendations: (json['hotelRecommendations'] as List<dynamic>?)
              ?.map((hotel) => HotelRecommendation.fromJson(hotel))
              .toList() ??
          [],
      restaurantRecommendations:
          (json['restaurantRecommendations'] as List<dynamic>?)
                  ?.map((restaurant) =>
                      RestaurantRecommendation.fromJson(restaurant))
                  .toList() ??
              [],
      placeWiseContent: (json['placeWiseContent'] as List<dynamic>?)
              ?.map((place) => PlaceWiseContent.fromJson(place))
              .toList() ??
          [],
      rankScore: (json['rankScore'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'createdById': createdById,
      'creatorName': creatorName,
      'creatorProfileUrl': creatorProfileUrl,
      'createdAt': createdAt,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLikedByUser': isLikedByUser,
      'journeyTitle': journeyTitle,
      'numberOfDays': numberOfDays,
      'placesVisited': placesVisited,
      'budgetInfo': budgetInfo?.toJson(),
      'travelTips': travelTips,
      'transportationOptions': transportationOptions,
      'hotelRecommendations':
          hotelRecommendations.map((h) => h.toJson()).toList(),
      'restaurantRecommendations':
          restaurantRecommendations.map((r) => r.toJson()).toList(),
      'placeWiseContent': placeWiseContent.map((p) => p.toJson()).toList(),
      'rankScore': rankScore,
    };
  }

  // Helper method to get all images from place-wise content
  List<String> getAllImages() {
    return placeWiseContent
        .expand((place) => place.imageUrls)
        .where((url) => url.isNotEmpty)
        .toList();
  }

  // Helper method to get first image
  String? getFirstImage() {
    final images = getAllImages();
    return images.isNotEmpty ? images.first : null;
  }
}

class BudgetInfo {
  final String currency;
  final double totalBudget;
  final BudgetBreakdown? budgetBreakdown;
  final Map<String, double>? breakdown;

  BudgetInfo({
    required this.currency,
    required this.totalBudget,
    this.budgetBreakdown,
    this.breakdown,
  });

  factory BudgetInfo.fromJson(Map<String, dynamic> json) {
    return BudgetInfo(
      currency: json['currency'] ?? 'USD',
      totalBudget: (json['totalBudget'] ?? 0.0).toDouble(),
      budgetBreakdown: json['budgetBreakdown'] != null
          ? BudgetBreakdown.fromJson(json['budgetBreakdown'])
          : null,
      breakdown: json['breakdown'] != null
          ? Map<String, double>.from(json['breakdown']
              .map((key, value) => MapEntry(key, (value ?? 0.0).toDouble())))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'totalBudget': totalBudget,
      'budgetBreakdown': budgetBreakdown?.toJson(),
      'breakdown': breakdown,
    };
  }
}

class BudgetBreakdown {
  final double food;
  final double shopping;
  final double transport;
  final double activities;
  final double accommodation;

  BudgetBreakdown({
    required this.food,
    required this.shopping,
    required this.transport,
    required this.activities,
    required this.accommodation,
  });

  factory BudgetBreakdown.fromJson(Map<String, dynamic> json) {
    return BudgetBreakdown(
      food: (json['food'] ?? 0.0).toDouble(),
      shopping: (json['shopping'] ?? 0.0).toDouble(),
      transport: (json['transport'] ?? 0.0).toDouble(),
      activities: (json['activities'] ?? 0.0).toDouble(),
      accommodation: (json['accommodation'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food,
      'shopping': shopping,
      'transport': transport,
      'activities': activities,
      'accommodation': accommodation,
    };
  }
}

class HotelRecommendation {
  final String name;
  final double rating;
  final String location;
  final String priceRange;

  HotelRecommendation({
    required this.name,
    required this.rating,
    required this.location,
    required this.priceRange,
  });

  factory HotelRecommendation.fromJson(Map<String, dynamic> json) {
    return HotelRecommendation(
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      priceRange: json['price_range'] ?? json['priceRange'] ?? 'mid-range',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'location': location,
      'price_range': priceRange,
    };
  }
}

class RestaurantRecommendation {
  final String name;
  final double rating;
  final String cuisine;
  final String location;

  RestaurantRecommendation({
    required this.name,
    required this.rating,
    required this.cuisine,
    required this.location,
  });

  factory RestaurantRecommendation.fromJson(Map<String, dynamic> json) {
    return RestaurantRecommendation(
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      cuisine: json['cuisine'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'cuisine': cuisine,
      'location': location,
    };
  }
}

class PlaceWiseContent {
  final int placeWiseContentId;
  final String placeName;
  final double latitude;
  final double longitude;
  final String address;
  final String tripMood;
  final List<String> activities;
  final List<String> experiences;
  final List<String> imageUrls;
  final int sequenceOrder;

  PlaceWiseContent({
    required this.placeWiseContentId,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.tripMood,
    required this.activities,
    required this.experiences,
    required this.imageUrls,
    required this.sequenceOrder,
  });

  factory PlaceWiseContent.fromJson(Map<String, dynamic> json) {
    return PlaceWiseContent(
      placeWiseContentId: json['placeWiseContentId'] ?? 0,
      placeName: json['placeName'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      tripMood: json['tripMood'] ?? '',
      activities: (json['activities'] as List<dynamic>?)
              ?.map((activity) => activity.toString())
              .toList() ??
          [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((exp) => exp.toString())
              .toList() ??
          [],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((url) => url.toString())
              .toList() ??
          [],
      sequenceOrder: json['sequenceOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeWiseContentId': placeWiseContentId,
      'placeName': placeName,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'tripMood': tripMood,
      'activities': activities,
      'experiences': experiences,
      'imageUrls': imageUrls,
      'sequenceOrder': sequenceOrder,
    };
  }
}
