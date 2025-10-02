import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

class SearchRepository {
  // Search for users and journeys
  static Future<List<Map<String, dynamic>>> searchContent({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/search',
        queryParameters: {
          'query': query,
          'limit': limit.toString(),
        },
      );
      
      // Handle direct array response
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      
      // Handle wrapped response with results/data key
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['results'] != null && data['results'] is List) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      
      return [];
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}