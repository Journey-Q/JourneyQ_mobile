import 'package:flutter/material.dart';
import 'package:journeyq/data/repositories/saved_plan_repository/saved_plan_repository.dart';

/// Debug utility to delete Sri Lanka test plans
///
/// Usage: Call this function from any page with a userId
/// Example: await deleteSriLankaPlans(context, userId: 'your-user-id');
Future<void> deleteSriLankaPlans(BuildContext context, {required String userId}) async {
  try {
    print('🔍 Searching for Sri Lanka plans for user: $userId');

    final count = await SavedPlanRepository.deletePlansByTitle(
      userId: userId,
      titlePattern: 'sri lanka',
    );

    print('✅ Deleted $count plan(s) containing "Sri Lanka"');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted $count Sri Lanka plan(s)'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    print('❌ Error deleting Sri Lanka plans: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Delete ALL saved plans for a user (use with extreme caution!)
Future<void> deleteAllPlans(BuildContext context, {required String userId}) async {
  try {
    print('⚠️ Deleting ALL plans for user: $userId');

    await SavedPlanRepository.deleteAllUserPlans(userId: userId);

    print('✅ All plans deleted');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All plans deleted'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    print('❌ Error deleting all plans: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
