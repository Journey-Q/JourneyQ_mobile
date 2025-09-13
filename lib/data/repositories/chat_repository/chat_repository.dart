import 'dart:async';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'firebase_chat_service.dart';
import 'models/chat_models.dart';

/// Instagram-style Chat Repository
/// Complete chat system with profile management and real-time messaging
class ChatRepository {
  static final ChatRepository _instance = ChatRepository._internal();
  factory ChatRepository() => _instance;
  ChatRepository._internal();

  final FirebaseChatService _firebaseService = FirebaseChatService();
  
  bool _initialized = false;

  /// Initialize the chat repository with user authentication
  Future<void> initialize([AuthProvider? authProvider]) async {
    if (_initialized) {
      print('📱 Chat Repository already initialized');
      return;
    }
    
    try {
      print('🔄 Initializing Instagram-style Chat Repository...');
      
      await _firebaseService.initialize(authProvider);
      _initialized = true;
      
      print('✅ Instagram-style Chat Repository initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Chat Repository: $e');
      throw e;
    }
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('ChatRepository not initialized. Call initialize() first.');
    }
  }

  // INSTAGRAM-LIKE CHAT METHODS

  /// Create or get existing chat between two users
  /// Automatically initializes user profiles if needed
  Future<String> createOrGetChat(String currentUserId, String otherUserId) async {
    _ensureInitialized();
    
    try {
      print('📱 Creating/getting Instagram-style chat between $currentUserId and $otherUserId');
      
      final chatId = await _firebaseService.createOrGetChat(currentUserId, otherUserId);
      
      print('✅ Chat ready: $chatId');
      return chatId;
      
    } catch (e) {
      print('❌ Error creating/getting chat: $e');
      throw e;
    }
  }

  /// Send message with full profile integration
  Future<ChatMessage> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
    String? replyTo,
  }) async {
    _ensureInitialized();
    
    try {
      print('📤 Sending Instagram-style message to chat: $chatId');
      
      final message = await _firebaseService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        content: content,
        messageType: messageType,
        replyTo: replyTo,
      );
      
      print('✅ Instagram-style message sent: ${message.id}');
      return message;
      
    } catch (e) {
      print('❌ Error sending Instagram-style message: $e');
      throw e;
    }
  }

  /// Stream user's chats with full profile information (Instagram-like)
  Stream<List<InstagramChat>> streamUserChats(String userId) {
    _ensureInitialized();
    
    print('🔄 Starting Instagram-style chat stream for user: $userId');
    return _firebaseService.streamUserChats(userId);
  }

  /// Stream messages for a specific chat with user validation
  Stream<List<ChatMessage>> streamChatMessages(String chatId, {String? requestingUserId}) {
    _ensureInitialized();
    
    print('🔄 Starting message stream for chat: $chatId');
    return _firebaseService.streamChatMessages(chatId, requestingUserId: requestingUserId);
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    _ensureInitialized();
    
    try {
      await _firebaseService.markMessagesAsRead(chatId, userId);
      print('✅ Messages marked as read in chat: $chatId');
    } catch (e) {
      print('❌ Error marking messages as read: $e');
      throw e;
    }
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    _ensureInitialized();
    
    try {
      final profile = await _firebaseService.getUserProfile(userId);
      print('👤 Retrieved user profile: ${profile?.displayName ?? 'Unknown'}');
      return profile;
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(String userId, {
    String? displayName,
    String? profileUrl,
    String? username,
  }) async {
    _ensureInitialized();
    
    try {
      await _firebaseService.updateUserProfile(
        userId,
        displayName: displayName,
        profileUrl: profileUrl,
        username: username,
      );
      print('✅ User profile updated for: $userId');
    } catch (e) {
      print('❌ Error updating user profile: $e');
      throw e;
    }
  }

  // ONLINE STATUS AND TYPING

  /// Set user online status
  Future<void> setUserOnlineStatus(String userId, bool isOnline) async {
    _ensureInitialized();
    
    try {
      await _firebaseService.setUserOnlineStatus(userId, isOnline);
      print('👤 User $userId set ${isOnline ? 'online' : 'offline'}');
    } catch (e) {
      print('❌ Error setting online status: $e');
      throw e;
    }
  }

  /// Stream user online status
  Stream<UserStatus> streamUserStatus(String userId) {
    _ensureInitialized();
    return _firebaseService.streamUserStatus(userId);
  }

  /// Set typing status
  Future<void> setTypingStatus(String chatId, String userId, bool isTyping) async {
    _ensureInitialized();
    
    try {
      await _firebaseService.setTypingStatus(chatId, userId, isTyping);
    } catch (e) {
      print('❌ Error setting typing status: $e');
      throw e;
    }
  }

  /// Stream typing status
  Stream<Map<String, bool>> streamTypingStatus(String chatId) {
    _ensureInitialized();
    return _firebaseService.streamTypingStatus(chatId);
  }

  // LEGACY COMPATIBILITY METHODS
  // These methods provide backward compatibility with existing code

  /// Legacy: Send message using MessageRequest
  Future<ChatMessage> sendMessageLegacy(MessageRequest request) async {
    return await sendMessage(
      chatId: await createOrGetChat(request.senderId, request.recipientId),
      senderId: request.senderId,
      content: request.content,
      messageType: request.messageType ?? 'text',
      replyTo: request.replyTo,
    );
  }

  /// Legacy: Get all chats for user (returns converted IndividualChat list)
  Future<List<IndividualChat>> getAllChatsForUser(String userId) async {
    _ensureInitialized();
    
    try {
      final instagramChats = await streamUserChats(userId).first;
      
      // Convert Instagram chats to legacy format
      final legacyChats = instagramChats.map((chat) {
        return IndividualChat(
          chatId: chat.chatId,
          participants: {
            chat.otherUserId: ChatParticipant(
              userId: chat.otherUserId,
              name: chat.otherUserName,
              profileUrl: chat.otherUserProfileUrl,
              isOnline: chat.isOnline,
              lastSeen: chat.lastSeen ?? DateTime.now().millisecondsSinceEpoch,
            ),
          },
          lastMessage: chat.lastMessage,
          lastMessageTime: chat.lastMessageTime,
          unreadCounts: {userId: chat.unreadCount},
          createdAt: chat.createdAt,
        );
      }).toList();
      
      return legacyChats;
      
    } catch (e) {
      print('❌ Error getting legacy chats: $e');
      return [];
    }
  }

  /// Legacy: Stream individual chats (converts Instagram chats to legacy format)
  Stream<List<IndividualChat>> streamUserIndividualChats(String userId) {
    _ensureInitialized();
    
    return streamUserChats(userId).map((instagramChats) {
      return instagramChats.map((chat) {
        return IndividualChat(
          chatId: chat.chatId,
          participants: {
            userId: ChatParticipant(
              userId: userId,
              name: 'You',
              profileUrl: null,
              isOnline: true,
              lastSeen: DateTime.now().millisecondsSinceEpoch,
            ),
            chat.otherUserId: ChatParticipant(
              userId: chat.otherUserId,
              name: chat.otherUserName,
              profileUrl: chat.otherUserProfileUrl,
              isOnline: chat.isOnline,
              lastSeen: chat.lastSeen ?? DateTime.now().millisecondsSinceEpoch,
            ),
          },
          lastMessage: chat.lastMessage,
          lastMessageTime: chat.lastMessageTime,
          unreadCounts: {userId: chat.unreadCount},
          createdAt: chat.createdAt,
        );
      }).toList();
    });
  }

  /// Legacy: Get chat messages between users
  Future<List<ChatMessage>> getChatBetweenUsers(String user1Id, String user2Id) async {
    _ensureInitialized();
    
    try {
      final chatId = await createOrGetChat(user1Id, user2Id);
      return await streamChatMessages(chatId, requestingUserId: user1Id).first;
    } catch (e) {
      print('❌ Error getting chat messages: $e');
      return [];
    }
  }

  /// Legacy: Initialize chat between two users
  Future<String> initializeChat(String user1Id, String user2Id) async {
    return await createOrGetChat(user1Id, user2Id);
  }

  /// Legacy: Check if chat exists
  Future<bool> chatExists(String user1Id, String user2Id) async {
    try {
      final chatId = await createOrGetChat(user1Id, user2Id);
      return chatId.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Legacy: Get chat info
  Future<IndividualChat?> getChatInfo(String chatId) async {
    try {
      // Extract user IDs from chat ID (format: chat_userId1_userId2)
      final parts = chatId.split('_');
      if (parts.length >= 3) {
        final user1Id = parts[1];
        final user2Id = parts[2];
        
        // Get user profiles
        final user1Profile = await getUserProfile(user1Id);
        final user2Profile = await getUserProfile(user2Id);
        
        if (user1Profile != null && user2Profile != null) {
          // Get recent messages
          final messages = await streamChatMessages(chatId, requestingUserId: user1Id).first;
          final lastMessage = messages.isNotEmpty ? messages.last : null;
          
          return IndividualChat(
            chatId: chatId,
            participants: {
              user1Id: ChatParticipant(
                userId: user1Id,
                name: user1Profile.displayName,
                profileUrl: user1Profile.profileUrl,
                isOnline: user1Profile.isOnline,
                lastSeen: user1Profile.lastSeen,
              ),
              user2Id: ChatParticipant(
                userId: user2Id,
                name: user2Profile.displayName,
                profileUrl: user2Profile.profileUrl,
                isOnline: user2Profile.isOnline,
                lastSeen: user2Profile.lastSeen,
              ),
            },
            lastMessage: lastMessage,
            lastMessageTime: lastMessage?.timestamp,
            unreadCounts: {}, // Would need to be calculated
            createdAt: DateTime.now().millisecondsSinceEpoch, // Approximation
          );
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting chat info: $e');
      return null;
    }
  }

  /// Legacy: Update user profile in chats
  Future<void> updateUserProfileInChats(String userId, String newName, String? newProfileUrl) async {
    await updateUserProfile(
      userId,
      displayName: newName,
      profileUrl: newProfileUrl,
    );
  }

  /// Get unread message count for user
  Future<int> getUnreadMessageCount(String userId) async {
    try {
      final chats = await streamUserChats(userId).first;
      return chats.fold<int>(0, (total, chat) => total + chat.unreadCount);
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  // UTILITY METHODS

  /// Create chat ID for two users (consistent ordering)
  String createChatId(String user1Id, String user2Id) {
    final ids = [user1Id, user2Id]..sort();
    return 'chat_${ids[0]}_${ids[1]}';
  }

  /// Get other participant from a participants map
  String getOtherParticipant(Map<String, bool> participants, String currentUserId) {
    return participants.keys.firstWhere(
      (userId) => userId != currentUserId,
      orElse: () => '',
    );
  }

  /// Cancel subscriptions and clean up
  void dispose() {
    print('🗑️ Disposing Chat Repository');
    _firebaseService.dispose();
    _initialized = false;
  }

  // ADMIN AND MAINTENANCE METHODS

  /// Initialize user profile if not exists (useful for migration)
  Future<void> initializeUserProfileIfNeeded(AuthProvider authProvider) async {
    if (authProvider.isAuthenticated && authProvider.user != null) {
      try {
        final userId = authProvider.user!.userId.toString();
        final existingProfile = await getUserProfile(userId);
        
        if (existingProfile == null) {
          print('👤 Initializing missing user profile for: ${authProvider.user!.username}');
          await _firebaseService.initializeUserProfile(authProvider.user!);
          print('✅ User profile created successfully');
        } else {
          print('👤 User profile already exists for: ${authProvider.user!.username}');
        }
      } catch (e) {
        print('❌ Error initializing user profile: $e');
        // Don't throw the error, just log it to prevent blocking chat functionality
      }
    } else {
      print('⚠️ Cannot initialize user profile - user not authenticated');
    }
  }

  /// Force initialize user profile for both users in a chat
  Future<void> ensureBothUserProfilesExist(String user1Id, String user2Id, AuthProvider authProvider, {
    String? otherUserName,
    String? otherUserProfileUrl,
  }) async {
    try {
      print('🔄 Ensuring both user profiles exist: $user1Id, $user2Id');
      
      // Initialize current user profile if needed
      await initializeUserProfileIfNeeded(authProvider);
      
      // Check if other user profile exists
      final otherUserProfile = await getUserProfile(user2Id);
      if (otherUserProfile == null) {
        print('⚠️ Other user profile missing for ID: $user2Id');
        // Create a profile for the other user with provided data
        await _createFallbackUserProfile(user2Id, 
          displayName: otherUserName, 
          profileUrl: otherUserProfileUrl);
      } else {
        print('👤 Other user profile exists: ${otherUserProfile.displayName}');
      }
      
      print('✅ Both user profiles confirmed to exist');
      
    } catch (e) {
      print('❌ Error ensuring user profiles exist: $e');
      // Don't throw - allow chat to continue with fallback handling
    }
  }

  /// Create a fallback user profile for missing users
  Future<void> _createFallbackUserProfile(String userId, {
    String? displayName,
    String? profileUrl,
  }) async {
    try {
      print('🆔 Creating fallback profile for user: $userId with name: ${displayName ?? 'Unknown User'}');
      
      // Use the Firebase service to create the fallback profile with provided data
      await _firebaseService.createFallbackUserProfile(
        userId,
        displayName: displayName,
        profileUrl: profileUrl,
        username: displayName ?? 'User$userId',
      );
      print('✅ Fallback profile created for user: $userId');
      
    } catch (e) {
      print('❌ Error creating fallback profile: $e');
      // Don't throw - this is a last resort fallback
    }
  }

  /// Debug: Get chat structure for a specific chat
  Future<Map<String, dynamic>> debugChatStructure(String chatId) async {
    _ensureInitialized();
    return await _firebaseService.debugChatStructure(chatId);
  }

  /// Get system health status
  Future<Map<String, dynamic>> getHealthStatus() async {
    return {
      'initialized': _initialized,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'status': 'healthy',
    };
  }
}