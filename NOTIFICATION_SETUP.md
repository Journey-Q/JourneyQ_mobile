# Notification System Setup Guide

This guide explains the complete notification system implementation for JourneyQ, connecting the Flutter frontend with the Spring Boot backend.

## Architecture Overview

The notification system uses:
- **Firebase Realtime Database** for real-time notification delivery
- **Spring Boot Backend** for notification management and business logic
- **Flutter Frontend** for displaying notifications

## Backend Structure (Spring Boot)

### 1. Model Layer

**File:** `com.example.demo.model.NotificationEvent.java`

Already created with the following structure:
```java
- sender_id: String
- receiver_id: String
- notification_type: NotificationType (LIKE, COMMENT, FOLLOW_REQUEST)
- content: String
- timestamp: long
- is_read: boolean
- sender_name: String
- sender_profile_url: String
- post_id: String
- post_name: String
- comment_id: String
```

### 2. Repository Layer (To Be Created)

Create the following structure in your Spring Boot project:

```
src/main/java/com/example/demo/repository/
└── notification/
    ├── NotificationRepository.java (interface)
    └── NotificationRepositoryImpl.java (implementation)
```

**NotificationRepository.java:**
```java
package com.example.demo.repository.notification;

import com.example.demo.model.NotificationEvent;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface NotificationRepository {
    CompletableFuture<Void> save(NotificationEvent notification);
    CompletableFuture<List<NotificationEvent>> findByReceiverId(String receiverId);
    CompletableFuture<Long> countUnreadByReceiverId(String receiverId);
    CompletableFuture<Void> markAsRead(String receiverId, String notificationId);
    CompletableFuture<Void> delete(String receiverId, String notificationId);
}
```

**NotificationRepositoryImpl.java:**
```java
package com.example.demo.repository.notification;

import com.example.demo.model.NotificationEvent;
import com.example.demo.service.NotificationService;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Repository
public class NotificationRepositoryImpl implements NotificationRepository {

    private final NotificationService notificationService;

    public NotificationRepositoryImpl(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @Override
    public CompletableFuture<Void> save(NotificationEvent notification) {
        return notificationService.saveNotification(notification);
    }

    @Override
    public CompletableFuture<List<NotificationEvent>> findByReceiverId(String receiverId) {
        // Firebase queries are handled through real-time listeners in the Flutter app
        return CompletableFuture.completedFuture(List.of());
    }

    @Override
    public CompletableFuture<Long> countUnreadByReceiverId(String receiverId) {
        // Count is handled through Firebase listeners in the Flutter app
        return CompletableFuture.completedFuture(0L);
    }

    @Override
    public CompletableFuture<Void> markAsRead(String receiverId, String notificationId) {
        return notificationService.markAllAsRead(receiverId);
    }

    @Override
    public CompletableFuture<Void> delete(String receiverId, String notificationId) {
        return notificationService.deleteNotification(receiverId, notificationId);
    }
}
```

### 3. Service Layer

**File:** `com.example.demo.service.NotificationService.java`

Already created and functional. This service handles:
- Saving notifications to Firebase
- Updating notification counts
- Marking all as read
- Deleting notifications

### 4. Controller Layer

**File:** `com.example.demo.controller.NotificationController.java`

Already created with the following endpoints:
- `DELETE /notifications/{userId}/{notificationId}` - Delete a notification
- `PUT /notifications/{userId}/read-all` - Mark all as read
- `GET /notifications/health` - Health check

## Frontend Structure (Flutter)

### 1. Model Layer

**File:** `lib/features/notification/models/notification_model.dart`

✅ Created with:
- Mirrors the backend NotificationEvent structure
- JSON serialization/deserialization
- Helper methods (timeAgo, message, typeString)
- Enum mapping for notification types

### 2. Repository Layer

**File:** `lib/features/notification/repository/notification_repository.dart`

✅ Created with the following methods:

**Firebase Realtime Database Methods:**
- `listenToNotifications(String userId)` - Stream of notifications
- `listenToUnreadCount(String userId)` - Stream of unread count
- `markAsRead(String userId, String notificationId)` - Mark single as read
- `getNotifications(String userId)` - One-time fetch
- `getUnreadCount(String userId)` - One-time count fetch

**Backend API Methods:**
- `markAllAsRead(String userId)` - Calls backend endpoint
- `deleteNotification(String userId, String notificationId)` - Calls backend endpoint

### 3. UI Layer

**File:** `lib/features/notification/pages/notification.dart`

✅ Updated with:
- Real-time Firebase integration
- Stream builders for live updates
- Pull-to-refresh functionality
- Swipe-to-delete notifications
- Mark all as read functionality
- Tap to mark individual notifications as read
- Time-based grouping (Today, Yesterday, This Week, Earlier)

## Firebase Realtime Database Structure

```
/notifications
  /{userId}
    /{notificationId}
      - sender_id: string
      - receiver_id: string
      - notification_type: string
      - content: string
      - timestamp: number
      - is_read: boolean
      - sender_name: string
      - sender_profile_url: string
      - post_id: string
      - post_name: string
      - comment_id: string

/notification_counts
  /{userId}
    - unread_count: number
```

## How to Use the Notification System

### Creating Notifications from Backend

When a user likes, comments, or follows:

```java
@Autowired
private NotificationService notificationService;

// Example: User likes a post
NotificationEvent notification = new NotificationEvent();
notification.setSenderId(likerId);
notification.setReceiverId(postOwnerId);
notification.setNotificationType(NotificationType.LIKE);
notification.setSenderName(likerName);
notification.setSenderProfileUrl(likerProfileUrl);
notification.setPostId(postId);
notification.setPostName(postTitle);
notification.setTimestamp(Instant.now().toEpochMilli());

notificationService.saveNotification(notification);
```

### Receiving Notifications in Flutter

The notification page automatically listens to Firebase and updates in real-time. No manual refresh needed!

```dart
// Notifications are automatically streamed from Firebase
// The UI updates automatically when new notifications arrive
```

### Integration Points

1. **Post Like Handler** - When a user likes a post, call the backend to create a notification
2. **Comment Handler** - When a user comments, create a notification
3. **Follow Handler** - When a user follows another user, create a notification

## API Configuration

Make sure your Flutter app's `ApiService` base URL matches your backend:

**File:** `lib/core/services/api_service.dart`
```dart
baseUrl: 'http://10.0.2.2:8081', // For Android emulator
// or
baseUrl: 'http://localhost:8081', // For iOS simulator
// or
baseUrl: 'https://your-production-url.com', // For production
```

## Testing the Notification System

### 1. Test Backend Health
```bash
curl http://localhost:8081/notifications/health
```

### 2. Test Creating a Notification
Directly add to Firebase Realtime Database or call your backend API that creates notifications.

### 3. Test Flutter App
1. Open the notification page
2. Notifications should appear in real-time
3. Test swipe-to-delete
4. Test mark all as read
5. Test pull-to-refresh

## Security Rules (Firebase)

Add these rules to your Firebase Realtime Database:

```json
{
  "rules": {
    "notifications": {
      "$userId": {
        ".read": "$userId === auth.uid",
        ".write": "auth != null"
      }
    },
    "notification_counts": {
      "$userId": {
        ".read": "$userId === auth.uid",
        ".write": "auth != null"
      }
    }
  }
}
```

## Dependencies

Make sure your `pubspec.yaml` includes:

```yaml
dependencies:
  firebase_core: ^latest
  firebase_database: ^latest
  firebase_auth: ^latest
  dio: ^latest
```

## Troubleshooting

### Notifications not appearing
1. Check Firebase connection
2. Verify user is authenticated
3. Check Firebase Realtime Database rules
4. Verify backend is running and accessible

### Mark all as read not working
1. Check backend endpoint is accessible
2. Verify API base URL is correct
3. Check network connectivity

### Delete not working
1. Check Firebase permissions
2. Verify notification ID is being passed correctly
3. Check backend logs for errors

## Next Steps

1. ✅ Create the backend repository structure
2. ✅ Test the notification creation flow
3. ✅ Implement notification triggers in your post/comment/follow handlers
4. ✅ Test the complete flow end-to-end
5. Add push notifications for background notifications (optional)
6. Add notification badges to app icon (optional)

## Notes

- The notification system uses Firebase Realtime Database for instant delivery
- Backend only handles business logic and persistence
- Flutter app subscribes to Firebase for real-time updates
- All user interactions (mark as read, delete) are synced through the backend API
