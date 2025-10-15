import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/features/notification/models/notification_model.dart';
import 'package:journeyq/data/repositories/follow_repository/follow_repository.dart';

class NotificationRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Listen to notifications for a specific user
  Stream<List<NotificationModel>> listenToNotifications(String userId) {
    return _database
        .ref('notifications/$userId')
        .onValue
        .map((event) {
      final notifications = <NotificationModel>[];

      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          try {
            final notificationData = Map<String, dynamic>.from(value as Map);
            notificationData['id'] = key; // Add Firebase key as ID
            notifications.add(NotificationModel.fromJson(notificationData));
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing notification: $e');
            }
          }
        });

        // Sort by timestamp (newest first)
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      return notifications;
    }).handleError((error) {
      if (kDebugMode) {
        print('Error listening to notifications: $error');
      }
      return <NotificationModel>[];
    });
  }

  /// Get unread notification count
  Stream<int> listenToUnreadCount(String userId) {
    return _database
        .ref('notification_counts/$userId/unread_count')
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        return event.snapshot.value as int;
      }
      return 0;
    }).handleError((error) {
      if (kDebugMode) {
        print('Error listening to unread count: $error');
      }
      return 0;
    });
  }

  /// Mark all notifications as read (via backend API)
  Future<bool> markAllAsRead(String userId) async {
    try {
      final response = await ApiService.put('/notifications/$userId/read-all');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('All notifications marked as read');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error marking all as read: $e');
      }
      return false;
    }
  }

  /// Delete a notification (via backend API)
  Future<bool> deleteNotification(String userId, String notificationId) async {
    try {
      final response = await ApiService.delete('/notifications/$userId/$notificationId');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Notification deleted');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting notification: $e');
      }
      return false;
    }
  }

  /// Mark a single notification as read locally
  Future<bool> markAsRead(String userId, String notificationId) async {
    try {
      await _database
          .ref('notifications/$userId/$notificationId/is_read')
          .set(true);

      // Decrement unread count
      final countRef = _database.ref('notification_counts/$userId/unread_count');
      await countRef.runTransaction((currentValue) {
        if (currentValue == null) return Transaction.success(0);

        final current = currentValue as int;
        return Transaction.success(current > 0 ? current - 1 : 0);
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
      return false;
    }
  }

  /// Get all notifications (one-time fetch)
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final snapshot = await _database.ref('notifications/$userId').get();

      final notifications = <NotificationModel>[];

      if (snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          try {
            final notificationData = Map<String, dynamic>.from(value as Map);
            notificationData['id'] = key;
            notifications.add(NotificationModel.fromJson(notificationData));
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing notification: $e');
            }
          }
        });

        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      return notifications;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting notifications: $e');
      }
      return [];
    }
  }

  /// Get unread count (one-time fetch)
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _database
          .ref('notification_counts/$userId/unread_count')
          .get();

      if (snapshot.value != null) {
        return snapshot.value as int;
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting unread count: $e');
      }
      return 0;
    }
  }

  /// Accept a follow request from notification
  Future<bool> acceptFollowRequest(int followId) async {
    try {
      await FollowRepository.acceptFollowRequestById(followId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error accepting follow request: $e');
      }
      return false;
    }
  }

  /// Reject a follow request from notification
  Future<bool> rejectFollowRequest(int followId) async {
    try {
      await FollowRepository.rejectFollowRequestById(followId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error rejecting follow request: $e');
      }
      return false;
    }
  }

  /// Update notification status after follow request action
  Future<void> updateFollowNotificationStatus(
    String userId,
    String notificationId,
    String status,
  ) async {
    try {
      await _database
          .ref('notifications/$userId/$notificationId/follow_request_status')
          .set(status);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating follow notification status: $e');
      }
    }
  }
}
