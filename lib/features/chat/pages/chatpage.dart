import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/chat_repository/chat_repository.dart';
import 'package:journeyq/data/repositories/chat_repository/models/chat_models.dart';
import 'dart:async';

/// Instagram-style Individual Chat Page
/// Fully functional real-time messaging with profile integration
class IndividualChatPage extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String? otherUserName;
  final String? otherUserProfileUrl;

  const IndividualChatPage({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    this.otherUserName,
    this.otherUserProfileUrl,
  });

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> with WidgetsBindingObserver {
  // Instagram-style messaging
  List<ChatMessage> _messages = [];
  UserStatus? _otherUserStatus;
  Map<String, bool> _typingStatuses = {};
  
  bool _isLoading = true;
  bool _hasError = false;
  bool _isCurrentUserTyping = false;
  
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Subscriptions
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;
  StreamSubscription<UserStatus>? _userStatusSubscription;
  StreamSubscription<Map<String, bool>>? _typingSubscription;
  
  // Typing timer
  Timer? _typingTimer;
  
  final ChatRepository _chatRepository = ChatRepository();

  // User profile information
  String? _otherUserActualName;
  String? _otherUserActualProfileUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeInstagramChat();
  }

  @override
  void dispose() {
    print('🗑️ Disposing Instagram-style Individual Chat Page');
    
    _messagesSubscription?.cancel();
    _userStatusSubscription?.cancel();
    _typingSubscription?.cancel();
    _typingTimer?.cancel();
    
    // Stop typing if currently typing
    if (_isCurrentUserTyping) {
      _setTypingStatus(false);
    }
    
    _messageController.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        _chatRepository.setUserOnlineStatus(widget.currentUserId, true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _chatRepository.setUserOnlineStatus(widget.currentUserId, false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  // Instagram-style initialization
  Future<void> _initializeInstagramChat() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      
      print('📱 Initializing Instagram-style chat: ${widget.chatId}');
      
      // Get AuthProvider for ChatRepository initialization
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await _chatRepository.initialize(authProvider);
      
      // Ensure both user profiles exist before loading
      await _chatRepository.ensureBothUserProfilesExist(
        widget.currentUserId, 
        widget.otherUserId, 
        authProvider,
        otherUserName: widget.otherUserName,
        otherUserProfileUrl: widget.otherUserProfileUrl,
      );
      
      // Get user profiles for proper display
      await _loadUserProfiles();
      
      // Set user online when opening chat
      await _chatRepository.setUserOnlineStatus(widget.currentUserId, true);
      
      // Mark messages as read when opening chat
      await _chatRepository.markMessagesAsRead(widget.chatId, widget.currentUserId);
      
      // Start listening to real-time updates
      _startListeningToMessages();
      _startListeningToUserStatus();
      _startListeningToTyping();
      
      setState(() {
        _isLoading = false;
      });
      
      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      
      print('✅ Instagram-style chat initialized successfully');
      
    } catch (e) {
      print('❌ Error initializing Instagram-style chat: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _loadUserProfiles() async {
    try {
      // Get other user's profile
      final otherUserProfile = await _chatRepository.getUserProfile(widget.otherUserId);
      
      if (otherUserProfile != null) {
        setState(() {
          _otherUserActualName = otherUserProfile.displayName;
          _otherUserActualProfileUrl = otherUserProfile.profileUrl;
        });
        print('👤 Loaded other user profile: ${otherUserProfile.displayName}');
        print('   Profile URL: ${otherUserProfile.profileUrl ?? 'No profile URL'}');
      } else {
        print('⚠️ Could not load other user profile, using provided data');
        setState(() {
          _otherUserActualName = widget.otherUserName;
          _otherUserActualProfileUrl = widget.otherUserProfileUrl;
        });
      }
    } catch (e) {
      print('❌ Error loading user profiles: $e');
      setState(() {
        _otherUserActualName = widget.otherUserName;
        _otherUserActualProfileUrl = widget.otherUserProfileUrl;
      });
    }
  }
  
  void _startListeningToMessages() {
    print('🔄 Starting Instagram-style message stream for chat: ${widget.chatId}');
    
    _messagesSubscription = _chatRepository
        .streamChatMessages(widget.chatId, requestingUserId: widget.currentUserId)
        .listen(
      (messages) {
        print('📨 Received ${messages.length} messages for chat: ${widget.chatId}');
        print('📋 Message details:');
        for (int i = 0; i < messages.length && i < 3; i++) {
          final msg = messages[i];
          print('   - ${msg.id}: "${msg.content}" from ${msg.senderId}');
        }
        
        if (mounted) {
          final previousMessageCount = _messages.length;
          print('📊 UI State: Previous count: $previousMessageCount, New count: ${messages.length}');
          
          setState(() {
            _messages = List<ChatMessage>.from(messages);
          });
          
          // Auto-scroll to bottom when new message arrives or on initial load
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_messages.isNotEmpty && (previousMessageCount == 0 || messages.length > previousMessageCount)) {
              _scrollToBottom();
              
              // Mark new messages as read
              _markNewMessagesAsRead();
            }
          });
        }
      },
      onError: (error) {
        print('❌ Error streaming messages: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      },
    );
  }
  
  void _startListeningToUserStatus() {
    print('🔄 Starting user status stream for: ${widget.otherUserId}');
    
    _userStatusSubscription = _chatRepository
        .streamUserStatus(widget.otherUserId)
        .listen(
      (status) {
        if (mounted) {
          setState(() {
            _otherUserStatus = status;
          });
        }
      },
      onError: (error) {
        print('❌ Error streaming user status: $error');
      },
    );
  }
  
  void _startListeningToTyping() {
    print('🔄 Starting typing status stream for chat: ${widget.chatId}');
    
    _typingSubscription = _chatRepository
        .streamTypingStatus(widget.chatId)
        .listen(
      (typingUsers) {
        if (mounted) {
          setState(() {
            _typingStatuses = typingUsers;
          });
        }
      },
      onError: (error) {
        print('❌ Error streaming typing status: $error');
      },
    );
  }

  Future<void> _markNewMessagesAsRead() async {
    try {
      await _chatRepository.markMessagesAsRead(widget.chatId, widget.currentUserId);
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  Future<void> _sendInstagramMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    print('📤 Sending Instagram-style message: "$messageText"');

    // Stop typing indicator
    if (_isCurrentUserTyping) {
      _setTypingStatus(false);
    }

    try {
      // Clear input immediately for better UX
      _messageController.clear();

      // Send message through repository
      print('🚀 Attempting to send message to chat: ${widget.chatId}');
      final sentMessage = await _chatRepository.sendMessage(
        chatId: widget.chatId,
        senderId: widget.currentUserId,
        content: messageText,
      );
      
      print('✅ Instagram-style message sent successfully!');
      print('   - Message ID: ${sentMessage.id}');
      print('   - Content: "${sentMessage.content}"');
      print('   - Chat ID: ${widget.chatId}');
      
      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      
    } catch (e) {
      print('❌ Error sending Instagram-style message: $e');
      
      // Restore message text if sending failed
      if (_messageController.text.isEmpty) {
        _messageController.text = messageText;
      }
      
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _setTypingStatus(bool isTyping) {
    _chatRepository.setTypingStatus(widget.chatId, widget.currentUserId, isTyping);
    setState(() {
      _isCurrentUserTyping = isTyping;
    });
    
    if (isTyping) {
      // Auto-stop typing after 3 seconds
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (_isCurrentUserTyping) {
          _setTypingStatus(false);
        }
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildInstagramAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildInstagramMessagesList()),
          _buildInstagramMessageInput(),
        ],
      ),
    );
  }

  // Instagram-style App Bar
  PreferredSizeWidget _buildInstagramAppBar() {
    final isOnline = _otherUserStatus?.isOnline ?? false;
    final isOtherUserTyping = _typingStatuses.containsKey(widget.otherUserId) && 
                              _typingStatuses[widget.otherUserId] == true;
    
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
          // Instagram-style profile picture
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 0.5),
            ),
            child: ClipOval(
              child: _otherUserActualProfileUrl != null
                  ? Image.network(
                      _otherUserActualProfileUrl!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          print('✅ Profile image loaded: $_otherUserActualProfileUrl');
                          return child;
                        }
                        print('⏳ Loading profile image: $_otherUserActualProfileUrl');
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 1),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('❌ Profile image failed to load: $_otherUserActualProfileUrl');
                        print('   Error: $error');
                        return _buildDefaultAppBarAvatar();
                      },
                    )
                  : _buildDefaultAppBarAvatar(),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDisplayName(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getStatusText(isOtherUserTyping, isOnline),
                  style: TextStyle(
                    color: isOtherUserTyping ? Colors.blue : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Removed call and video buttons
    );
  }

  Widget _buildDefaultAppBarAvatar() {
    final name = _getDisplayName();
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase();
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Instagram-style Messages List
  Widget _buildInstagramMessagesList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.black),
            SizedBox(height: 16),
            Text(
              'Loading messages...',
              style: TextStyle(color: Colors.grey),
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
            const Text('Failed to load messages'),
            ElevatedButton(
              onPressed: _initializeInstagramChat,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_messages.isEmpty) {
      return _buildEmptyMessagesState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == widget.currentUserId;
        final showTimestamp = index == 0 || 
            _shouldShowTimestamp(_messages[index - 1], message);
        
        return Column(
          children: [
            if (showTimestamp) _buildTimestamp(message.timestamp),
            _buildInstagramMessageBubble(message, isMe),
          ],
        );
      },
    );
  }

  Widget _buildEmptyMessagesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 0.5),
            ),
            child: ClipOval(
              child: _otherUserActualProfileUrl != null
                  ? Image.network(
                      _otherUserActualProfileUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultLargeAvatar();
                      },
                    )
                  : _buildDefaultLargeAvatar(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getDisplayName(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Say hello! 👋',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLargeAvatar() {
    final name = _getDisplayName();
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase();
    
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInstagramMessageBubble(ChatMessage message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 0.5),
              ),
              child: ClipOval(
                child: _otherUserActualProfileUrl != null
                    ? Image.network(
                        _otherUserActualProfileUrl!,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildSmallDefaultAvatar();
                        },
                      )
                    : _buildSmallDefaultAvatar(),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          
          if (isMe) ...[
            const SizedBox(width: 8),
            Icon(
              _isMessageRead(message) ? Icons.done_all : Icons.done,
              color: _isMessageRead(message) ? Colors.blue : Colors.grey,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallDefaultAvatar() {
    final name = _getDisplayName();
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(1).join().toUpperCase();
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formattedTime = _formatMessageTime(dateTime);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            formattedTime,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // Instagram-style Message Input
  Widget _buildInstagramMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), // Added extra bottom padding
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onChanged: (text) {
                  if (text.isNotEmpty && !_isCurrentUserTyping) {
                    _setTypingStatus(true);
                  } else if (text.isEmpty && _isCurrentUserTyping) {
                    _setTypingStatus(false);
                  }
                },
                onSubmitted: (_) => _sendInstagramMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: _sendInstagramMessage,
            ),
          ),
        ],
      ),
      ),
    );
  }

  // Helper methods
  String _getDisplayName() {
    return _otherUserActualName?.isNotEmpty == true 
        ? _otherUserActualName!
        : widget.otherUserName?.isNotEmpty == true 
        ? widget.otherUserName!
        : 'User ${widget.otherUserId}';
  }

  String _getStatusText(bool isTyping, bool isOnline) {
    if (isTyping) return 'typing...';
    if (isOnline) return 'Active now';
    
    if (_otherUserStatus?.lastSeen != null) {
      final lastSeen = DateTime.fromMillisecondsSinceEpoch(_otherUserStatus!.lastSeen);
      final now = DateTime.now();
      final difference = now.difference(lastSeen);
      
      if (difference.inMinutes < 60) {
        return 'Active ${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return 'Active ${difference.inHours}h ago';
      } else {
        return 'Active ${difference.inDays}d ago';
      }
    }
    
    return '';
  }

  bool _shouldShowTimestamp(ChatMessage prevMessage, ChatMessage currentMessage) {
    final prevTime = DateTime.fromMillisecondsSinceEpoch(prevMessage.timestamp);
    final currentTime = DateTime.fromMillisecondsSinceEpoch(currentMessage.timestamp);
    return currentTime.difference(prevTime).inMinutes > 15;
  }

  bool _isMessageRead(ChatMessage message) {
    return message.readBy?.containsKey(widget.otherUserId) == true;
  }

  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}