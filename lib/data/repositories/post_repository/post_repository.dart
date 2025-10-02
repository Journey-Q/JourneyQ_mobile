import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class PostRepository {
  // Get user posts by user ID
  static Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    try {
      final response = await ApiService.get('/posts/user/$userId');
      
      print('Posts API Response: ${response.data}');
      
      // Handle direct array response
      if (response.data is List) {
        final posts = (response.data as List).map((item) => 
          item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{}
        ).toList();
        print('Found ${posts.length} posts for user $userId');
        return posts;
      }
      
      // Handle wrapped response with results/data/posts key
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['posts'] != null && data['posts'] is List) {
          return (data['posts'] as List).map((item) => 
            item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{}
          ).toList();
        }
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List).map((item) => 
            item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{}
          ).toList();
        }
        if (data['results'] != null && data['results'] is List) {
          return (data['results'] as List).map((item) => 
            item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{}
          ).toList();
        }
      }
      
      print('No posts found in response for user $userId');
      return [];
    } on AppException catch (e) {
      print('Error in getUserPosts: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserPosts: $e');
      rethrow;
    }
  }

  // Get post details by post ID
  static Future<Map<String, dynamic>> getPostDetails(String postId) async {
    try {
      final response = await ApiService.get('/posts/$postId');
      
      print('Post Details API Response: ${response.data}');
      
      // Handle wrapped response
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        if (data['data'] != null && data['data'] is Map) {
          return Map<String, dynamic>.from(data['data'] as Map);
        }
        return data;
      }
      
      throw ServerException('Invalid post details response format');
    } on AppException catch (e) {
      print('Error in getPostDetails: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getPostDetails: $e');
      rethrow;
    }
  }

  // Like/Unlike a post
  static Future<Map<String, dynamic>> toggleLike(String postId) async {
    try {
      final response = await ApiService.post('/posts/$postId/likes/toggle');
      
      print('Toggle Like API Response: ${response.data}');
      return response.data is Map 
        ? Map<String, dynamic>.from(response.data as Map) 
        : <String, dynamic>{};
    } on AppException catch (e) {
      print('Error in toggleLike: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in toggleLike: $e');
      rethrow;
    }
  }

  // Get like status and count
  static Future<Map<String, dynamic>> getLikeStatus(String postId) async {
    try {
      final response = await ApiService.get('/posts/$postId/likes/status');
      
      print('Like Status API Response: ${response.data}');
      return response.data is Map 
        ? Map<String, dynamic>.from(response.data as Map) 
        : <String, dynamic>{};
    } on AppException catch (e) {
      print('Error in getLikeStatus: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getLikeStatus: $e');
      rethrow;
    }
  }

  // Get comments for a post
  static Future<List<Map<String, dynamic>>> getComments(String postId) async {
    try {
      final response = await ApiService.get('/posts/$postId/comments');
      
      print('Comments API Response: ${response.data}');
      
      // Handle wrapped response
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List).map((item) => 
            item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{}
          ).toList();
        }
      }
      
      return [];
    } on AppException catch (e) {
      print('Error in getComments: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getComments: $e');
      rethrow;
    }
  }

  // Add a comment to a post
  static Future<Map<String, dynamic>> addComment(String postId, String commentText) async {
    try {
      final response = await ApiService.post(
        '/posts/$postId/comments/add',
        data: {'commentText': commentText},
      );
      
      print('Add Comment API Response: ${response.data}');
      return response.data is Map 
        ? Map<String, dynamic>.from(response.data as Map) 
        : <String, dynamic>{};
    } on AppException catch (e) {
      print('Error in addComment: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in addComment: $e');
      rethrow;
    }
  }

  // Reply to a comment
  static Future<Map<String, dynamic>> replyToComment(
    String postId, 
    String commentId, 
    String commentText
  ) async {
    try {
      final response = await ApiService.post(
        '/posts/$postId/comments/$commentId/reply',
        data: {'commentText': commentText},
      );
      
      print('Reply Comment API Response: ${response.data}');
      return response.data is Map 
        ? Map<String, dynamic>.from(response.data as Map) 
        : <String, dynamic>{};
    } on AppException catch (e) {
      print('Error in replyToComment: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in replyToComment: $e');
      rethrow;
    }
  }

  // Delete a comment
  static Future<Map<String, dynamic>> deleteComment(String postId, String commentId) async {
    try {
      final response = await ApiService.delete('/posts/$postId/comments/$commentId');
      
      print('Delete Comment API Response: ${response.data}');
      return response.data is Map 
        ? Map<String, dynamic>.from(response.data as Map) 
        : <String, dynamic>{};
    } on AppException catch (e) {
      print('Error in deleteComment: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in deleteComment: $e');
      rethrow;
    }
  }

  // Get comment count for a post
  static Future<int> getCommentsCount(String postId) async {
    try {
      final response = await ApiService.get('/posts/$postId/comments/count');
      
      print('Comments Count API Response: ${response.data}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        return (data['commentsCount'] ?? 0) as int;
      }
      
      return 0;
    } on AppException catch (e) {
      print('Error in getCommentsCount: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getCommentsCount: $e');
      rethrow;
    }
  }

  // Create a new post
  static Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    try {
      final response = await ApiService.post('/posts/create', data: postData);
      
      print('Create Post API Response: ${response.data}');
      
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      
      throw ServerException('Invalid create post response format');
    } on AppException catch (e) {
      print('Error in createPost: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in createPost: $e');
      rethrow;
    }
  }
}