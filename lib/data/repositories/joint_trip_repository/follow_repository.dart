import 'dart:convert';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class FollowRepository {
  // Get user's following list (people the current user follows)
  static Future<List<Map<String, dynamic>>> getMyFollowing({
    int page = 0,
    int size = 100,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/my-following',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print('Backend response for getMyFollowing: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        final followingList = data['following'] as List? ?? [];

        return followingList.map<Map<String, dynamic>>((user) {
          return {
            'userId': user['userId']?.toString() ?? '',
            'displayName': user['displayName'] ?? 'Unknown User',
            'profileImageUrl': user['profileImageUrl'] ?? '',
          };
        }).toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch following';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching following: $e');
      rethrow;
    } catch (e) {
      print('Error fetching following: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get user's followers list
  static Future<List<Map<String, dynamic>>> getMyFollowers({
    int page = 0,
    int size = 100,
  }) async {
    try {
      final response = await ApiService.get(
        '/follow/my-followers',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print('Backend response for getMyFollowers: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        final followersList = data['followers'] as List? ?? [];

        return followersList.map<Map<String, dynamic>>((user) {
          return {
            'userId': user['userId']?.toString() ?? '',
            'displayName': user['displayName'] ?? 'Unknown User',
            'profileImageUrl': user['profileImageUrl'] ?? '',
          };
        }).toList();
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch followers';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching followers: $e');
      rethrow;
    } catch (e) {
      print('Error fetching followers: $e');
      throw Exception('Network error: $e');
    }
  }

  // Send follow request
  static Future<Map<String, dynamic>> sendFollowRequest(String followerId) async {
    try {
      final response = await ApiService.post(
        '/follow/send-request',
        data: {
          'followerId': followerId,
        },
      );

      print('Backend response for sendFollowRequest: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Follow request sent',
          'followId': response.data['followId'],
        };
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to send follow request';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error sending follow request: $e');
      rethrow;
    } catch (e) {
      print('Error sending follow request: $e');
      throw Exception('Network error: $e');
    }
  }

  // Accept follow request
  static Future<bool> acceptFollowRequest(int followId) async {
    try {
      final response = await ApiService.post(
        '/follow/accept-request/$followId',
        data: {},
      );

      if (response.data != null && response.data['success'] == true) {
        return true;
      }
      return false;
    } on AppException catch (e) {
      print('API Error accepting follow request: $e');
      rethrow;
    } catch (e) {
      print('Error accepting follow request: $e');
      throw Exception('Network error: $e');
    }
  }

  // Reject follow request
  static Future<bool> rejectFollowRequest(int followId) async {
    try {
      final response = await ApiService.post(
        '/follow/reject-request/$followId',
        data: {},
      );

      if (response.data != null && response.data['success'] == true) {
        return true;
      }
      return false;
    } on AppException catch (e) {
      print('API Error rejecting follow request: $e');
      rethrow;
    } catch (e) {
      print('Error rejecting follow request: $e');
      throw Exception('Network error: $e');
    }
  }

  // Unfollow user
  static Future<bool> unfollowUser(String followerId) async {
    try {
      final response = await ApiService.delete(
        '/follow/unfollow',
        queryParameters: {
          'followerId': followerId,
        },
      );

      if (response.data != null && response.data['success'] == true) {
        return true;
      }
      return false;
    } on AppException catch (e) {
      print('API Error unfollowing user: $e');
      rethrow;
    } catch (e) {
      print('Error unfollowing user: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get user stats
  static Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final response = await ApiService.get('/follow/stats/$userId');

      if (response.data != null && response.data['success'] == true) {
        final stats = response.data['data'];
        return {
          'userId': stats['userId'],
          'followersCount': stats['followersCount'] ?? 0,
          'followingCount': stats['followingCount'] ?? 0,
          'postsCount': stats['postsCount'] ?? 0,
        };
      } else {
        throw Exception('Failed to fetch user stats');
      }
    } on AppException catch (e) {
      print('API Error fetching user stats: $e');
      rethrow;
    } catch (e) {
      print('Error fetching user stats: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get pending follow requests
  static Future<List<Map<String, dynamic>>> getPendingFollowRequests({
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

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        final requests = data['requests'] as List? ?? [];

        return requests.map<Map<String, dynamic>>((request) {
          return {
            'followId': request['followId'],
            'userId': request['userId']?.toString() ?? '',
            'displayName': request['displayName'] ?? 'Unknown User',
            'profileImageUrl': request['profileImageUrl'] ?? '',
            'requestedAt': request['requestedAt'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch pending requests');
      }
    } on AppException catch (e) {
      print('API Error fetching pending requests: $e');
      rethrow;
    } catch (e) {
      print('Error fetching pending requests: $e');
      throw Exception('Network error: $e');
    }
  }
}