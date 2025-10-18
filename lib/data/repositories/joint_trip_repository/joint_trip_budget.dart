import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

/// Repository for managing trip budget expenses
/// Handles all budget-related API calls to the backend
class JointTripBudgetRepository {
  // ==================== CREATE BUDGET ====================
  /// Create a new budget for a group/trip
  /// POST /budgets/create
  static Future<Map<String, dynamic>> createBudget({
    required int groupId,
    required String groupName,
    required List<Map<String, dynamic>> members,
  }) async {
    try {
      final requestData = {
        'groupId': groupId,
        'groupName': groupName,
        'members': members.map((member) {
          return {
            'userId': member['userId'],
            'memberName': member['memberName'],
            'memberAvatar': member['memberAvatar'],
            'travelExpense': member['travelExpense'] ?? 0.0,
            'foodExpense': member['foodExpense'] ?? 0.0,
            'hotelExpense': member['hotelExpense'] ?? 0.0,
            'otherExpense': member['otherExpense'] ?? 0.0,
          };
        }).toList(),
      };

      print('Creating budget: $requestData');

      final response = await ApiService.post(
        '/budgets/create',
        data: requestData,
      );

      print('Create budget response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to create budget';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error creating budget: $e');
      rethrow;
    } catch (e) {
      print('Error creating budget: $e');
      throw Exception('Failed to create budget: ${e.toString()}');
    }
  }

  // ==================== GET BUDGET BY GROUP ID ====================
  /// Get budget details for a specific group
  /// GET /budgets/group/{groupId}
  static Future<Map<String, dynamic>> getBudgetByGroupId(int groupId) async {
    try {
      print('Fetching budget for group: $groupId');

      final response = await ApiService.get('/budgets/group/$groupId');

      print('Get budget response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch budget';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching budget: $e');
      rethrow;
    } catch (e) {
      print('Error fetching budget: $e');
      throw Exception('Failed to fetch budget: ${e.toString()}');
    }
  }

  // ==================== GET BUDGET BY BUDGET ID ====================
  /// Get budget details by budget group ID
  /// GET /budgets/{budgetGroupId}
  static Future<Map<String, dynamic>> getBudgetById(int budgetGroupId) async {
    try {
      print('Fetching budget with ID: $budgetGroupId');

      final response = await ApiService.get('/budgets/$budgetGroupId');

      print('Get budget by ID response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch budget';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error fetching budget by ID: $e');
      rethrow;
    } catch (e) {
      print('Error fetching budget by ID: $e');
      throw Exception('Failed to fetch budget: ${e.toString()}');
    }
  }

  // ==================== UPDATE MEMBER EXPENSE ====================
  /// Update a specific expense category for a member
  /// PUT /budgets/{budgetGroupId}/expense
  static Future<Map<String, dynamic>> updateMemberExpense({
    required int budgetGroupId,
    required int userId,
    required String category,
    required double amount,
  }) async {
    try {
      // Validate category
      if (!['travel', 'food', 'hotel', 'other'].contains(category.toLowerCase())) {
        throw Exception('Invalid category. Must be one of: travel, food, hotel, other');
      }

      // Validate amount
      if (amount < 0) {
        throw Exception('Amount must be greater than or equal to 0');
      }

      final requestData = {
        'userId': userId,
        'category': category.toLowerCase(),
        'amount': amount,
      };

      print('Updating expense: $requestData');

      final response = await ApiService.put(
        '/budgets/$budgetGroupId/expense',
        data: requestData,
      );

      print('Update expense response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to update expense';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error updating expense: $e');
      rethrow;
    } catch (e) {
      print('Error updating expense: $e');
      throw Exception('Failed to update expense: ${e.toString()}');
    }
  }

  // ==================== ADD MEMBER TO BUDGET ====================
  /// Add a new member to an existing budget
  /// POST /budgets/{budgetGroupId}/member
  static Future<Map<String, dynamic>> addMemberToBudget({
    required int budgetGroupId,
    required int userId,
    required String memberName,
    String? memberAvatar,
    double travelExpense = 0.0,
    double foodExpense = 0.0,
    double hotelExpense = 0.0,
    double otherExpense = 0.0,
  }) async {
    try {
      final requestData = {
        'userId': userId,
        'memberName': memberName,
        'memberAvatar': memberAvatar,
        'travelExpense': travelExpense,
        'foodExpense': foodExpense,
        'hotelExpense': hotelExpense,
        'otherExpense': otherExpense,
      };

      print('Adding member to budget: $requestData');

      final response = await ApiService.post(
        '/budgets/$budgetGroupId/member',
        data: requestData,
      );

      print('Add member response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to add member';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('API Error adding member: $e');
      rethrow;
    } catch (e) {
      print('Error adding member: $e');
      throw Exception('Failed to add member: ${e.toString()}');
    }
  }

  // ==================== DELETE BUDGET ====================
  /// Delete a budget group
  /// DELETE /budgets/{budgetGroupId}
  static Future<void> deleteBudget(int budgetGroupId) async {
    try {
      print('Deleting budget with ID: $budgetGroupId');

      final response = await ApiService.delete('/budgets/$budgetGroupId');

      print('Delete budget response: ${response.data}');

      if (response.data != null && response.data['success'] == false) {
        final errorMessage = response.data['message'] ?? 'Failed to delete budget';
        throw Exception(errorMessage);
      }

      print('✅ Budget deleted successfully');
    } on AppException catch (e) {
      print('API Error deleting budget: $e');
      rethrow;
    } catch (e) {
      print('Error deleting budget: $e');
      throw Exception('Failed to delete budget: ${e.toString()}');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Convert backend member data to frontend format
  static Map<String, double> getMemberExpensesMap(Map<String, dynamic> memberData) {
    return {
      'travel': (memberData['travelExpense'] as num?)?.toDouble() ?? 0.0,
      'food': (memberData['foodExpense'] as num?)?.toDouble() ?? 0.0,
      'hotel': (memberData['hotelExpense'] as num?)?.toDouble() ?? 0.0,
      'other': (memberData['otherExpense'] as num?)?.toDouble() ?? 0.0,
    };
  }

  /// Extract member info for UI display
  static Map<String, dynamic> extractMemberInfo(Map<String, dynamic> memberData) {
    return {
      'id': memberData['userId'].toString(),
      'name': memberData['memberName'] ?? 'Unknown',
      'avatar': memberData['memberAvatar'] ?? '',
      'expenses': getMemberExpensesMap(memberData),
      'total': (memberData['totalExpense'] as num?)?.toDouble() ?? 0.0,
    };
  }

  /// Check if budget exists for a group
  static Future<bool> budgetExistsForGroup(int groupId) async {
    try {
      await getBudgetByGroupId(groupId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
