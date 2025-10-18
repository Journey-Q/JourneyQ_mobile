# Joint Trip Group Chat - Firebase Realtime Database Integration

This package provides Firebase Realtime Database integration for the Joint Trip group chat feature.

## Overview

The group chat system allows users to:
- Create groups automatically when creating a joint trip
- Join groups automatically when accepting trip requests
- Send and receive real-time messages
- Update group name and profile
- Leave groups (for joined groups) or delete groups (for created groups)
- View group members and details

## Files Structure

```
lib/data/repositories/jointTrip_chat/
├── jointTrip_group.dart              # Group management repository
├── joint_trip_group_chats.dart       # Chat messages repository
├── models/
│   └── joint_trip_models.dart        # Data models
└── README.md                          # This file
```

## Database Structure

### Firebase Realtime Database Schema

```
jointTrip_groups/
  {groupId}/                          # Format: "trip_{tripId}"
    groupId: String
    groupName: String                 # Same as trip title initially
    groupProfile: String?             # URL to group image (nullable)
    tripId: int                       # Corresponding trip ID from backend
    creatorId: int                    # User who created the trip
    createdAt: timestamp
    updatedAt: timestamp
    members/
      {userId}/
        userId: int
        userName: String
        userAvatar: String
        joinedAt: timestamp
        role: String                  # "creator" or "member"

jointTrip_group_chats/
  {groupId}/                          # Same groupId as above
    messages/
      {messageId}/                    # Auto-generated push key
        messageId: String
        senderId: int
        senderName: String
        senderAvatar: String
        messageText: String
        messageType: String           # "text", "image", "location", "file"
        timestamp: int
        attachmentUrl: String?        # For images/files
        isDeleted: bool
        deletedAt: int?
    lastMessage/
      text: String
      senderId: int
      senderName: String
      timestamp: int
    typing/
      {userId}: bool                  # Real-time typing indicators
```

## Integration Steps

### 1. Initialize Firebase in your App

Make sure Firebase is initialized when your app starts:

```dart
import 'package:journeyq/core/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for chat
  await FirebaseConfig.instance.initialize();

  runApp(MyApp());
}
```

### 2. Create Group When Trip is Created

In your `create_trip_form.dart`, after successfully creating a trip, create the group:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

Future<void> _handleTripSubmission(Map<String, dynamic> formData) async {
  try {
    // Create trip in backend
    final response = await TripRepository.createTripFromForm(formData);
    final tripId = response['tripId'] as int;

    // Get current user info (from your auth system)
    final userId = getCurrentUserId();
    final userName = getCurrentUserName();
    final userAvatar = getCurrentUserAvatar();

    // Create Firebase group
    await JointTripGroupRepository.createGroup(
      tripId: tripId,
      groupName: formData['title'], // Use trip title as group name
      creatorId: userId,
      creatorName: userName,
      creatorAvatar: userAvatar,
      groupProfile: null, // Initially null, can be updated later
    );

    print('✅ Trip and group created successfully!');
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

### 3. Add User to Group When Request is Accepted

In your `trip_request_repository.dart`, after accepting a request:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

static Future<Map<String, dynamic>> acceptRequest(int requestId) async {
  try {
    // Accept request in backend
    final response = await ApiService.put('/trip-requests/$requestId/accept');

    if (response.data != null && response.data['success'] == true) {
      // Get trip and user info from response
      final tripId = response.data['data']['tripId'] as int;
      final userId = getCurrentUserId();
      final userName = getCurrentUserName();
      final userAvatar = getCurrentUserAvatar();

      // Add user to Firebase group
      await JointTripGroupRepository.addUserToGroup(
        tripId: tripId,
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
      );

      return {
        'success': true,
        'message': 'Request accepted and joined group successfully',
      };
    }
  } catch (e) {
    print('Error accepting request: $e');
    rethrow;
  }
}
```

### 4. Display Group Chat Screen

Update your `group_chat_screen.dart` to use Firebase:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/joint_trip_group_chats.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/models/joint_trip_models.dart';

class GroupChatScreen extends StatefulWidget {
  final int tripId;
  final String groupName;

  // ... constructor
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  Stream<List<Map<String, dynamic>>>? _messagesStream;

  @override
  void initState() {
    super.initState();
    // Listen to messages in real-time
    _messagesStream = JointTripGroupChatsRepository.listenToMessages(
      tripId: widget.tripId,
      limit: 50,
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await JointTripGroupChatsRepository.sendMessage(
        tripId: widget.tripId,
        senderId: getCurrentUserId(),
        senderName: getCurrentUserName(),
        senderAvatar: getCurrentUserAvatar(),
        messageText: _messageController.text.trim(),
        messageType: 'text',
      );

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!
                    .map((m) => ChatMessage.fromMap(m))
                    .toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == getCurrentUserId();

                    return ChatMessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputBar(
            messageController: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
```

### 5. Display Group List (My Groups & Joined Groups)

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/models/joint_trip_models.dart';

class TripGroupsTab extends StatefulWidget {
  // ...
}

class _TripGroupsTabState extends State<TripGroupsTab> {
  Future<List<JointTripGroup>> _loadMyGroups() async {
    final userId = getCurrentUserId();
    final groupsData = await JointTripGroupRepository.getCreatedGroups(userId);
    return groupsData.map((g) => JointTripGroup.fromMap(g)).toList();
  }

  Future<List<JointTripGroup>> _loadJoinedGroups() async {
    final userId = getCurrentUserId();
    final groupsData = await JointTripGroupRepository.getJoinedGroups(userId);
    return groupsData.map((g) => JointTripGroup.fromMap(g)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'My Groups'),
              Tab(text: 'Joined Groups'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // My Groups Tab
                FutureBuilder<List<JointTripGroup>>(
                  future: _loadMyGroups(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final group = snapshot.data![index];
                        return GroupListTile(
                          group: group,
                          onTap: () => navigateToChat(group.tripId),
                        );
                      },
                    );
                  },
                ),

                // Joined Groups Tab
                FutureBuilder<List<JointTripGroup>>(
                  future: _loadJoinedGroups(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final group = snapshot.data![index];
                        return GroupListTile(
                          group: group,
                          onTap: () => navigateToChat(group.tripId),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 6. Update Group Details

In your `group_details_page.dart`:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

// Update group name
void _updateGroupName(int tripId, String newName) async {
  try {
    await JointTripGroupRepository.updateGroupName(
      tripId: tripId,
      newGroupName: newName,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Group name updated successfully')),
    );
  } catch (e) {
    print('Error updating group name: $e');
  }
}

// Update group profile
void _updateGroupProfile(int tripId, String profileUrl) async {
  try {
    await JointTripGroupRepository.updateGroupProfile(
      tripId: tripId,
      profileUrl: profileUrl,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Group profile updated successfully')),
    );
  } catch (e) {
    print('Error updating group profile: $e');
  }
}
```

### 7. Leave or Delete Group

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

// Leave group (for joined groups)
void _leaveGroup(int tripId) async {
  try {
    final userId = getCurrentUserId();
    await JointTripGroupRepository.leaveGroup(
      tripId: tripId,
      userId: userId,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have left the group')),
    );
  } catch (e) {
    print('Error leaving group: $e');
  }
}

// Delete group (for created groups)
void _deleteGroup(int tripId) async {
  try {
    final userId = getCurrentUserId();

    // Delete group from Firebase
    await JointTripGroupRepository.deleteGroup(
      tripId: tripId,
      userId: userId,
    );

    // Delete all messages
    await JointTripGroupChatsRepository.deleteAllMessages(tripId);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Group deleted successfully')),
    );
  } catch (e) {
    print('Error deleting group: $e');
  }
}
```

## Important Notes

### 1. Firebase Rules Configuration

Set your Firebase Realtime Database rules to allow open access (for development):

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

**For production**, use proper security rules:

```json
{
  "rules": {
    "jointTrip_groups": {
      "$groupId": {
        ".read": "auth != null",
        ".write": "auth != null"
      }
    },
    "jointTrip_group_chats": {
      "$groupId": {
        ".read": "auth != null",
        "messages": {
          ".write": "auth != null"
        }
      }
    }
  }
}
```

### 2. Group ID Format

Group IDs are generated from trip IDs with the format: `trip_{tripId}`

Example:
- Trip ID: `123` → Group ID: `trip_123`
- Trip ID: `456` → Group ID: `trip_456`

### 3. Timestamp Format

All timestamps use milliseconds since epoch:
```dart
final timestamp = DateTime.now().millisecondsSinceEpoch;
```

### 4. Message Types

Supported message types:
- `text` - Plain text messages
- `image` - Image attachments
- `location` - Location sharing
- `file` - File attachments

### 5. Real-time Updates

Use streams for real-time updates:
- `listenToMessages()` - Listen to chat messages
- `listenToGroup()` - Listen to group changes
- `listenToGroupMembers()` - Listen to member changes
- `listenToTypingStatus()` - Listen to typing indicators
- `listenToLastMessage()` - Listen to last message updates

### 6. Error Handling

All repository methods throw exceptions on failure. Always wrap calls in try-catch:

```dart
try {
  await JointTripGroupRepository.createGroup(...);
} catch (e) {
  print('Error: $e');
  // Show error to user
}
```

### 7. Clean Up on Trip Deletion

When a trip is deleted from backend, also delete the Firebase group:

```dart
// In trip_repository.dart deleteTrip method
static Future<void> deleteTrip(int tripId) async {
  try {
    // Delete from backend
    await ApiService.delete('/trips/$tripId');

    // Delete Firebase group and messages
    final userId = getCurrentUserId();
    await JointTripGroupRepository.deleteGroup(
      tripId: tripId,
      userId: userId,
    );
    await JointTripGroupChatsRepository.deleteAllMessages(tripId);
  } catch (e) {
    print('Error deleting trip: $e');
    rethrow;
  }
}
```

## API Reference

### JointTripGroupRepository

#### Methods:
- `createGroup()` - Create new group when trip is created
- `addUserToGroup()` - Add user when request is accepted
- `updateGroupName()` - Update group name
- `updateGroupProfile()` - Update group profile image
- `leaveGroup()` - User leaves a joined group
- `deleteGroup()` - Creator deletes the group
- `getGroupDetails()` - Get group information
- `getGroupMembers()` - Get list of members
- `getUserGroups()` - Get all groups user is in
- `getCreatedGroups()` - Get groups created by user
- `getJoinedGroups()` - Get groups user joined
- `isUserInGroup()` - Check if user is member
- `listenToGroup()` - Real-time group updates
- `listenToGroupMembers()` - Real-time member updates
- `removeMember()` - Creator removes a member

### JointTripGroupChatsRepository

#### Methods:
- `sendMessage()` - Send a message
- `getMessages()` - Get messages (paginated)
- `getRecentMessages()` - Get recent messages
- `deleteMessage()` - Delete own message
- `getLastMessage()` - Get last message
- `listenToMessages()` - Real-time message updates
- `listenToLastMessage()` - Real-time last message updates
- `setTypingStatus()` - Set typing indicator
- `listenToTypingStatus()` - Listen to typing indicators
- `getMessageCount()` - Get total message count
- `searchMessages()` - Search messages by text
- `deleteAllMessages()` - Delete all group messages
- `getMessagesByDateRange()` - Get messages in date range
- `getMessagesByUser()` - Get messages from specific user
- `listenToNewMessages()` - Listen to new messages only
- `getUnreadMessageCount()` - Get unread count

## Testing

Test the integration step by step:

1. **Test Group Creation**:
   - Create a new trip
   - Verify group is created in Firebase Console
   - Check that creator is added as member

2. **Test User Addition**:
   - Send trip request
   - Accept request
   - Verify user is added to group in Firebase

3. **Test Messaging**:
   - Open group chat
   - Send messages
   - Verify messages appear in real-time
   - Check Firebase Console for message data

4. **Test Group Operations**:
   - Update group name
   - Update group profile
   - Leave group (for joined groups)
   - Delete group (for created groups)

## Troubleshooting

### Firebase Connection Issues

If you see connection errors:
1. Check that Firebase is initialized before use
2. Verify Firebase config credentials in `firebase_config.dart`
3. Check database rules in Firebase Console

### Messages Not Appearing

1. Check that group exists in Firebase
2. Verify user is a member of the group
3. Check console logs for errors
4. Verify internet connection

### Group Creation Fails

1. Ensure trip is created successfully first
2. Check that user info (ID, name, avatar) is available
3. Verify Firebase initialization
4. Check Firebase Console for error logs

## Support

For issues or questions, check:
- Firebase Console: https://console.firebase.google.com/
- Your Firebase Database URL: https://journeyq-bfbbd-default-rtdb.firebaseio.com/
- Project logs in your IDE

## Future Enhancements

Consider implementing:
- Message reactions (likes, emojis)
- Message replies/threads
- Voice messages
- Video calls
- Message read receipts
- Push notifications for new messages
- Message forwarding
- Media gallery
- Chat backup/export
