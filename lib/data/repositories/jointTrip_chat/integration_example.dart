// Integration Example: How to use Joint Trip Group Chat repositories
//
// This file shows practical examples of integrating the Firebase group chat
// functionality with your existing backend trip system.

import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/joint_trip_group_chats.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/models/joint_trip_models.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/utils/group_id_helper.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/trip_repository.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/trip_request_repository.dart';

// ============================================================================
// EXAMPLE 1: Create Trip with Group and Send Requests
// ============================================================================
//
// Call this after user submits the create trip form
// This creates both the backend trip and Firebase group, then sends requests

class TripCreationExample {
  static Future<Map<String, dynamic>> createTripWithGroup({
    required Map<String, dynamic> tripFormData,
    required int currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
    List<int>? receiverIds, // Optional: Send requests immediately
  }) async {
    try {
      // Step 1: Create trip in backend
      print('Creating trip in backend...');
      final response = await TripRepository.createTripFromForm(tripFormData);
      final tripId = response['tripId'] as int;
      print('✅ Trip created with ID: $tripId');

      // Step 2: Generate group ID (same as trip ID for simplicity)
      final groupId = GroupIdHelper.generateGroupId(tripId);
      print('📝 Group ID: $groupId');

      // Step 3: Create Firebase group for the trip
      print('Creating Firebase group...');
      await JointTripGroupRepository.createGroup(
        tripId: tripId,
        groupName: tripFormData['title'], // Use trip title as initial group name
        creatorId: currentUserId,
        creatorName: currentUserName,
        creatorAvatar: currentUserAvatar,
        groupProfile: null, // Can be updated later
      );
      print('✅ Firebase group created successfully');

      // Step 4: Send trip requests if receiver IDs provided
      Map<String, dynamic>? requestResult;
      if (receiverIds != null && receiverIds.isNotEmpty) {
        print('Sending trip requests to ${receiverIds.length} users...');
        requestResult = await TripRequestRepository.sendTripRequests(
          tripId: tripId,
          groupId: groupId,
          receiverIds: receiverIds,
        );
        print('✅ Trip requests sent: ${requestResult['count']} successful');
      }

      // Step 5: Return complete result
      print('✅ Trip and group creation complete!');
      return {
        'tripId': tripId,
        'groupId': groupId,
        'firebaseGroupId': GroupIdHelper.generateFirebaseGroupId(tripId),
        'requestResult': requestResult,
      };
    } catch (e) {
      print('❌ Error creating trip with group: $e');
      rethrow;
    }
  }

  // Alternative: Create trip and group first, send requests later
  static Future<Map<String, dynamic>> createTripWithGroupOnly({
    required Map<String, dynamic> tripFormData,
    required int currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
  }) async {
    try {
      // Create trip in backend
      final response = await TripRepository.createTripFromForm(tripFormData);
      final tripId = response['tripId'] as int;
      final groupId = GroupIdHelper.generateGroupId(tripId);

      // Create Firebase group
      await JointTripGroupRepository.createGroup(
        tripId: tripId,
        groupName: tripFormData['title'],
        creatorId: currentUserId,
        creatorName: currentUserName,
        creatorAvatar: currentUserAvatar,
      );

      return {
        'tripId': tripId,
        'groupId': groupId,
        'firebaseGroupId': GroupIdHelper.generateFirebaseGroupId(tripId),
      };
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // Send requests after trip creation
  static Future<Map<String, dynamic>> sendTripRequests({
    required int tripId,
    required List<int> receiverIds,
  }) async {
    try {
      final groupId = GroupIdHelper.generateGroupId(tripId);

      final result = await TripRequestRepository.sendTripRequests(
        tripId: tripId,
        groupId: groupId,
        receiverIds: receiverIds,
      );

      print('✅ Sent ${result['count']} trip requests');
      return result;
    } catch (e) {
      print('❌ Error sending requests: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 2: Accept Request and Join Group
// ============================================================================
//
// Call this when user accepts a trip request
// This accepts the request in backend and adds user to Firebase group

class RequestAcceptanceExample {
  static Future<void> acceptRequestAndJoinGroup({
    required int requestId,
    required int tripId,
    required int currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
  }) async {
    try {
      // Step 1: Accept request in backend
      print('Accepting request in backend...');
      final response = await TripRequestRepository.acceptRequest(requestId);
      print('✅ Request accepted: ${response['message']}');

      // Step 2: Add user to Firebase group
      print('Adding user to Firebase group...');
      await JointTripGroupRepository.addUserToGroup(
        tripId: tripId,
        userId: currentUserId,
        userName: currentUserName,
        userAvatar: currentUserAvatar,
      );
      print('✅ User added to group successfully');

      print('✅ Request acceptance and group join complete!');
    } catch (e) {
      print('❌ Error accepting request: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 3: Send Message in Group Chat
// ============================================================================
//
// Call this when user sends a message in the group chat

class MessageSendingExample {
  static Future<void> sendTextMessage({
    required int tripId,
    required int senderId,
    required String senderName,
    required String senderAvatar,
    required String messageText,
  }) async {
    try {
      print('Sending message...');
      final message = await JointTripGroupChatsRepository.sendMessage(
        tripId: tripId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        messageText: messageText,
        messageType: 'text',
      );

      print('✅ Message sent: ${message['messageId']}');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  // Send message with image attachment
  static Future<void> sendImageMessage({
    required int tripId,
    required int senderId,
    required String senderName,
    required String senderAvatar,
    required String imageUrl,
  }) async {
    try {
      print('Sending image message...');
      final message = await JointTripGroupChatsRepository.sendMessage(
        tripId: tripId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        messageText: 'Shared an image',
        messageType: 'image',
        attachmentUrl: imageUrl,
      );

      print('✅ Image message sent: ${message['messageId']}');
    } catch (e) {
      print('❌ Error sending image: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 4: Load Group Chat Screen Data
// ============================================================================
//
// Use this to load initial data for the group chat screen

class ChatScreenDataExample {
  static Future<Map<String, dynamic>> loadChatScreenData({
    required int tripId,
    required int currentUserId,
  }) async {
    try {
      // Load group details
      final groupData = await JointTripGroupRepository.getGroupDetails(tripId);
      if (groupData == null) {
        throw Exception('Group not found');
      }

      final group = JointTripGroup.fromMap(groupData);

      // Check if user is member
      final isMember = await JointTripGroupRepository.isUserInGroup(
        tripId: tripId,
        userId: currentUserId,
      );

      if (!isMember) {
        throw Exception('You are not a member of this group');
      }

      // Load recent messages
      final messagesData = await JointTripGroupChatsRepository.getRecentMessages(
        tripId: tripId,
        limit: 50,
      );

      final messages = messagesData
          .map((m) => ChatMessage.fromMap(m))
          .toList();

      // Get group members
      final membersData = await JointTripGroupRepository.getGroupMembers(tripId);
      final members = membersData
          .map((m) => GroupMember.fromMap(m))
          .toList();

      return {
        'group': group,
        'messages': messages,
        'members': members,
        'isCreator': group.isCreator(currentUserId),
      };
    } catch (e) {
      print('❌ Error loading chat screen data: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 5: Real-time Message Listening
// ============================================================================
//
// Use this to listen to new messages in real-time

class RealtimeMessagingExample {
  // Listen to all messages
  static Stream<List<ChatMessage>> listenToMessages(int tripId) {
    return JointTripGroupChatsRepository.listenToMessages(
      tripId: tripId,
      limit: 50,
    ).map((messagesData) {
      return messagesData
          .map((m) => ChatMessage.fromMap(m))
          .toList();
    });
  }

  // Listen to typing status
  static Stream<List<int>> listenToTypingUsers(int tripId) {
    return JointTripGroupChatsRepository.listenToTypingStatus(tripId)
        .map((typingMap) => typingMap.keys.toList());
  }

  // Set typing status
  static Future<void> setTyping({
    required int tripId,
    required int userId,
    required bool isTyping,
  }) async {
    await JointTripGroupChatsRepository.setTypingStatus(
      tripId: tripId,
      userId: userId,
      isTyping: isTyping,
    );
  }
}

// ============================================================================
// EXAMPLE 6: Group Management Operations
// ============================================================================
//
// Common group management operations

class GroupManagementExample {
  // Update group name (creator only)
  static Future<void> updateGroupName({
    required int tripId,
    required String newName,
  }) async {
    try {
      await JointTripGroupRepository.updateGroupName(
        tripId: tripId,
        newGroupName: newName,
      );
      print('✅ Group name updated to: $newName');
    } catch (e) {
      print('❌ Error updating group name: $e');
      rethrow;
    }
  }

  // Update group profile image (creator only)
  static Future<void> updateGroupProfile({
    required int tripId,
    required String profileUrl,
  }) async {
    try {
      await JointTripGroupRepository.updateGroupProfile(
        tripId: tripId,
        profileUrl: profileUrl,
      );
      print('✅ Group profile updated');
    } catch (e) {
      print('❌ Error updating group profile: $e');
      rethrow;
    }
  }

  // Leave group (members only, not creator)
  static Future<void> leaveGroup({
    required int tripId,
    required int userId,
  }) async {
    try {
      await JointTripGroupRepository.leaveGroup(
        tripId: tripId,
        userId: userId,
      );
      print('✅ Left group successfully');
    } catch (e) {
      print('❌ Error leaving group: $e');
      rethrow;
    }
  }

  // Delete group (creator only)
  static Future<void> deleteGroup({
    required int tripId,
    required int userId,
  }) async {
    try {
      // Delete group
      await JointTripGroupRepository.deleteGroup(
        tripId: tripId,
        userId: userId,
      );

      // Delete all messages
      await JointTripGroupChatsRepository.deleteAllMessages(tripId);

      print('✅ Group and messages deleted successfully');
    } catch (e) {
      print('❌ Error deleting group: $e');
      rethrow;
    }
  }

  // Remove member from group (creator only)
  static Future<void> removeMember({
    required int tripId,
    required int creatorId,
    required int memberIdToRemove,
  }) async {
    try {
      await JointTripGroupRepository.removeMember(
        tripId: tripId,
        creatorId: creatorId,
        memberIdToRemove: memberIdToRemove,
      );
      print('✅ Member removed successfully');
    } catch (e) {
      print('❌ Error removing member: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 7: Load Group Lists
// ============================================================================
//
// Load "My Groups" and "Joined Groups" for the trip groups tab

class GroupListExample {
  // Load groups created by current user
  static Future<List<GroupChatInfo>> loadMyGroups(int userId) async {
    try {
      final groupsData = await JointTripGroupRepository.getCreatedGroups(userId);

      final groupInfoList = <GroupChatInfo>[];

      for (final groupData in groupsData) {
        final group = JointTripGroup.fromMap(groupData);

        // Get last message
        final lastMessageData = await JointTripGroupChatsRepository
            .getLastMessage(group.tripId);

        final lastMessage = lastMessageData != null
            ? LastMessage.fromMap(lastMessageData)
            : null;

        groupInfoList.add(GroupChatInfo(
          group: group,
          lastMessage: lastMessage,
          unreadCount: 0, // Implement unread tracking as needed
        ));
      }

      return groupInfoList;
    } catch (e) {
      print('❌ Error loading my groups: $e');
      rethrow;
    }
  }

  // Load groups user has joined (created by others)
  static Future<List<GroupChatInfo>> loadJoinedGroups(int userId) async {
    try {
      final groupsData = await JointTripGroupRepository.getJoinedGroups(userId);

      final groupInfoList = <GroupChatInfo>[];

      for (final groupData in groupsData) {
        final group = JointTripGroup.fromMap(groupData);

        // Get last message
        final lastMessageData = await JointTripGroupChatsRepository
            .getLastMessage(group.tripId);

        final lastMessage = lastMessageData != null
            ? LastMessage.fromMap(lastMessageData)
            : null;

        groupInfoList.add(GroupChatInfo(
          group: group,
          lastMessage: lastMessage,
          unreadCount: 0, // Implement unread tracking as needed
        ));
      }

      return groupInfoList;
    } catch (e) {
      print('❌ Error loading joined groups: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 8: Delete Trip with Cleanup
// ============================================================================
//
// When deleting a trip, also clean up Firebase group and messages

class TripDeletionExample {
  static Future<void> deleteTripWithCleanup({
    required int tripId,
    required int userId,
  }) async {
    try {
      // Step 1: Delete trip from backend
      print('Deleting trip from backend...');
      await TripRepository.deleteTrip(tripId);
      print('✅ Trip deleted from backend');

      // Step 2: Delete Firebase group
      print('Deleting Firebase group...');
      await JointTripGroupRepository.deleteGroup(
        tripId: tripId,
        userId: userId,
      );
      print('✅ Group deleted');

      // Step 3: Delete all messages
      print('Deleting all messages...');
      await JointTripGroupChatsRepository.deleteAllMessages(tripId);
      print('✅ Messages deleted');

      print('✅ Trip deletion complete with cleanup!');
    } catch (e) {
      print('❌ Error deleting trip: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 9: Search and Filter
// ============================================================================
//
// Search messages and filter groups

class SearchExample {
  // Search messages in a group
  static Future<List<ChatMessage>> searchMessages({
    required int tripId,
    required String query,
  }) async {
    try {
      final messagesData = await JointTripGroupChatsRepository.searchMessages(
        tripId: tripId,
        query: query,
      );

      return messagesData
          .map((m) => ChatMessage.fromMap(m))
          .toList();
    } catch (e) {
      print('❌ Error searching messages: $e');
      rethrow;
    }
  }

  // Get messages in date range
  static Future<List<ChatMessage>> getMessagesByDateRange({
    required int tripId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final messagesData = await JointTripGroupChatsRepository
          .getMessagesByDateRange(
        tripId: tripId,
        startDate: startDate,
        endDate: endDate,
      );

      return messagesData
          .map((m) => ChatMessage.fromMap(m))
          .toList();
    } catch (e) {
      print('❌ Error getting messages by date: $e');
      rethrow;
    }
  }

  // Get messages from specific user
  static Future<List<ChatMessage>> getMessagesByUser({
    required int tripId,
    required int userId,
  }) async {
    try {
      final messagesData = await JointTripGroupChatsRepository
          .getMessagesByUser(
        tripId: tripId,
        userId: userId,
      );

      return messagesData
          .map((m) => ChatMessage.fromMap(m))
          .toList();
    } catch (e) {
      print('❌ Error getting user messages: $e');
      rethrow;
    }
  }
}

// ============================================================================
// USAGE IN YOUR APP
// ============================================================================
//
// Here's how to use these examples in your actual Flutter widgets:

/*

// In create_trip_form.dart:
Future<void> _handleTripSubmission(Map<String, dynamic> formData) async {
  await TripCreationExample.createTripWithGroup(
    tripFormData: formData,
    currentUserId: getCurrentUserId(),
    currentUserName: getCurrentUserName(),
    currentUserAvatar: getCurrentUserAvatar(),
  );
}

// In trip_request_repository.dart:
static Future<Map<String, dynamic>> acceptRequest(int requestId) async {
  // Get trip details from response
  final response = await ApiService.put('/trip-requests/$requestId/accept');
  final tripId = response.data['data']['tripId'];

  await RequestAcceptanceExample.acceptRequestAndJoinGroup(
    requestId: requestId,
    tripId: tripId,
    currentUserId: getCurrentUserId(),
    currentUserName: getCurrentUserName(),
    currentUserAvatar: getCurrentUserAvatar(),
  );
}

// In group_chat_screen.dart:
@override
void initState() {
  super.initState();
  _messagesStream = RealtimeMessagingExample.listenToMessages(widget.tripId);
}

void _sendMessage() {
  MessageSendingExample.sendTextMessage(
    tripId: widget.tripId,
    senderId: getCurrentUserId(),
    senderName: getCurrentUserName(),
    senderAvatar: getCurrentUserAvatar(),
    messageText: _messageController.text,
  );
}

// In trip_groups_tab.dart:
Future<void> _loadGroups() async {
  final myGroups = await GroupListExample.loadMyGroups(getCurrentUserId());
  final joinedGroups = await GroupListExample.loadJoinedGroups(getCurrentUserId());

  setState(() {
    _myGroups = myGroups;
    _joinedGroups = joinedGroups;
  });
}

// In group_details_page.dart:
void _deleteGroup() async {
  await GroupManagementExample.deleteGroup(
    tripId: widget.tripId,
    userId: getCurrentUserId(),
  );
  Navigator.pop(context);
}

*/
