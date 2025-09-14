import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/chat_repository/chat_repository.dart';
import 'package:journeyq/data/repositories/chat_repository/models/chat_models.dart';
import 'dart:async';

/// Instagram-style Chat Index Page
/// Shows all chats with proper profile information and real-time updates
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  // Instagram-style chat list
  List<InstagramChat> _instagramChats = [];
  Map<String, UserStatus> _userStatuses = {};
  
  bool _isLoading = true;
  bool _hasError = false;
  String? _currentUserId;
  
  // Subscriptions
  StreamSubscription<List<InstagramChat>>? _chatsSubscription;
  final Map<String, StreamSubscription<UserStatus>> _statusSubscriptions = {};
  
  final ChatRepository _chatRepository = ChatRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeChatSystem();
  }

  @override
  void dispose() {
    print('🗑️ Disposing Instagram-style Chat Index Page');
    
    // Cancel all subscriptions
    _chatsSubscription?.cancel();
    _statusSubscriptions.values.forEach((sub) => sub.cancel());
    
    // Set user offline
    if (_currentUserId != null) {
      _chatRepository.setUserOnlineStatus(_currentUserId!, false);
    }
    
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (_currentUserId != null) {
      switch (state) {
        case AppLifecycleState.resumed:
          _chatRepository.setUserOnlineStatus(_currentUserId!, true);
          break;
        case AppLifecycleState.paused:
        case AppLifecycleState.inactive:
        case AppLifecycleState.detached:
          _chatRepository.setUserOnlineStatus(_currentUserId!, false);
          break;
        case AppLifecycleState.hidden:
          break;
      }
    }
  }

  // Simplified chat system initialization - no user profile dependencies
  Future<void> _initializeChatSystem() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print('📱 Initializing SIMPLIFIED chat system...');

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _currentUserId = authProvider.user?.userId?.toString();

      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      print('🔍 Current user ID: $_currentUserId');

      // Initialize chat repository - minimal setup
      await _chatRepository.initialize(authProvider);

      // Set user online status (optional)
      try {
        await _chatRepository.setUserOnlineStatus(_currentUserId!, true);
        print('✅ User online status set');
      } catch (e) {
        print('⚠️ Could not set online status: $e (continuing anyway)');
      }

      // Start listening to chats directly from chats table
      _startListeningToInstagramChats();

      setState(() {
        _isLoading = false;
      });

      print('✅ SIMPLIFIED chat system initialized successfully');

    } catch (e) {
      print('❌ Error initializing SIMPLIFIED chat system: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  
  void _startListeningToInstagramChats() {
    if (_currentUserId == null) {
      print('❌ Cannot start chat stream - current user ID is null');
      return;
    }

    print('🔄 Starting DIRECT chat stream for user: $_currentUserId');
    print('🔄 This will scan all chats for participant matches');

    // Listen to chats directly from chats table
    _chatsSubscription = _chatRepository
        .streamUserChats(_currentUserId!)
        .listen(
      (chats) {
        print('📱 DIRECT QUERY RESULT: ${chats.length} chats found for user: $_currentUserId');

        for (final chat in chats) {
          print('   ✅ ${chat.chatId}: ${chat.otherUserName} (unread: ${chat.unreadCount})');
        }

        if (mounted) {
          setState(() {
            _instagramChats = chats;
          });

          // Subscribe to user status updates for online indicators
          _subscribeToUserStatuses(chats);
        }
      },
      onError: (error) {
        print('❌ Error in DIRECT chat stream: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      },
    );
  }
  
  void _subscribeToUserStatuses(List<InstagramChat> chats) {
    // Clean up existing subscriptions
    _statusSubscriptions.values.forEach((sub) => sub.cancel());
    _statusSubscriptions.clear();
    
    for (final chat in chats) {
      final otherUserId = chat.otherUserId;
      
      if (otherUserId.isNotEmpty) {
        // Subscribe to user online status
        _statusSubscriptions[otherUserId] = _chatRepository
            .streamUserStatus(otherUserId)
            .listen((status) {
          if (mounted) {
            setState(() {
              _userStatuses[otherUserId] = status;
              
              // Update chat with online status
              final chatIndex = _instagramChats.indexWhere((c) => c.otherUserId == otherUserId);
              if (chatIndex != -1) {
                _instagramChats[chatIndex] = _instagramChats[chatIndex].copyWith(
                  isOnline: status.isOnline,
                  lastSeen: status.lastSeen,
                );
              }
            });
          }
        });
      }
    }
  }

  // Counter methods
  int _getTotalUnreadCount() {
    return _instagramChats
        .map((chat) => chat.unreadCount)
        .fold(0, (sum, count) => sum + count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildInstagramAppBar(),
      body: _buildInstagramChatList(),
    );
  }

  // Instagram-style App Bar
  PreferredSizeWidget _buildInstagramAppBar() {
    final totalUnread = _getTotalUnreadCount();
    
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Text(
            _currentUserId != null 
                ? Provider.of<AuthProvider>(context, listen: false).user?.username ?? 'Messages'
                : 'Messages',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (totalUnread > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                totalUnread > 99 ? '99+' : '$totalUnread',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey[200],
        ),
      ),
    );
  }

  // Instagram-style Chat List
  Widget _buildInstagramChatList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.black),
            SizedBox(height: 16),
            Text(
              'Loading chats...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load chats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please try again',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeChatSystem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_instagramChats.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _instagramChats.length,
        itemBuilder: (context, index) {
          final chat = _instagramChats[index];
          return _buildInstagramChatItem(chat);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No conversations found.\nMessages will appear here when you have chats.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'The system is scanning for chats where you are a participant.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          // Debug button for testing (remove in production)
          if (_currentUserId != null) ...[
            ElevatedButton(
              onPressed: _createTestChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Test Chat'),
            ),
            const SizedBox(height: 8),
            Text(
              'Debug: Create a test chat to verify the system works',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Simplified test chat creation that works directly with chats table
  Future<void> _createTestChat() async {
    if (_currentUserId == null) return;

    try {
      print('🧪 Creating SIMPLIFIED test chat...');

      // Create a unique test user ID
      final testOtherUserId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
      const testUserName = 'Test User';

      print('🧪 Test other user ID: $testOtherUserId');

      // Create chat directly - this will automatically create the participant entries
      final chatId = await _chatRepository.createOrGetChat(_currentUserId!, testOtherUserId);
      print('🧪 Chat created: $chatId');

      // Send a test message FROM the test user TO current user
      await _chatRepository.sendMessage(
        chatId: chatId,
        senderId: testOtherUserId,
        content: 'Hello! This is a test message.',
      );

      // Send a reply FROM current user
      await _chatRepository.sendMessage(
        chatId: chatId,
        senderId: _currentUserId!,
        content: 'Test reply message.',
      );

      print('✅ SIMPLIFIED test chat created successfully');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test chat created! Check your chat list.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

    } catch (e) {
      print('❌ Error creating SIMPLIFIED test chat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Instagram-style Chat Item
  Widget _buildInstagramChatItem(InstagramChat chat) {
    final userStatus = _userStatuses[chat.otherUserId];
    final isOnline = userStatus?.isOnline ?? chat.isOnline;
    final lastSeen = userStatus?.lastSeen ?? chat.lastSeen;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openInstagramChat(chat),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Instagram-style Profile Picture with Online Indicator
                _buildInstagramAvatar(chat, isOnline),
                
                const SizedBox(width: 16),
                
                // Chat Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.otherUserName,
                              style: TextStyle(
                                fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.lastMessageTime != null)
                            Text(
                              _formatInstagramTime(chat.lastMessageTime!),
                              style: TextStyle(
                                color: chat.unreadCount > 0 ? Colors.black : Colors.grey[500],
                                fontSize: 12,
                                fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Last Message and Unread Badge
                      Row(
                        children: [
                          Expanded(
                            child: _buildLastMessageText(chat),
                          ),
                          if (chat.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  chat.unreadCount > 9 ? '9+' : '${chat.unreadCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ] else if (isOnline) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstagramAvatar(InstagramChat chat, bool isOnline) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 0.5,
            ),
          ),
          child: ClipOval(
            child: chat.otherUserProfileUrl != null
                ? Image.network(
                    chat.otherUserProfileUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ Chat list profile image failed: ${chat.otherUserProfileUrl}');
                      return _buildDefaultAvatar(chat.otherUserName);
                    },
                  )
                : _buildDefaultAvatar(chat.otherUserName),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase();
    
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLastMessageText(InstagramChat chat) {
    if (chat.lastMessage == null) {
      return Text(
        'Tap to start chatting',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 13,
        ),
      );
    }
    
    final message = chat.lastMessage!;
    final isMyMessage = message.senderId == _currentUserId;
    final content = message.content;
    
    return Text(
      isMyMessage ? 'You: $content' : content,
      style: TextStyle(
        color: chat.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
        fontSize: 13,
        fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Event Handlers
  void _openInstagramChat(InstagramChat chat) async {
    print('📱 Opening Instagram-style chat: ${chat.chatId}');

    // Mark messages as read when opening chat
    if (_currentUserId != null) {
      try {
        await _chatRepository.markMessagesAsRead(chat.chatId, _currentUserId!);
        print('✅ Messages marked as read for chat: ${chat.chatId}');
      } catch (e) {
        print('❌ Error marking messages as read: $e');
      }
    }

    // Navigate to individual chat page
    if (mounted) {
      context.push(
        '/chat/individual',
        extra: {
          'chatId': chat.chatId,
          'otherUserId': chat.otherUserId,
          'currentUserId': _currentUserId,
          'otherUserName': chat.otherUserName,
          'otherUserProfileUrl': chat.otherUserProfileUrl,
        },
      );
    }
  }

  Future<void> _handleRefresh() async {
    print('🔄 Refreshing Instagram-style chats...');
    await _initializeChatSystem();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chats refreshed'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  // Helper Methods
  String _formatInstagramTime(int timestamp) {
    final now = DateTime.now();
    final messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(messageTime);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }
}