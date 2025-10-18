import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class FollowRepository {
  // ==================== FOLLOW OPERATIONS ====================

  /// Send a follow request to a user
  static Future<Map<String, dynamic>> sendFollowRequest(String userIdToFollow) async {
    try {
      final response = await ApiService.post(
        '/follow/send-request',
        data: {
          'followerId': userIdToFollow,
        },
      );

      // Cache the follow action locally for immediate UI update
      await _cacheFollowAction(userIdToFollow, 'pending');

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to send follow request: $e');
    }
  }

  /// Accept a follow request by followId (used in notifications)
  static Future<Map<String, dynamic>> acceptFollowRequestById(int followId) async {
    try {
      final response = await ApiService.post(
        '/follow/accept-request/$followId',
      );

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to accept follow request: $e');
    }
  }

  /// Reject a follow request by followId (used in notifications)
  static Future<Map<String, dynamic>> rejectFollowRequestById(int followId) async {
    try {
      final response = await ApiService.post(
        '/follow/reject-request/$followId',
      );

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to reject follow request: $e');
    }
  }

  /// Accept a follow request by userId (legacy method)
  static Future<Map<String, dynamic>> acceptFollowRequest(String followerId) async {
    try {
      // This method is kept for backward compatibility
      // In practice, notifications should use acceptFollowRequestById
      final response = await ApiService.post(
        '/follow/accept-request/$followerId',
      );

      // Update local cache
      await _cacheFollowAction(followerId, 'accepted');

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to accept follow request: $e');
    }
  }

  /// Reject a follow request by userId (legacy method)
  static Future<Map<String, dynamic>> rejectFollowRequest(String followerId) async {
    try {
      // This method is kept for backward compatibility
      // In practice, notifications should use rejectFollowRequestById
      final response = await ApiService.post(
        '/follow/reject-request/$followerId',
      );

      // Remove from local cache
      await _removeCachedFollowAction(followerId);

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to reject follow request: $e');
    }
  }

  /// Unfollow a user
  static Future<Map<String, dynamic>> unfollowUser(String userIdToUnfollow) async {
    try {
      final response = await ApiService.delete(
        '/follow/unfollow',
        queryParameters: {
          'followerId': userIdToUnfollow,
        },
      );

      // Remove from local cache
      await _removeCachedFollowAction(userIdToUnfollow);

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to unfollow user: $e');
    }
  }

  /// Update follow status (accept/reject)
  static Future<Map<String, dynamic>> updateFollowStatus({
    required String followingId,
    required String followerId,
    required String status, // 'accepted' or 'rejected'
  }) async {
    try {
      final response = await ApiService.post(
        '/follow/update-status',
        data: {
          'followingId': followingId,
          'followerId': followerId,
          'status': status,
        },
      );

      // Update local cache
      if (status == 'accepted') {
        await _cacheFollowAction(followerId, 'accepted');
      } else {
        await _removeCachedFollowAction(followerId);
      }

      return response.data;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update follow status: $e');
    }
  }

  // ==================== GET FOLLOW DATA ====================

  /// Get current user's followers with pagination
  static Future<FollowListResponse> getMyFollowers({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/my-followers',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return FollowListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get followers: $e');
    }
  }

  /// Get current user's following with pagination
  static Future<FollowListResponse> getMyFollowing({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/my-following',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return FollowListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get following: $e');
    }
  }

  /// Get followers of a specific user (using /followers/{userId} endpoint)
  static Future<FollowListResponse> getUserFollowers({
    required String userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('DEBUG: Calling getUserFollowers with userId: $userId, page: $page, size: $size');
      final response = await ApiService.get(
        '/follow/followers/$userId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print('DEBUG: getUserFollowers response: ${response.data}');
      return FollowListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      print('ERROR: getUserFollowers failed: $e');
      throw ServerException('Failed to get user followers: $e');
    }
  }

  /// Get following of a specific user (using /following/{userId} endpoint)
  static Future<FollowListResponse> getUserFollowing({
    required String userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('DEBUG: Calling getUserFollowing with userId: $userId, page: $page, size: $size');
      final response = await ApiService.get(
        '/follow/following/$userId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print('DEBUG: getUserFollowing response: ${response.data}');
      return FollowListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      print('ERROR: getUserFollowing failed: $e');
      throw ServerException('Failed to get user following: $e');
    }
  }

  /// DEPRECATED: Get followers with profiles (old endpoint)
  /// Use getUserFollowers instead
  static Future<FollowListResponse> getUserFollowersWithProfiles({
    required String userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/followers-with-profiles/$userId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return FollowListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get user followers: $e');
    }
  }

  /// DEPRECATED: Get following with profiles (old endpoint)
  /// Use getUserFollowing instead
  static Future<FollowListResponse> getUserFollowingWithProfiles({
    required String userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/following-with-profiles/$userId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return FollowListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get user following: $e');
    }
  }

  /// Get pending follow requests for current user
  static Future<FollowRequestsListResponse> getMyPendingRequests({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/pending-requests',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return FollowRequestsListResponse.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get pending requests: $e');
    }
  }

  /// Check follow relationship between two users
  static Future<FollowRelationship?> getFollowRelationship({
    required String followingId,
    required String followerId,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/relationship',
        queryParameters: {
          'followingId': followingId,
          'followerId': followerId,
        },
      );

      if (response.data['exists'] == true) {
        return FollowRelationship.fromJson(response.data['data']);
      }
      return null;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get follow relationship: $e');
    }
  }

  // ==================== USER STATS ====================

  /// Get current user's follow statistics
  static Future<UserStats> getMyStats() async {
    try {
      final response = await ApiService.get('/follow/my-stats');
      return UserStats.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get user stats: $e');
    }
  }

  /// Get current user's profile stats in Map format (for profile page)
  static Future<Map<String, dynamic>> getMyProfileStats() async {
    try {
      final stats = await getMyStats(); // Use existing method
      return {
        'success': true,
        'followersCount': stats.followersCount,
        'followingCount': stats.followingCount,
        'postsCount': stats.postsCount,
        'data': {
          'userId': stats.userId,
          'followersCount': stats.followersCount,
          'followingCount': stats.followingCount,
          'postsCount': stats.postsCount,
        }
      };
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get my profile stats: $e');
    }
  }

  /// Get profile stats for a specific user in Map format
  static Future<Map<String, dynamic>> getProfileStats(String userId) async {
    try {
      final stats = await getUserStats(userId); // Use existing method
      return {
        'success': true,
        'followersCount': stats.followersCount,
        'followingCount': stats.followingCount,
        'postsCount': stats.postsCount,
        'data': {
          'userId': stats.userId,
          'followersCount': stats.followersCount,
          'followingCount': stats.followingCount,
          'postsCount': stats.postsCount,
        }
      };
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get profile stats: $e');
    }
  }

  /// Get follow statistics for a specific user
  static Future<UserStats> getUserStats(String userId) async {
    try {
      final response = await ApiService.get('/follow/stats/$userId');
      return UserStats.fromJson(response.data['data']);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get user stats: $e');
    }
  }

  /// Create user stats (usually called during user setup)
  static Future<bool> createUserStats(String userId) async {
    try {
      final response = await ApiService.post('/follow/stats/create/$userId');
      return response.data['success'] ?? false;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create user stats: $e');
    }
  }

  // ==================== CONVENIENCE METHODS ====================

  /// Check if current user is following a specific user
  static Future<bool> isFollowing(String userId) async {
    try {
      final response = await ApiService.get('/follow/is_following/$userId');
      return response.data['isFollowing'] ?? false;
    } on AppException {
      // If API fails, check cache as fallback
      final cachedStatus = await _getCachedFollowStatus(userId);
      return cachedStatus == 'accepted';
    } catch (e) {
      if (kDebugMode) {
        print('Error checking follow status: $e');
      }
      return false;
    }
  }

  /// Check if current user has a pending follow request to a specific user
  static Future<bool> isPending(String userId) async {
    try {
      final response = await ApiService.get('/follow/is_pending/$userId');
      final isPending = response.data['isPending'] ?? false;

      // Cache the status if pending
      if (isPending) {
        await _cacheFollowAction(userId, 'pending');
      }

      return isPending;
    } on AppException {
      // If API fails, check cache as fallback
      final cachedStatus = await _getCachedFollowStatus(userId);
      return cachedStatus == 'pending';
    } catch (e) {
      if (kDebugMode) {
        print('Error checking pending status: $e');
      }
      return false;
    }
  }

  /// Get follow status between current user and another user
  static Future<String?> getFollowStatus(String userId) async {
    try {
      // Check if following
      final isFollowingUser = await isFollowing(userId);
      if (isFollowingUser) {
        await _cacheFollowAction(userId, 'accepted');
        return 'accepted';
      }

      // Check if pending
      final isPendingUser = await isPending(userId);
      if (isPendingUser) {
        await _cacheFollowAction(userId, 'pending');
        return 'pending';
      }

      // Not following and not pending
      await _removeCachedFollowAction(userId);
      return 'none';
    } catch (e) {
      if (kDebugMode) {
        print('Error getting follow status: $e');
      }
      // Try cache as fallback
      final cachedStatus = await _getCachedFollowStatus(userId);
      return cachedStatus ?? 'none';
    }
  }

  /// Toggle follow status (follow/unfollow)
  static Future<Map<String, dynamic>> toggleFollow(String userId) async {
    try {
      // Check cache to determine current status
      final cachedStatus = await _getCachedFollowStatus(userId);
      final isCurrentlyFollowing = cachedStatus == 'accepted';

      if (isCurrentlyFollowing) {
        return await unfollowUser(userId);
      } else {
        return await sendFollowRequest(userId);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to toggle follow: $e');
    }
  }

  // ==================== CACHE MANAGEMENT ====================

  /// Cache follow action locally for immediate UI updates
  static Future<void> _cacheFollowAction(String userId, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'follow_status_$userId';
      await prefs.setString(key, status);
    } catch (e) {
      if (kDebugMode) {
        print('Error caching follow action: $e');
      }
    }
  }

  /// Get cached follow status
  static Future<String?> _getCachedFollowStatus(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'follow_status_$userId';
      return prefs.getString(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cached follow status: $e');
      }
      return null;
    }
  }

  /// Remove cached follow action
  static Future<void> _removeCachedFollowAction(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'follow_status_$userId';
      await prefs.remove(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error removing cached follow action: $e');
      }
    }
  }

  /// Clear all cached follow data
  static Future<void> clearFollowCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (String key in keys) {
        if (key.startsWith('follow_status_')) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing follow cache: $e');
      }
    }
  }

  // ==================== BULK OPERATIONS ====================

  /// Get multiple users' follow status at once (for lists)
  static Future<Map<String, String>> getBulkFollowStatus(List<String> userIds) async {
    final Map<String, String> statusMap = {};

    try {
      // First check cache for all users
      for (String userId in userIds) {
        final cachedStatus = await _getCachedFollowStatus(userId);
        if (cachedStatus != null) {
          statusMap[userId] = cachedStatus;
        }
      }

      // For uncached users, you might want to implement a bulk API endpoint
      // For now, we'll return cached results only
      return statusMap;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting bulk follow status: $e');
      }
      return {};
    }
  }
}

// ==================== MODEL CLASSES ====================

class FollowListResponse {
  final List<UserFollowInfo> users;
  final int totalCount;
  final int page;
  final int size;

  FollowListResponse({
    required this.users,
    required this.totalCount,
    required this.page,
    required this.size,
  });

  factory FollowListResponse.fromJson(Map<String, dynamic> json) {
    // Handle both followers and following responses
    List<UserFollowInfo> usersList = [];

    if (json['followers'] != null) {
      usersList = (json['followers'] as List<dynamic>)
          .map((userJson) => UserFollowInfo.fromJson(userJson))
          .toList();
    } else if (json['following'] != null) {
      usersList = (json['following'] as List<dynamic>)
          .map((userJson) => UserFollowInfo.fromJson(userJson))
          .toList();
    } else if (json['users'] != null) {
      usersList = (json['users'] as List<dynamic>)
          .map((userJson) => UserFollowInfo.fromJson(userJson))
          .toList();
    }

    return FollowListResponse(
      users: usersList,
      totalCount: json['totalCount'] ?? 0,
      page: json['currentPage'] ?? json['page'] ?? 0,
      size: json['totalPages'] ?? json['size'] ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
      'totalCount': totalCount,
      'page': page,
      'size': size,
    };
  }
}

class UserFollowInfo {
  final String userId;
  final String displayName;
  final String? profileImageUrl;
  final String status; // pending, accepted, rejected
  final bool? isMutualFollow;
  final DateTime createdAt;

  UserFollowInfo({
    required this.userId,
    required this.displayName,
    this.profileImageUrl,
    required this.status,
    this.isMutualFollow,
    required this.createdAt,
  });

  factory UserFollowInfo.fromJson(Map<String, dynamic> json) {
    return UserFollowInfo(
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      status: json['status'] ?? 'pending',
      isMutualFollow: json['isMutualFollow'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'isMutualFollow': isMutualFollow,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserStats {
  final String userId;
  final int followersCount;
  final int followingCount;
  final int postsCount;

  UserStats({
    required this.userId,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] ?? '',
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
    };
  }

  @override
  String toString() {
    return 'UserStats(userId: $userId, followers: $followersCount, following: $followingCount, posts: $postsCount)';
  }
}

class FollowRequest {
  final int id;
  final String followerId;
  final String followingId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowRequest({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowRequest.fromJson(Map<String, dynamic> json) {
    return FollowRequest(
      id: json['id'] ?? 0,
      followerId: json['followerId'] ?? '',
      followingId: json['followingId'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'followerId': followerId,
      'followingId': followingId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FollowRelationship {
  final int id;
  final String followerId;
  final String followingId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowRelationship({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowRelationship.fromJson(Map<String, dynamic> json) {
    return FollowRelationship(
      id: json['id'] ?? 0,
      followerId: json['followerId'] ?? '',
      followingId: json['followingId'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'followerId': followerId,
      'followingId': followingId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isAccepted => status == 'accepted';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
}

class FollowRequestsListResponse {
  final List<FollowRequestInfo> requests;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  FollowRequestsListResponse({
    required this.requests,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory FollowRequestsListResponse.fromJson(Map<String, dynamic> json) {
    return FollowRequestsListResponse(
      requests: (json['requests'] as List<dynamic>?)
          ?.map((requestJson) => FollowRequestInfo.fromJson(requestJson))
          .toList() ?? [],
      totalCount: json['totalCount'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requests': requests.map((request) => request.toJson()).toList(),
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

class FollowRequestInfo {
  final String userId;
  final String displayName;
  final String? profileImageUrl;
  final int followId;
  final DateTime createdAt;

  FollowRequestInfo({
    required this.userId,
    required this.displayName,
    this.profileImageUrl,
    required this.followId,
    required this.createdAt,
  });

  factory FollowRequestInfo.fromJson(Map<String, dynamic> json) {
    return FollowRequestInfo(
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      followId: json['followId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'followId': followId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}