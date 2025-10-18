# Group ID Integration Guide

## Overview

Your backend API requires a `groupId` (Long/int) when sending trip requests. This guide explains how the group ID system works and how to integrate it properly.

## Group ID System

### Simple Approach: tripId = groupId

For simplicity, we use the **trip ID as the group ID**:
- When trip ID = 123, group ID = 123
- This creates a 1:1 mapping between trips and groups

### Firebase vs Backend Group IDs

There are TWO representations of group IDs:

1. **Backend Group ID** (numeric): Used in API requests
   - Format: `123` (Long/int)
   - Used in: `/trip-requests/send` API call
   - Stored in: Backend database tables

2. **Firebase Group ID** (string): Used in Firebase database
   - Format: `"trip_123"` (String)
   - Used in: Firebase Realtime Database keys
   - Why different: Firebase requires string keys for better organization

## Helper Utility

Use `GroupIdHelper` for conversions:

```dart
import 'package:journeyq/data/repositories/jointTrip_chat/utils/group_id_helper.dart';

// Generate numeric group ID for backend API
final groupId = GroupIdHelper.generateGroupId(tripId); // 123 -> 123

// Generate Firebase group ID for database
final firebaseGroupId = GroupIdHelper.generateFirebaseGroupId(tripId); // 123 -> "trip_123"

// Or use extensions
final groupId = tripId.groupId; // 123
final firebaseGroupId = tripId.firebaseGroupId; // "trip_123"
```

## Complete Integration Flow

### Step 1: Create Trip and Group

When user creates a trip:

```dart
import 'package:journeyq/data/repositories/joint_trip_repository/trip_repository.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/utils/group_id_helper.dart';

Future<Map<String, dynamic>> createTrip(Map<String, dynamic> formData) async {
  // 1. Create trip in backend
  final response = await TripRepository.createTripFromForm(formData);
  final tripId = response['tripId'] as int;

  // 2. Generate group ID (same as trip ID)
  final groupId = GroupIdHelper.generateGroupId(tripId);

  // 3. Create Firebase group
  await JointTripGroupRepository.createGroup(
    tripId: tripId,
    groupName: formData['title'],
    creatorId: currentUserId,
    creatorName: currentUserName,
    creatorAvatar: currentUserAvatar,
  );

  return {
    'tripId': tripId,
    'groupId': groupId,
  };
}
```

### Step 2: Send Trip Requests

When sending invitations to followers:

```dart
import 'package:journeyq/data/repositories/joint_trip_repository/trip_request_repository.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/utils/group_id_helper.dart';

Future<void> sendInvitations({
  required int tripId,
  required List<int> followerIds,
}) async {
  // Generate group ID from trip ID
  final groupId = GroupIdHelper.generateGroupId(tripId);

  // Send requests to backend (includes groupId)
  final result = await TripRequestRepository.sendTripRequests(
    tripId: tripId,
    groupId: groupId,  // ← Required by backend
    receiverIds: followerIds,
  );

  print('Sent ${result['count']} requests');
}
```

### Step 3: Accept Request and Join Group

When follower accepts a request:

```dart
import 'package:journeyq/data/repositories/joint_trip_repository/trip_request_repository.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';

Future<void> acceptInvitation(int requestId, int tripId) async {
  // 1. Accept request in backend
  await TripRequestRepository.acceptRequest(requestId);

  // 2. Add user to Firebase group
  await JointTripGroupRepository.addUserToGroup(
    tripId: tripId,
    userId: currentUserId,
    userName: currentUserName,
    userAvatar: currentUserAvatar,
  );
}
```

## API Request Format

### POST /trip-requests/send

**Request Body:**
```json
{
  "tripId": 123,
  "groupId": 123,
  "receiverIds": [5, 8, 12]
}
```

**Code Example:**
```dart
// Using TripRequestRepository
await TripRequestRepository.sendTripRequests(
  tripId: 123,
  groupId: 123,  // ← Same as tripId
  receiverIds: [5, 8, 12],
);
```

## Practical Examples

### Example 1: Complete Trip Creation Flow

```dart
// In your create_trip_form.dart
Future<void> _handleTripSubmission(Map<String, dynamic> formData) async {
  try {
    // Create trip in backend
    final response = await TripRepository.createTripFromForm(formData);
    final tripId = response['tripId'] as int;
    final groupId = tripId; // Simple: tripId = groupId

    // Create Firebase group
    await JointTripGroupRepository.createGroup(
      tripId: tripId,
      groupName: formData['title'],
      creatorId: getCurrentUserId(),
      creatorName: getCurrentUserName(),
      creatorAvatar: getCurrentUserAvatar(),
    );

    // Navigate to send invitations screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendInvitationsScreen(
          tripId: tripId,
          groupId: groupId,
        ),
      ),
    );
  } catch (e) {
    // Handle error
  }
}
```

### Example 2: Send Invitations After Trip Creation

```dart
// In your send_invitations_screen.dart
class SendInvitationsScreen extends StatelessWidget {
  final int tripId;
  final int groupId;

  Future<void> sendInvitations(List<int> selectedFollowerIds) async {
    try {
      final result = await TripRequestRepository.sendTripRequests(
        tripId: tripId,
        groupId: groupId,
        receiverIds: selectedFollowerIds,
      );

      // Show success message
      print('Sent ${result['count']} invitations');
      Navigator.pop(context);
    } catch (e) {
      // Handle error
    }
  }
}
```

### Example 3: Combined Flow (Create + Send in One Step)

```dart
// All-in-one function
Future<void> createTripAndSendInvitations({
  required Map<String, dynamic> tripFormData,
  required List<int> selectedFollowerIds,
}) async {
  try {
    // 1. Create trip
    final response = await TripRepository.createTripFromForm(tripFormData);
    final tripId = response['tripId'] as int;
    final groupId = tripId;

    // 2. Create Firebase group
    await JointTripGroupRepository.createGroup(
      tripId: tripId,
      groupName: tripFormData['title'],
      creatorId: getCurrentUserId(),
      creatorName: getCurrentUserName(),
      creatorAvatar: getCurrentUserAvatar(),
    );

    // 3. Send invitations immediately
    if (selectedFollowerIds.isNotEmpty) {
      await TripRequestRepository.sendTripRequests(
        tripId: tripId,
        groupId: groupId,
        receiverIds: selectedFollowerIds,
      );
    }

    print('✅ Trip created and invitations sent!');
  } catch (e) {
    print('❌ Error: $e');
    rethrow;
  }
}
```

## Where to Update Your Code

### 1. Update `create_trip_form.dart`

**Current code** (without groupId):
```dart
// Old - Missing groupId
await TripRequestRepository.sendTripRequests(
  tripId: tripId,
  receiverIds: followerIds,
);
```

**Updated code** (with groupId):
```dart
// New - Includes groupId
final groupId = tripId; // or use GroupIdHelper.generateGroupId(tripId)
await TripRequestRepository.sendTripRequests(
  tripId: tripId,
  groupId: groupId,  // ← Add this
  receiverIds: followerIds,
);
```

### 2. Update Any Send Request Screens

Find all places where you call `sendTripRequests()` and add the `groupId` parameter.

**Quick Find:**
Search your codebase for: `sendTripRequests(`

## Data Flow Diagram

```
User Creates Trip
       ↓
Backend API: POST /trips/create
       ↓
Returns: tripId = 123
       ↓
Generate: groupId = 123 (same as tripId)
       ↓
Firebase: Create group at "trip_123"
       ↓
User Selects Followers
       ↓
Backend API: POST /trip-requests/send
       ↓
Send: {tripId: 123, groupId: 123, receiverIds: [5,8,12]}
       ↓
Backend: Creates requests with groupId
       ↓
Followers Accept Request
       ↓
Backend API: PUT /trip-requests/{requestId}/accept
       ↓
Firebase: Add user to group "trip_123"
       ↓
Users Can Chat in Group
```

## Database Storage

### Backend Database (Spring Boot)
```sql
-- joint_trip table
trip_id: 123
group_id: 123  -- Stored here

-- trip_join_request table
request_id: 1
trip_id: 123
group_id: 123  -- Also stored here
sender_id: 2
receiver_id: 5
```

### Firebase Database
```json
{
  "jointTrip_groups": {
    "trip_123": {  // ← String key format
      "groupId": "trip_123",
      "tripId": 123,
      "groupName": "Beach Trip",
      "members": { ... }
    }
  }
}
```

## Important Notes

1. **Group ID = Trip ID**: For simplicity, always use `groupId = tripId`

2. **Two Formats**:
   - Backend: numeric (123)
   - Firebase: string ("trip_123")

3. **Use Helper**: Use `GroupIdHelper` for conversions to avoid errors

4. **Required Field**: Backend API now **requires** `groupId` in send requests

5. **Breaking Change**: If you have existing code calling `sendTripRequests()` without `groupId`, it will fail. Update all calls.

## Testing Checklist

- [ ] Trip creation generates correct groupId
- [ ] Firebase group created with correct ID format
- [ ] Send requests includes groupId in API call
- [ ] Backend accepts requests with groupId
- [ ] Request acceptance adds user to Firebase group
- [ ] Group chat works with correct group ID

## Troubleshooting

### Error: "groupId is required"
**Solution**: Add `groupId` parameter to `sendTripRequests()` call

### Error: "Group not found in Firebase"
**Solution**: Ensure Firebase group is created before sending requests

### Error: "Invalid group ID format"
**Solution**: Use `GroupIdHelper` to generate correct format

## Quick Reference

```dart
// Generate group ID
final groupId = tripId; // Simple way
// or
final groupId = GroupIdHelper.generateGroupId(tripId); // Using helper

// Generate Firebase group ID
final firebaseGroupId = GroupIdHelper.generateFirebaseGroupId(tripId);

// Send requests with groupId
await TripRequestRepository.sendTripRequests(
  tripId: tripId,
  groupId: groupId,  // ← Required
  receiverIds: followerIds,
);

// Create Firebase group
await JointTripGroupRepository.createGroup(
  tripId: tripId,  // Uses this to create "trip_{tripId}" key
  groupName: groupName,
  creatorId: userId,
  creatorName: userName,
  creatorAvatar: userAvatar,
);
```

## Summary

✅ **Group ID = Trip ID** (for simplicity)
✅ **Backend uses numeric format** (123)
✅ **Firebase uses string format** ("trip_123")
✅ **Always include groupId** when sending requests
✅ **Use GroupIdHelper** for conversions

---

**You're all set!** The `groupId` is now properly integrated into the trip request flow.
