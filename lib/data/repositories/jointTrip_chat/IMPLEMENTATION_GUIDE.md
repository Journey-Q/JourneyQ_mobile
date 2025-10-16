# Joint Trip Group Chat - Quick Implementation Guide

## What Has Been Created

I've set up a complete Firebase Realtime Database system for your Joint Trip group chat feature with the following files:

### 1. Repository Files
- **`jointTrip_group.dart`** - Group management (create, join, leave, delete, update)
- **`joint_trip_group_chats.dart`** - Chat messages (send, receive, real-time updates)
- **`models/joint_trip_models.dart`** - Type-safe data models

### 2. Documentation Files
- **`README.md`** - Complete documentation with API reference
- **`integration_example.dart`** - Practical code examples
- **`IMPLEMENTATION_GUIDE.md`** - This quick start guide

## Quick Start (5 Steps)

### Step 1: Firebase Initialization
Your Firebase is already configured in `lib/core/config/firebase_config.dart`. Make sure it's initialized when your app starts:

```dart
// In main.dart or app startup
await FirebaseConfig.instance.initialize();
```

### Step 2: Create Group When Trip is Created
In your `create_trip_form.dart`, after successful trip creation:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

// After trip is created successfully
final tripId = response['tripId'] as int;

await JointTripGroupRepository.createGroup(
  tripId: tripId,
  groupName: formData['title'], // Trip title
  creatorId: currentUserId,
  creatorName: currentUserName,
  creatorAvatar: currentUserAvatar,
);
```

### Step 3: Add User to Group When Request Accepted
In your request acceptance logic:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

// After accepting trip request
await JointTripGroupRepository.addUserToGroup(
  tripId: tripId,
  userId: currentUserId,
  userName: currentUserName,
  userAvatar: currentUserAvatar,
);
```

### Step 4: Update Group Chat Screen
Replace static data with Firebase:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/joint_trip_group_chats.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/models/joint_trip_models.dart';

class _GroupChatScreenState extends State<GroupChatScreen> {
  Stream<List<Map<String, dynamic>>>? _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = JointTripGroupChatsRepository.listenToMessages(
      tripId: widget.tripId,
      limit: 50,
    );
  }

  void _sendMessage() async {
    await JointTripGroupChatsRepository.sendMessage(
      tripId: widget.tripId,
      senderId: getCurrentUserId(),
      senderName: getCurrentUserName(),
      senderAvatar: getCurrentUserAvatar(),
      messageText: _messageController.text.trim(),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _messagesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final messages = snapshot.data!
            .map((m) => ChatMessage.fromMap(m))
            .toList();

        return ListView.builder(...);
      },
    );
  }
}
```

### Step 5: Update Group Lists
In your trip groups tab:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

// Load My Groups (created by user)
Future<List<Map<String, dynamic>>> _loadMyGroups() async {
  final userId = getCurrentUserId();
  return await JointTripGroupRepository.getCreatedGroups(userId);
}

// Load Joined Groups (created by others)
Future<List<Map<String, dynamic>>> _loadJoinedGroups() async {
  final userId = getCurrentUserId();
  return await JointTripGroupRepository.getJoinedGroups(userId);
}
```

## Database Structure Overview

```
Firebase Realtime Database
├── jointTrip_groups/
│   └── trip_{tripId}/
│       ├── groupId: "trip_123"
│       ├── groupName: "Trip to Kandy"
│       ├── groupProfile: "https://..."
│       ├── tripId: 123
│       ├── creatorId: 1
│       ├── createdAt: 1234567890
│       ├── updatedAt: 1234567890
│       └── members/
│           └── {userId}/
│               ├── userId: 1
│               ├── userName: "John"
│               ├── userAvatar: "https://..."
│               ├── joinedAt: 1234567890
│               └── role: "creator"
│
└── jointTrip_group_chats/
    └── trip_{tripId}/
        ├── messages/
        │   └── {messageId}/
        │       ├── messageId: "abc123"
        │       ├── senderId: 1
        │       ├── senderName: "John"
        │       ├── messageText: "Hello!"
        │       ├── timestamp: 1234567890
        │       └── ...
        ├── lastMessage/
        │   ├── text: "Hello!"
        │   ├── senderId: 1
        │   └── timestamp: 1234567890
        └── typing/
            └── {userId}: true
```

## Key Features

### Group Management
✅ Create group automatically when trip is created
✅ Add users when they accept trip requests
✅ Update group name and profile
✅ Leave group (for joined groups)
✅ Delete group (for created groups)
✅ Remove members (creator only)
✅ Get group details and members

### Chat Functionality
✅ Send text messages
✅ Real-time message updates
✅ Typing indicators
✅ Message history
✅ Last message tracking
✅ Search messages
✅ Delete messages

### Organization
✅ My Groups - Groups created by user
✅ Joined Groups - Groups user joined
✅ Group member list
✅ Group creator identification

## Helper Methods You'll Need

Create these utility methods in your app:

```dart
// Get current logged-in user ID
int getCurrentUserId() {
  // Return from your auth system
  return 1; // Example
}

// Get current user name
String getCurrentUserName() {
  // Return from your auth system
  return "John Doe"; // Example
}

// Get current user avatar URL
String getCurrentUserAvatar() {
  // Return from your auth system
  return "https://example.com/avatar.jpg"; // Example
}
```

## Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `journeyq-bfbbd`
3. Navigate to **Realtime Database**
4. Go to **Rules** tab
5. For development, use:
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

## Common Operations

### Send a Message
```dart
await JointTripGroupChatsRepository.sendMessage(
  tripId: 123,
  senderId: 1,
  senderName: "John",
  senderAvatar: "https://...",
  messageText: "Hello!",
);
```

### Listen to Messages
```dart
JointTripGroupChatsRepository.listenToMessages(
  tripId: 123,
  limit: 50,
).listen((messages) {
  // Update UI with new messages
});
```

### Update Group Name
```dart
await JointTripGroupRepository.updateGroupName(
  tripId: 123,
  newGroupName: "New Name",
);
```

### Leave Group
```dart
await JointTripGroupRepository.leaveGroup(
  tripId: 123,
  userId: 1,
);
```

### Delete Group
```dart
await JointTripGroupRepository.deleteGroup(
  tripId: 123,
  userId: 1,
);
```

## Testing Checklist

- [ ] Firebase initialized on app startup
- [ ] Group created when trip is created
- [ ] User added to group when request accepted
- [ ] Messages send and appear in real-time
- [ ] Group name can be updated
- [ ] Group profile can be updated
- [ ] User can leave joined groups
- [ ] Creator can delete their groups
- [ ] My Groups tab shows created groups
- [ ] Joined Groups tab shows joined groups
- [ ] Group members displayed correctly

## Troubleshooting

### Issue: Firebase not initialized
**Solution**: Call `await FirebaseConfig.instance.initialize()` in `main()` before `runApp()`

### Issue: Messages not appearing
**Solution**:
1. Check Firebase Console database rules
2. Verify group exists in Firebase
3. Check internet connection
4. Look for errors in console logs

### Issue: Group creation fails
**Solution**:
1. Verify trip was created successfully first
2. Check user info is available (ID, name, avatar)
3. Check Firebase initialization
4. Verify database rules allow write access

## Next Steps

1. ✅ **Test Basic Flow**
   - Create a trip → Group should be created
   - Accept request → User should join group
   - Send message → Message should appear

2. ✅ **Integrate with UI**
   - Update existing chat screens with Firebase data
   - Replace mock data with real-time streams
   - Add loading and error states

3. ✅ **Add Polish**
   - Typing indicators
   - Read receipts (optional)
   - Message timestamps
   - User avatars in chat

4. ✅ **Test Edge Cases**
   - No internet connection
   - User leaves during chat
   - Group deleted while viewing
   - Multiple users typing

## Important Files to Modify

1. **`lib/features/join_trip/pages/create_trip_form.dart`**
   - Add group creation after trip creation

2. **`lib/data/repositories/joint_trip_repository/trip_request_repository.dart`**
   - Add user to group when accepting request

3. **`lib/features/join_trip/pages/group_chat_screen.dart`**
   - Replace static data with Firebase streams

4. **`lib/features/join_trip/pages/trip_groups_tab.dart`**
   - Load groups from Firebase

5. **`lib/features/join_trip/pages/group_details_page.dart`**
   - Add Firebase operations for update/delete/leave

## Support Resources

- **Firebase Console**: https://console.firebase.google.com/
- **Your Database URL**: https://journeyq-bfbbd-default-rtdb.firebaseio.com/
- **README.md**: Detailed API documentation
- **integration_example.dart**: Code examples for every feature

## Notes

- Group IDs use format: `trip_{tripId}` (e.g., `trip_123`)
- Timestamps are in milliseconds since epoch
- All methods are async and throw exceptions on failure
- Use try-catch blocks for error handling
- Print statements are for development only (warnings are expected)

---

**You're all set!** Start with Step 1 and work through each step. The complete feature should take 2-3 hours to integrate fully.

If you need help with any specific integration, refer to the detailed examples in `integration_example.dart`.
