import 'package:firebase_database/firebase_database.dart';
import 'package:journeyq/core/config/firebase_config.dart';

/// Repository for managing saved travel plans in Firebase Realtime Database
/// Stores plans under the structure: saved_plans/{userId}/{planId}
class SavedPlanRepository {
  /// Get database reference using FirebaseConfig
  static DatabaseReference get _database {
    try {
      return FirebaseConfig.instance.getDatabaseReference();
    } catch (e) {
      // Fallback to default instance if config not initialized
      print('⚠️ FirebaseConfig not initialized, using default instance');
      return FirebaseDatabase.instance.ref();
    }
  }

  /// Save a new travel plan for a user
  /// Returns the generated plan ID
  static Future<String> savePlan({
    required String userId,
    required Map<String, dynamic> planData,
  }) async {
    try {
      // Generate a new plan ID using Firebase push key
      final planRef = _database.child('saved_plans').child(userId).push();
      final planId = planRef.key!;

      // Add metadata
      final dataToSave = {
        ...planData,
        'planId': planId,
        'userId': userId,
        'savedAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      };

      // Save to Firebase
      await planRef.set(dataToSave);

      print('✅ Plan saved successfully with ID: $planId');
      return planId;
    } catch (e) {
      print('❌ Error saving plan: $e');
      throw Exception('Failed to save plan: $e');
    }
  }

  /// Get all saved plans for a specific user
  static Future<List<Map<String, dynamic>>> getUserPlans({
    required String userId,
  }) async {
    try {
      final snapshot = await _database
          .child('saved_plans')
          .child(userId)
          .orderByChild('savedAt')
          .get();

      if (!snapshot.exists) {
        print('ℹ️ No saved plans found for user: $userId');
        return [];
      }

      final List<Map<String, dynamic>> plans = [];
      final data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        if (value is Map) {
          final plan = Map<String, dynamic>.from(value);
          plan['planId'] = key; // Ensure planId is set
          plans.add(plan);
        }
      });

      // Sort by savedAt (most recent first)
      plans.sort((a, b) {
        final aTime = a['savedAt'] as int? ?? 0;
        final bTime = b['savedAt'] as int? ?? 0;
        return bTime.compareTo(aTime);
      });

      print('✅ Retrieved ${plans.length} plans for user: $userId');
      return plans;
    } catch (e) {
      print('❌ Error retrieving plans: $e');
      throw Exception('Failed to retrieve plans: $e');
    }
  }

  /// Get a specific saved plan by ID
  static Future<Map<String, dynamic>?> getPlanById({
    required String userId,
    required String planId,
  }) async {
    try {
      final snapshot = await _database
          .child('saved_plans')
          .child(userId)
          .child(planId)
          .get();

      if (!snapshot.exists) {
        print('ℹ️ Plan not found: $planId');
        return null;
      }

      final plan = Map<String, dynamic>.from(snapshot.value as Map);
      plan['planId'] = planId;

      print('✅ Retrieved plan: $planId');
      return plan;
    } catch (e) {
      print('❌ Error retrieving plan: $e');
      throw Exception('Failed to retrieve plan: $e');
    }
  }

  /// Update an existing saved plan
  static Future<void> updatePlan({
    required String userId,
    required String planId,
    required Map<String, dynamic> planData,
  }) async {
    try {
      final updates = {
        ...planData,
        'updatedAt': ServerValue.timestamp,
      };

      await _database
          .child('saved_plans')
          .child(userId)
          .child(planId)
          .update(updates);

      print('✅ Plan updated successfully: $planId');
    } catch (e) {
      print('❌ Error updating plan: $e');
      throw Exception('Failed to update plan: $e');
    }
  }

  /// Delete a saved plan
  static Future<void> deletePlan({
    required String userId,
    required String planId,
  }) async {
    try {
      await _database
          .child('saved_plans')
          .child(userId)
          .child(planId)
          .remove();

      print('✅ Plan deleted successfully: $planId');
    } catch (e) {
      print('❌ Error deleting plan: $e');
      throw Exception('Failed to delete plan: $e');
    }
  }

  /// Stream of user's saved plans (real-time updates)
  static Stream<List<Map<String, dynamic>>> watchUserPlans({
    required String userId,
  }) {
    return _database
        .child('saved_plans')
        .child(userId)
        .orderByChild('savedAt')
        .onValue
        .map((event) {
      if (!event.snapshot.exists) {
        return <Map<String, dynamic>>[];
      }

      final List<Map<String, dynamic>> plans = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        if (value is Map) {
          final plan = Map<String, dynamic>.from(value);
          plan['planId'] = key;
          plans.add(plan);
        }
      });

      // Sort by savedAt (most recent first)
      plans.sort((a, b) {
        final aTime = a['savedAt'] as int? ?? 0;
        final bTime = b['savedAt'] as int? ?? 0;
        return bTime.compareTo(aTime);
      });

      return plans;
    });
  }

  /// Check if a plan exists
  static Future<bool> planExists({
    required String userId,
    required String planId,
  }) async {
    try {
      final snapshot = await _database
          .child('saved_plans')
          .child(userId)
          .child(planId)
          .get();

      return snapshot.exists;
    } catch (e) {
      print('❌ Error checking plan existence: $e');
      return false;
    }
  }

  /// Get count of saved plans for a user
  static Future<int> getUserPlanCount({
    required String userId,
  }) async {
    try {
      final snapshot = await _database
          .child('saved_plans')
          .child(userId)
          .get();

      if (!snapshot.exists) {
        return 0;
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.length;
    } catch (e) {
      print('❌ Error getting plan count: $e');
      return 0;
    }
  }
}

/// Model class for Saved Plan
class SavedPlan {
  final String planId;
  final String userId;
  final String journeyTitle;
  final int numberOfDays;
  final List<String> placesVisited;
  final double totalBudget;
  final String currency;
  final int savedAt;
  final int updatedAt;
  final Map<String, dynamic> fullData;

  SavedPlan({
    required this.planId,
    required this.userId,
    required this.journeyTitle,
    required this.numberOfDays,
    required this.placesVisited,
    required this.totalBudget,
    required this.currency,
    required this.savedAt,
    required this.updatedAt,
    required this.fullData,
  });

  factory SavedPlan.fromJson(Map<String, dynamic> json) {
    return SavedPlan(
      planId: json['planId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      journeyTitle: json['journeyTitle'] as String? ?? 'Untitled Plan',
      numberOfDays: json['numberOfDays'] as int? ?? 0,
      placesVisited: (json['placesVisited'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      totalBudget: (json['budgetInfo']?['totalBudget'] as num?)?.toDouble() ?? 0.0,
      currency: json['budgetInfo']?['currency'] as String? ?? 'USD',
      savedAt: json['savedAt'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
      fullData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return fullData;
  }

  String getFormattedDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(savedAt);
    return '${date.day}/${date.month}/${date.year}';
  }

  String getTimeAgo() {
    final date = DateTime.fromMillisecondsSinceEpoch(savedAt);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
