import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:journeyq/core/config/firebase_config.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'models/chat_models.dart';

/// Instagram-like Firebase Chat Service
/// Handles real-time messaging with complete profile management
class FirebaseChatService {
  static final FirebaseChatService _instance = FirebaseChatService._internal();
  factory FirebaseChatService() => _instance;
  FirebaseChatService._internal();

  FirebaseDatabase? _database;
  DatabaseReference? _chatsRef;
  DatabaseReference? _usersRef;
  DatabaseReference? _messagesRef;
  DatabaseReference? _typingRef;
  DatabaseReference? _userStatusRef;

  final Map<String, StreamSubscription> _subscriptions = {};
  
  bool _initialized = false;
  AuthProvider? _authProvider;

  // Initialize with proper profile support
  Future<void> initialize([AuthProvider? authProvider]) async {
    if (_initialized) {
      print('🔥 Firebase Chat Service already initialized');
      return;
    }

    try {
      print('🔄 Initializing Instagram-like Chat Service...');
      
      _authProvider = authProvider;
      
      // Initialize Firebase
      await FirebaseConfig.instance.initialize();
      _database = FirebaseConfig.instance.database;
      
      // Set up database references
      _chatsRef = _database!.ref('chats');
      _usersRef = _database!.ref('users');
      _messagesRef = _database!.ref('messages');
      _typingRef = _database!.ref('typing');
      _userStatusRef = _database!.ref('user_status');
      
      // Initialize current user profile if authenticated
      if (_authProvider?.isAuthenticated == true && _authProvider?.user != null) {
        await initializeUserProfile(_authProvider!.user!);
      }
      
      _initialized = true;
      print('✅ Instagram-like Chat Service initialized successfully');
      
    } catch (e) {
      print('❌ Failed to initialize Chat Service: $e');
      throw e;
    }
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('FirebaseChatService not initialized. Call initialize() first.');
    }
  }

  // Initialize user profile in Firebase
  Future<void> initializeUserProfile(dynamic user) async {
    try {
      print('👤 Initializing user profile: ${user.username}');
      
      final userId = user.userId.toString();
      final userProfile = {
        'userId': userId,
        'username': user.username,
        'displayName': user.username, // Use username as display name
        'profileUrl': user.profileUrl,
        'email': user.email,
        'isOnline': true,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _usersRef!.child(userId).set(userProfile);
      print('✅ User profile initialized: ${user.username}');
      
    } catch (e) {
      print('❌ Error initializing user profile: $e');
      throw e;
    }
  }

  // Create fallback user profile for missing users
  Future<void> createFallbackUserProfile(String userId, {
    String? displayName,
    String? profileUrl,
    String? username,
  }) async {
    _ensureInitialized();
    
    try {
      print('🆔 Creating fallback profile for user: $userId');
      
      final fallbackProfile = {
        'userId': userId,
        'username': username ?? 'User$userId',
        'displayName': displayName ?? 'Unknown User',
        'profileUrl': profileUrl,
        'email': 'user$userId@journeyq.app',
        'isOnline': false,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _usersRef!.child(userId).set(fallbackProfile);
      print('✅ Fallback profile created for user: $userId with name: ${displayName ?? 'Unknown User'}');
      
    } catch (e) {
      print('❌ Error creating fallback profile: $e');
      throw e;
    }
  }

  // Get user profile by ID
  Future<UserProfile?> getUserProfile(String userId) async {
    _ensureInitialized();
    
    try {
      final snapshot = await _usersRef!.child(userId).get();
      if (snapshot.exists) {
        return UserProfile.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, {
    String? displayName,
    String? profileUrl,
    String? username,
  }) async {
    _ensureInitialized();
    
    try {
      final updates = <String, dynamic>{
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      if (displayName != null) updates['displayName'] = displayName;
      if (profileUrl != null) updates['profileUrl'] = profileUrl;
      if (username != null) updates['username'] = username;
      
      await _usersRef!.child(userId).update(updates);
      
      print('✅ User profile updated for: $userId');
      
    } catch (e) {
      print('❌ Error updating user profile: $e');
      throw e;
    }
  }

  // Create or get chat between two users
  Future<String> createOrGetChat(String user1Id, String user2Id) async {
    _ensureInitialized();
    
    try {
      // Create consistent chat ID
      final chatId = _generateChatId(user1Id, user2Id);
      
      print('🔍 Checking/creating chat: $chatId');
      
      // Check if chat already exists
      final chatSnapshot = await _chatsRef!.child(chatId).get();
      
      if (!chatSnapshot.exists) {
        print('🆕 Creating new chat between $user1Id and $user2Id');
        
        // Get both user profiles
        final user1Profile = await getUserProfile(user1Id);
        final user2Profile = await getUserProfile(user2Id);
        
        if (user1Profile == null || user2Profile == null) {
          throw Exception('User profiles not found. Please ensure both users are registered.');
        }
        
        // Create chat with full profile information
        final chatData = {
          'chatId': chatId,
          'participants': {
            user1Id: user1Profile.toParticipantJson(),
            user2Id: user2Profile.toParticipantJson(),
          },
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'lastMessage': null,
          'lastMessageTime': null,
          'unreadCounts': {
            user1Id: 0,
            user2Id: 0,
          },
          'isActive': true,
          'chatType': 'individual',
        };
        
        await _chatsRef!.child(chatId).set(chatData);
        
        // Add to both users' chat lists
        await Future.wait([
          _usersRef!.child(user1Id).child('chats').child(chatId).set({
            'chatId': chatId,
            'otherUserId': user2Id,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }),
          _usersRef!.child(user2Id).child('chats').child(chatId).set({
            'chatId': chatId,
            'otherUserId': user1Id,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }),
        ]);
        
        print('✅ Chat created successfully: $chatId');
      }
      
      return chatId;
      
    } catch (e) {
      print('❌ Error creating/getting chat: $e');
      throw e;
    }
  }

  // Validate that user is participant in chat
  Future<bool> validateChatParticipant(String chatId, String userId) async {
    _ensureInitialized();
    
    try {
      final chatSnapshot = await _chatsRef!.child(chatId).get();
      if (!chatSnapshot.exists) {
        print('❌ Chat does not exist: $chatId');
        return false;
      }
      
      final chatData = Map<String, dynamic>.from(chatSnapshot.value as Map);
      final participants = Map<String, dynamic>.from(chatData['participants'] ?? {});
      
      final isParticipant = participants.containsKey(userId);
      if (!isParticipant) {
        print('❌ User $userId is not a participant in chat $chatId');
      }
      
      return isParticipant;
      
    } catch (e) {
      print('❌ Error validating chat participant: $e');
      return false;
    }
  }

  // Send message with full profile support and participant validation
  Future<ChatMessage> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
    String? replyTo,
  }) async {
    _ensureInitialized();
    
    try {
      print('📤 Sending message to chat: $chatId');
      
      // Validate sender is a participant in this chat
      if (!await validateChatParticipant(chatId, senderId)) {
        throw Exception('User $senderId is not authorized to send messages in chat $chatId');
      }
      
      // Get sender profile
      final senderProfile = await getUserProfile(senderId);
      if (senderProfile == null) {
        throw Exception('Sender profile not found');
      }
      
      // Create message
      final messageRef = _messagesRef!.child(chatId).push();
      final messageId = messageRef.key!;
      
      final message = ChatMessage(
        id: messageId,
        senderId: senderId,
        senderName: senderProfile.displayName,
        senderProfileUrl: senderProfile.profileUrl,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        messageType: messageType,
        replyTo: replyTo,
        delivered: true,
      );
      
      // Save message
      await messageRef.set(message.toJson());
      
      // Update chat metadata
      await _chatsRef!.child(chatId).update({
        'lastMessage': message.toJson(),
        'lastMessageTime': message.timestamp,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      
      // Get chat participants to update unread counts
      final chatSnapshot = await _chatsRef!.child(chatId).get();
      if (chatSnapshot.exists) {
        final chatData = Map<String, dynamic>.from(chatSnapshot.value as Map);
        final participants = Map<String, dynamic>.from(chatData['participants'] ?? {});
        
        // Update unread counts for all participants except sender
        for (final participantId in participants.keys) {
          if (participantId != senderId) {
            final currentUnread = chatData['unreadCounts']?[participantId] ?? 0;
            await _chatsRef!.child(chatId).child('unreadCounts').child(participantId).set(currentUnread + 1);
          }
        }
      }
      
      print('✅ Message sent successfully: $messageId');
      return message;
      
    } catch (e) {
      print('❌ Error sending message: $e');
      throw e;
    }
  }

  // Stream user's chats with full profile information
  Stream<List<InstagramChat>> streamUserChats(String userId) {
    _ensureInitialized();
    
    print('🔄 Starting chat stream for user: $userId');
    
    return _usersRef!.child(userId).child('chats').onValue.asyncMap((event) async {
      try {
        if (!event.snapshot.exists) {
          print('📭 No chats found for user: $userId');
          return <InstagramChat>[];
        }
        
        final chatRefs = Map<String, dynamic>.from(event.snapshot.value as Map);
        final chats = <InstagramChat>[];
        
        // Get detailed info for each chat
        for (final entry in chatRefs.entries) {
          final chatId = entry.value['chatId'] ?? entry.key;
          
          try {
            final chatSnapshot = await _chatsRef!.child(chatId).get();
            if (chatSnapshot.exists) {
              final chatData = Map<String, dynamic>.from(chatSnapshot.value as Map);
              
              // Get other participant info
              final participants = Map<String, dynamic>.from(chatData['participants'] ?? {});
              final otherUserId = participants.keys.firstWhere((id) => id != userId, orElse: () => '');
              
              if (otherUserId.isNotEmpty) {
                final otherUser = participants[otherUserId];
                
                final chat = InstagramChat(
                  chatId: chatId,
                  otherUserId: otherUserId,
                  otherUserName: otherUser['displayName'] ?? otherUser['username'] ?? 'Unknown User',
                  otherUserProfileUrl: otherUser['profileUrl'],
                  lastMessage: chatData['lastMessage'] != null ? ChatMessage.fromJson(chatData['lastMessage']) : null,
                  lastMessageTime: chatData['lastMessageTime'],
                  unreadCount: chatData['unreadCounts']?[userId] ?? 0,
                  isOnline: false, // Will be updated by status stream
                  lastSeen: otherUser['lastSeen'],
                  createdAt: chatData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
                );
                
                chats.add(chat);
              }
            }
          } catch (e) {
            print('❌ Error loading chat $chatId: $e');
          }
        }
        
        // Sort by last message time
        chats.sort((a, b) => (b.lastMessageTime ?? 0).compareTo(a.lastMessageTime ?? 0));
        
        print('✅ Loaded ${chats.length} chats for user: $userId');
        return chats;
        
      } catch (e) {
        print('❌ Error in chat stream: $e');
        return <InstagramChat>[];
      }
    });
  }

  // Stream messages for a specific chat with participant validation
  Stream<List<ChatMessage>> streamChatMessages(String chatId, {String? requestingUserId}) async* {
    _ensureInitialized();
    
    print('🔄 Starting message stream for chat: $chatId');
    
    // First validate that the chat exists and get participant info
    try {
      final chatSnapshot = await _chatsRef!.child(chatId).get();
      if (!chatSnapshot.exists) {
        print('❌ Chat does not exist: $chatId');
        yield <ChatMessage>[];
        return;
      }
      
      final chatData = Map<String, dynamic>.from(chatSnapshot.value as Map);
      final participants = Map<String, dynamic>.from(chatData['participants'] ?? {});
      
      // Validate requesting user is a participant (if provided)
      if (requestingUserId != null && !participants.containsKey(requestingUserId)) {
        print('❌ User $requestingUserId is not authorized to view messages in chat $chatId');
        yield <ChatMessage>[];
        return;
      }
      
      print('👥 Chat participants: ${participants.keys.join(', ')}');
      print('✅ Message access authorized for chat: $chatId');
      
      // Now stream messages for this specific chat
      yield* _messagesRef!.child(chatId).orderByChild('timestamp').onValue.map((event) {
      try {
        if (!event.snapshot.exists) {
          print('📭 No messages found for chat: $chatId');
          return <ChatMessage>[];
        }
        
        final messagesMap = Map<String, dynamic>.from(event.snapshot.value as Map);
        final messages = <ChatMessage>[];
        
        messagesMap.forEach((messageId, messageData) {
          try {
            if (messageData['deleted'] != true) {
              final message = ChatMessage.fromJson({
                'id': messageId,
                ...Map<String, dynamic>.from(messageData)
              });
              messages.add(message);
            }
          } catch (e) {
            print('❌ Error parsing message $messageId: $e');
          }
        });
        
        // Sort by timestamp
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        
        print('📨 Loaded ${messages.length} messages for chat: $chatId');
        return messages;
        
      } catch (e) {
        print('❌ Error in message stream: $e');
        return <ChatMessage>[];
      }
    });
    
    } catch (e) {
      print('❌ Error setting up message stream: $e');
      yield <ChatMessage>[];
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    _ensureInitialized();
    
    try {
      print('👁️ Marking messages as read for user $userId in chat $chatId');
      
      // Reset unread count
      await _chatsRef!.child(chatId).child('unreadCounts').child(userId).set(0);
      
      // Update read status for recent messages
      final messagesSnapshot = await _messagesRef!.child(chatId).limitToLast(50).get();
      if (messagesSnapshot.exists) {
        final messages = Map<String, dynamic>.from(messagesSnapshot.value as Map);
        final updates = <String, dynamic>{};
        
        messages.forEach((messageId, messageData) {
          if (messageData['senderId'] != userId) {
            updates['$messageId/readBy/$userId'] = true;
            updates['$messageId/readAt'] = DateTime.now().millisecondsSinceEpoch;
          }
        });
        
        if (updates.isNotEmpty) {
          await _messagesRef!.child(chatId).update(updates);
        }
      }
      
      print('✅ Messages marked as read');
      
    } catch (e) {
      print('❌ Error marking messages as read: $e');
      throw e;
    }
  }

  // Set user online status
  Future<void> setUserOnlineStatus(String userId, bool isOnline) async {
    _ensureInitialized();
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await Future.wait([
        // Update in user_status
        _userStatusRef!.child(userId).set({
          'isOnline': isOnline,
          'lastSeen': timestamp,
          'updatedAt': timestamp,
        }),
        // Update in users profile
        _usersRef!.child(userId).update({
          'isOnline': isOnline,
          'lastSeen': timestamp,
          'updatedAt': timestamp,
        }),
      ]);
      
      // Set disconnect handler
      if (isOnline) {
        _userStatusRef!.child(userId).onDisconnect().update({
          'isOnline': false,
          'lastSeen': timestamp,
        });
        _usersRef!.child(userId).onDisconnect().update({
          'isOnline': false,
          'lastSeen': timestamp,
        });
      }
      
    } catch (e) {
      print('❌ Error setting online status: $e');
      throw e;
    }
  }

  // Stream user online status
  Stream<UserStatus> streamUserStatus(String userId) {
    _ensureInitialized();
    
    return _userStatusRef!.child(userId).onValue.map((event) {
      try {
        if (!event.snapshot.exists) {
          return UserStatus(
            userId: userId,
            isOnline: false,
            lastSeen: DateTime.now().millisecondsSinceEpoch,
          );
        }
        
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return UserStatus.fromJson({
          'userId': userId,
          ...data,
        });
        
      } catch (e) {
        print('❌ Error in user status stream: $e');
        return UserStatus(
          userId: userId,
          isOnline: false,
          lastSeen: DateTime.now().millisecondsSinceEpoch,
        );
      }
    });
  }

  // Set typing status
  Future<void> setTypingStatus(String chatId, String userId, bool isTyping) async {
    _ensureInitialized();
    
    try {
      if (isTyping) {
        await _typingRef!.child(chatId).child(userId).set({
          'isTyping': true,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        await _typingRef!.child(chatId).child(userId).remove();
      }
    } catch (e) {
      print('❌ Error setting typing status: $e');
      throw e;
    }
  }

  // Stream typing status
  Stream<Map<String, bool>> streamTypingStatus(String chatId) {
    _ensureInitialized();
    
    return _typingRef!.child(chatId).onValue.map((event) {
      try {
        if (!event.snapshot.exists) return <String, bool>{};
        
        final typingData = Map<String, dynamic>.from(event.snapshot.value as Map);
        final result = <String, bool>{};
        final now = DateTime.now().millisecondsSinceEpoch;
        
        typingData.forEach((userId, data) {
          final typingInfo = Map<String, dynamic>.from(data);
          final timestamp = typingInfo['timestamp'] ?? 0;
          final isRecent = now - timestamp < 5000; // 5 second timeout
          
          if (typingInfo['isTyping'] == true && isRecent) {
            result[userId] = true;
          }
        });
        
        return result;
        
      } catch (e) {
        print('❌ Error in typing stream: $e');
        return <String, bool>{};
      }
    });
  }

  // Helper methods
  String _generateChatId(String user1Id, String user2Id) {
    final ids = [user1Id, user2Id]..sort();
    return 'chat_${ids[0]}_${ids[1]}';
  }

  // Debug: Get chat and message references for debugging
  Future<Map<String, dynamic>> debugChatStructure(String chatId) async {
    _ensureInitialized();
    
    try {
      print('🔍 Firebase Debug: Analyzing chat structure for $chatId');
      
      final chatInfo = await _chatsRef!.child(chatId).get();
      final messagesInfo = await _messagesRef!.child(chatId).get();
      
      final result = {
        'chatId': chatId,
        'chatExists': chatInfo.exists,
        'chatData': chatInfo.exists ? chatInfo.value : null,
        'messagesExist': messagesInfo.exists,
        'messageCount': messagesInfo.exists ? (messagesInfo.value as Map).length : 0,
        'databasePath': {
          'chat': 'chats/$chatId',
          'messages': 'messages/$chatId',
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      print('📋 Firebase structure: $result');
      return result;
      
    } catch (e) {
      print('❌ Error debugging Firebase structure: $e');
      return {
        'chatId': chatId,
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }

  // Clean up
  void dispose() {
    print('🗑️ Disposing Firebase Chat Service');
    _subscriptions.values.forEach((sub) => sub.cancel());
    _subscriptions.clear();
    _initialized = false;
  }
}