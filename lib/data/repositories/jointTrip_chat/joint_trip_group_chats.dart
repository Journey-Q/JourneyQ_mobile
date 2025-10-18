import 'package:firebase_database/firebase_database.dart';
import 'package:journeyq/core/config/firebase_config.dart';

/// Repository for managing Joint Trip Group Chat Messages in Firebase Realtime Database
///
/// Database Structure:
/// jointTrip_group_chats/
///   {groupId}/
///     messages/
///       {messageId}/
///         messageId: String (auto-generated push key)
///         senderId: int
///         senderName: String
///         senderAvatar: String
///         messageText: String
///         messageType: String (text/image/location/file)
///         timestamp: int
///         attachmentUrl: String (nullable - for images/files)
///         isDeleted: bool
///         deletedAt: int (nullable)
///     lastMessage/
///       text: String
///       senderId: int
///       senderName: String
///       timestamp: int
///     typing/
///       {userId}: bool
class JointTripGroupChatsRepository {
  static final FirebaseConfig _firebaseConfig = FirebaseConfig.instance;

  /// Get reference to jointTrip_group_chats node
  static DatabaseReference get _chatsRef =>
      _firebaseConfig.getDatabaseReference('jointTrip_group_chats');

  /// Send a text message to group chat
  static Future<Map<String, dynamic>> sendMessage({
    required int tripId,
    required int senderId,
    required String senderName,
    required String senderAvatar,
    required String messageText,
    String messageType = 'text',
    String? attachmentUrl,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      // Create message reference with auto-generated key
      final messageRef = _chatsRef.child(groupId).child('messages').push();
      final String messageId = messageRef.key!;

      final messageData = {
        'messageId': messageId,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatar': senderAvatar,
        'messageText': messageText,
        'messageType': messageType,
        'timestamp': timestamp,
        'attachmentUrl': attachmentUrl,
        'isDeleted': false,
        'deletedAt': null,
      };

      // Write message to Firebase
      await messageRef.set(messageData);

      // Update last message
      await _updateLastMessage(
        groupId: groupId,
        text: messageText,
        senderId: senderId,
        senderName: senderName,
        timestamp: timestamp,
      );

      print('✅ Message sent successfully to group $groupId');
      return messageData;
    } catch (e) {
      print('❌ Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  /// Update last message info for group
  static Future<void> _updateLastMessage({
    required String groupId,
    required String text,
    required int senderId,
    required String senderName,
    required int timestamp,
  }) async {
    try {
      await _chatsRef.child(groupId).child('lastMessage').set({
        'text': text,
        'senderId': senderId,
        'senderName': senderName,
        'timestamp': timestamp,
      });
    } catch (e) {
      print('⚠️ Error updating last message: $e');
      // Don't throw - this is not critical
    }
  }

  /// Get all messages for a group (paginated)
  static Future<List<Map<String, dynamic>>> getMessages({
    required int tripId,
    int limit = 50,
    int? startAfterTimestamp,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      Query query = _chatsRef
          .child(groupId)
          .child('messages')
          .orderByChild('timestamp')
          .limitToLast(limit);

      if (startAfterTimestamp != null) {
        query = query.startAfter(startAfterTimestamp);
      }

      final snapshot = await query.get();

      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No messages found for group $groupId');
        return [];
      }

      final messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final messagesList = messagesMap.values
          .map((message) => Map<String, dynamic>.from(message as Map))
          .where((message) => message['isDeleted'] != true)
          .toList();

      // Sort by timestamp (newest first)
      messagesList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

      print('✅ Retrieved ${messagesList.length} messages for group $groupId');
      return messagesList;
    } catch (e) {
      print('❌ Error getting messages: $e');
      throw Exception('Failed to get messages: $e');
    }
  }

  /// Get recent messages (for chat list preview)
  static Future<List<Map<String, dynamic>>> getRecentMessages({
    required int tripId,
    int limit = 20,
  }) async {
    return getMessages(tripId: tripId, limit: limit);
  }

  /// Delete a message (soft delete)
  static Future<void> deleteMessage({
    required int tripId,
    required String messageId,
    required int userId,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final messageRef = _chatsRef
          .child(groupId)
          .child('messages')
          .child(messageId);

      // Check if user is the sender
      final snapshot = await messageRef.child('senderId').get();
      if (!snapshot.exists) {
        throw Exception('Message not found');
      }

      if (snapshot.value != userId) {
        throw Exception('You can only delete your own messages');
      }

      // Soft delete
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      await messageRef.update({
        'isDeleted': true,
        'deletedAt': timestamp,
        'messageText': 'This message was deleted',
      });

      print('✅ Message deleted successfully');
    } catch (e) {
      print('❌ Error deleting message: $e');
      throw Exception('Failed to delete message: $e');
    }
  }

  /// Get last message for a group
  static Future<Map<String, dynamic>?> getLastMessage(int tripId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _chatsRef.child(groupId).child('lastMessage').get();

      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      return Map<String, dynamic>.from(snapshot.value as Map);
    } catch (e) {
      print('❌ Error getting last message: $e');
      return null;
    }
  }

  /// Listen to messages in real-time
  static Stream<List<Map<String, dynamic>>> listenToMessages({
    required int tripId,
    int limit = 50,
  }) {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      return _chatsRef
          .child(groupId)
          .child('messages')
          .orderByChild('timestamp')
          .limitToLast(limit)
          .onValue
          .map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return <Map<String, dynamic>>[];
        }

        final messagesMap = Map<String, dynamic>.from(event.snapshot.value as Map);
        final messagesList = messagesMap.values
            .map((message) => Map<String, dynamic>.from(message as Map))
            .where((message) => message['isDeleted'] != true)
            .toList();

        // Sort by timestamp (newest first)
        messagesList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

        return messagesList;
      });
    } catch (e) {
      print('❌ Error listening to messages: $e');
      throw Exception('Failed to listen to messages: $e');
    }
  }

  /// Listen to last message in real-time
  static Stream<Map<String, dynamic>?> listenToLastMessage(int tripId) {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      return _chatsRef.child(groupId).child('lastMessage').onValue.map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return null;
        }
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      });
    } catch (e) {
      print('❌ Error listening to last message: $e');
      throw Exception('Failed to listen to last message: $e');
    }
  }

  /// Set user typing status
  static Future<void> setTypingStatus({
    required int tripId,
    required int userId,
    required bool isTyping,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';

      if (isTyping) {
        await _chatsRef
            .child(groupId)
            .child('typing')
            .child(userId.toString())
            .set(true);
      } else {
        await _chatsRef
            .child(groupId)
            .child('typing')
            .child(userId.toString())
            .remove();
      }
    } catch (e) {
      print('⚠️ Error setting typing status: $e');
      // Don't throw - this is not critical
    }
  }

  /// Listen to typing status
  static Stream<Map<int, bool>> listenToTypingStatus(int tripId) {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      return _chatsRef.child(groupId).child('typing').onValue.map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return <int, bool>{};
        }

        final typingMap = Map<String, dynamic>.from(event.snapshot.value as Map);
        final result = <int, bool>{};

        typingMap.forEach((key, value) {
          final userId = int.tryParse(key);
          if (userId != null && value == true) {
            result[userId] = true;
          }
        });

        return result;
      });
    } catch (e) {
      print('❌ Error listening to typing status: $e');
      return Stream.value(<int, bool>{});
    }
  }

  /// Get message count for a group
  static Future<int> getMessageCount(int tripId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _chatsRef.child(groupId).child('messages').get();

      if (!snapshot.exists || snapshot.value == null) {
        return 0;
      }

      final messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
      // Count only non-deleted messages
      final count = messagesMap.values
          .where((message) => (message as Map)['isDeleted'] != true)
          .length;

      return count;
    } catch (e) {
      print('❌ Error getting message count: $e');
      return 0;
    }
  }

  /// Search messages in a group
  static Future<List<Map<String, dynamic>>> searchMessages({
    required int tripId,
    required String query,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _chatsRef.child(groupId).child('messages').get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final messagesList = messagesMap.values
          .map((message) => Map<String, dynamic>.from(message as Map))
          .where((message) =>
              message['isDeleted'] != true &&
              message['messageText']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      // Sort by timestamp (newest first)
      messagesList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

      print('✅ Found ${messagesList.length} messages matching "$query"');
      return messagesList;
    } catch (e) {
      print('❌ Error searching messages: $e');
      throw Exception('Failed to search messages: $e');
    }
  }

  /// Delete all messages in a group (when group is deleted)
  static Future<void> deleteAllMessages(int tripId) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      await _chatsRef.child(groupId).remove();

      print('✅ All messages deleted for group $groupId');
    } catch (e) {
      print('❌ Error deleting all messages: $e');
      throw Exception('Failed to delete all messages: $e');
    }
  }

  /// Get messages by date range
  static Future<List<Map<String, dynamic>>> getMessagesByDateRange({
    required int tripId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final startTimestamp = startDate.millisecondsSinceEpoch;
      final endTimestamp = endDate.millisecondsSinceEpoch;

      final snapshot = await _chatsRef
          .child(groupId)
          .child('messages')
          .orderByChild('timestamp')
          .startAt(startTimestamp)
          .endAt(endTimestamp)
          .get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final messagesList = messagesMap.values
          .map((message) => Map<String, dynamic>.from(message as Map))
          .where((message) => message['isDeleted'] != true)
          .toList();

      // Sort by timestamp (newest first)
      messagesList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

      print('✅ Retrieved ${messagesList.length} messages for date range');
      return messagesList;
    } catch (e) {
      print('❌ Error getting messages by date range: $e');
      throw Exception('Failed to get messages by date range: $e');
    }
  }

  /// Get messages from a specific user in group
  static Future<List<Map<String, dynamic>>> getMessagesByUser({
    required int tripId,
    required int userId,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _chatsRef
          .child(groupId)
          .child('messages')
          .orderByChild('senderId')
          .equalTo(userId)
          .get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final messagesList = messagesMap.values
          .map((message) => Map<String, dynamic>.from(message as Map))
          .where((message) => message['isDeleted'] != true)
          .toList();

      // Sort by timestamp (newest first)
      messagesList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

      print('✅ Retrieved ${messagesList.length} messages from user $userId');
      return messagesList;
    } catch (e) {
      print('❌ Error getting messages by user: $e');
      throw Exception('Failed to get messages by user: $e');
    }
  }

  /// Listen to new messages only (since last check)
  static Stream<Map<String, dynamic>> listenToNewMessages({
    required int tripId,
    required int sinceTimestamp,
  }) {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      return _chatsRef
          .child(groupId)
          .child('messages')
          .orderByChild('timestamp')
          .startAfter(sinceTimestamp)
          .onChildAdded
          .map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return <String, dynamic>{};
        }
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      });
    } catch (e) {
      print('❌ Error listening to new messages: $e');
      throw Exception('Failed to listen to new messages: $e');
    }
  }

  /// Get unread message count (messages after a specific timestamp)
  static Future<int> getUnreadMessageCount({
    required int tripId,
    required int lastReadTimestamp,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_firebaseConfig.isInitialized) {
        await _firebaseConfig.initialize();
      }

      final String groupId = 'trip_$tripId';
      final snapshot = await _chatsRef
          .child(groupId)
          .child('messages')
          .orderByChild('timestamp')
          .startAfter(lastReadTimestamp)
          .get();

      if (!snapshot.exists || snapshot.value == null) {
        return 0;
      }

      final messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final count = messagesMap.values
          .where((message) => (message as Map)['isDeleted'] != true)
          .length;

      return count;
    } catch (e) {
      print('❌ Error getting unread message count: $e');
      return 0;
    }
  }
}
