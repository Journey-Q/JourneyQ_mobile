import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class BucketListRepository {
  /// Get bucket list for current authenticated user
  static Future<BucketListResponse> getBucketList() async {
    try {
      print('🗂️ Fetching bucket list for current user...');

      final response = await ApiService.get('/bucket-list');

      print('📦 Bucket list response: ${response.data}');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null) {
          return BucketListResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      throw ServerException('Invalid response format');
    } on AppException catch (e) {
      print('❌ Error fetching bucket list: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error fetching bucket list: $e');
      rethrow;
    }
  }

  /// Get bucket list for specific user
  static Future<BucketListResponse> getBucketListByUserId(int userId) async {
    try {
      print('🗂️ Fetching bucket list for user: $userId');

      final response = await ApiService.get('/bucket-list/user/$userId');

      print('📦 Bucket list response: ${response.data}');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null) {
          return BucketListResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      throw ServerException('Invalid response format');
    } on AppException catch (e) {
      print('❌ Error fetching bucket list: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error fetching bucket list: $e');
      rethrow;
    }
  }

  /// Add post to bucket list
  static Future<BucketListResponse> addToBucketList(String postId) async {
    try {
      print('➕ Adding post to bucket list: $postId');

      final response = await ApiService.post(
        '/bucket-list/add',
        data: {'postId': postId},
      );

      print('✅ Post added to bucket list');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null) {
          return BucketListResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      throw ServerException('Invalid response format');
    } on AppException catch (e) {
      print('❌ Error adding to bucket list: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error adding to bucket list: $e');
      rethrow;
    }
  }

  /// Remove post from bucket list
  static Future<BucketListResponse> removeFromBucketList(String postId) async {
    try {
      print('➖ Removing post from bucket list: $postId');

      final response = await ApiService.delete('/bucket-list/remove/$postId');

      print('✅ Post removed from bucket list');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null) {
          return BucketListResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      throw ServerException('Invalid response format');
    } on AppException catch (e) {
      print('❌ Error removing from bucket list: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error removing from bucket list: $e');
      rethrow;
    }
  }

  /// Update visited status of post in bucket list
  static Future<BucketListResponse> updateVisitedStatus(
    String postId,
    bool isVisited,
  ) async {
    try {
      print('🔄 Updating visited status: $postId -> $isVisited');

      final response = await ApiService.put(
        '/bucket-list/update-visited',
        data: {
          'postId': postId,
          'visited': isVisited,
        },
      );

      print('✅ Visited status updated');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null) {
          return BucketListResponse.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      throw ServerException('Invalid response format');
    } on AppException catch (e) {
      print('❌ Error updating visited status: $e');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error updating visited status: $e');
      rethrow;
    }
  }

  /// Check if a post is saved in bucket list
  static Future<bool> isSaved(int userId, String postId) async {
    try {
      print('🔍 Checking if post is saved: $postId');

      final response = await ApiService.get(
        '/bucket-list/is-saved',
        queryParameters: {
          'userId': userId.toString(),
          'postId': postId,
        },
      );

      print('📦 Is saved response: ${response.data}');

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          final innerData = data['data'] as Map<String, dynamic>;
          return innerData['isSaved'] as bool? ?? false;
        }
      }

      return false;
    } on AppException catch (e) {
      print('❌ Error checking if saved: $e');
      return false;
    } catch (e) {
      print('❌ Unexpected error checking if saved: $e');
      return false;
    }
  }
}

// Bucket List Response Model
class BucketListResponse {
  final int bucketListId;
  final int userId;
  final List<BucketListItem> bucketListItems;
  final String createdAt;
  final String updatedAt;

  BucketListResponse({
    required this.bucketListId,
    required this.userId,
    required this.bucketListItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BucketListResponse.fromJson(Map<String, dynamic> json) {
    return BucketListResponse(
      bucketListId: json['bucketListId'] as int,
      userId: json['userId'] as int,
      bucketListItems: (json['bucketListItems'] as List?)
              ?.map((item) => BucketListItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  // Get count of completed items
  int get completedCount =>
      bucketListItems.where((item) => item.isCompleted).length;

  // Get count of pending items
  int get pendingCount =>
      bucketListItems.where((item) => !item.isCompleted).length;
}

// Bucket List Item Model
class BucketListItem {
  final String destination;
  final String image;
  final bool isCompleted;
  final String? visitedDate;
  final String description;
  final String journeyId;

  BucketListItem({
    required this.destination,
    required this.image,
    required this.isCompleted,
    this.visitedDate,
    required this.description,
    required this.journeyId,
  });

  factory BucketListItem.fromJson(Map<String, dynamic> json) {
    return BucketListItem(
      destination: json['destination']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      visitedDate: json['visitedDate']?.toString(),
      description: json['description']?.toString() ?? '',
      journeyId: json['journeyId']?.toString() ?? '',
    );
  }

  // Parse visited date as DateTime
  DateTime? get visitedDateTime {
    if (visitedDate == null || visitedDate!.isEmpty) return null;
    try {
      return DateTime.parse(visitedDate!);
    } catch (e) {
      return null;
    }
  }
}
