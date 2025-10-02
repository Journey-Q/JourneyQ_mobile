import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class BucketListRepository {
  // Get current user's bucket list
  static Future<Map<String, dynamic>> getBucketList() async {
    try {
      final response = await ApiService.get('/bucket-list');
      
      print('Get Bucket List API Response: ${response.data}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        return data['data'] is Map 
            ? Map<String, dynamic>.from(data['data'] as Map)
            : <String, dynamic>{};
      }
      
      throw ServerException('Invalid bucket list response format');
    } on AppException catch (e) {
      print('Error in getBucketList: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getBucketList: $e');
      rethrow;
    }
  }

  // Get bucket list for specific user
  static Future<Map<String, dynamic>> getBucketListByUserId(String userId) async {
    try {
      final response = await ApiService.get('/bucket-list/user/$userId');
      
      print('Get Bucket List By User ID API Response: ${response.data}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        return data['data'] is Map 
            ? Map<String, dynamic>.from(data['data'] as Map)
            : <String, dynamic>{};
      }
      
      throw ServerException('Invalid bucket list response format');
    } on AppException catch (e) {
      print('Error in getBucketListByUserId: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in getBucketListByUserId: $e');
      rethrow;
    }
  }

  // Add post to bucket list
  static Future<Map<String, dynamic>> addToBucketList(String postId) async {
    try {
      final response = await ApiService.post('/bucket-list/add', data: {
        'postId': postId,
      });
      
      print('Add to Bucket List API Response: ${response.data}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        return data['data'] is Map 
            ? Map<String, dynamic>.from(data['data'] as Map)
            : <String, dynamic>{};
      }
      
      throw ServerException('Invalid add to bucket list response format');
    } on AppException catch (e) {
      print('Error in addToBucketList: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in addToBucketList: $e');
      rethrow;
    }
  }

  // Remove post from bucket list
  static Future<Map<String, dynamic>> removeFromBucketList(String postId) async {
    try {
      final response = await ApiService.delete('/bucket-list/remove/$postId');
      
      print('Remove from Bucket List API Response: ${response.data}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        return data['data'] is Map 
            ? Map<String, dynamic>.from(data['data'] as Map)
            : <String, dynamic>{};
      }
      
      throw ServerException('Invalid remove from bucket list response format');
    } on AppException catch (e) {
      print('Error in removeFromBucketList: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in removeFromBucketList: $e');
      rethrow;
    }
  }

  // Update visited status of post in bucket list
  static Future<Map<String, dynamic>> updateVisitedStatus(String postId, bool isVisited) async {
    try {
      final response = await ApiService.put('/bucket-list/update-visited', data: {
        'postId': postId,
        'visited': isVisited,
      });
      
      print('Update Visited Status API Response: ${response.data}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        return data['data'] is Map 
            ? Map<String, dynamic>.from(data['data'] as Map)
            : <String, dynamic>{};
      }
      
      throw ServerException('Invalid update visited status response format');
    } on AppException catch (e) {
      print('Error in updateVisitedStatus: $e');
      rethrow;
    } catch (e) {
      print('Unexpected error in updateVisitedStatus: $e');
      rethrow;
    }
  }
}