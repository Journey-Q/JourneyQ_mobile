import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_app_bar.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_message_bubble.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_date_divider.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_input_bar.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_gallery_screen.dart';
import 'package:journeyq/features/join_trip/pages/chat/budget_tracker_screen.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/joint_trip_group_chats.dart';
import 'package:journeyq/data/repositories/jointTrip_chat/jointTrip_group.dart';
import 'package:journeyq/core/storage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userImage;

  const GroupChatScreen({
    super.key, 
    required this.groupId,
    required this.groupName, 
    required this.userImage
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  Map<String, dynamic>? _groupData;
  int? _currentUserId;
  String? _currentUserName;
  String? _currentUserAvatar;
  int? _tripId;
  bool _isLoading = true;
  StreamSubscription? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      setState(() => _isLoading = true);

      // Get current user info
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorage(prefs: prefs);
      final currentUser = await localStorage.getUser();

      _currentUserId = currentUser?.userId;
      _currentUserName = currentUser?.username ?? 'User';
      _currentUserAvatar = currentUser?.profileUrl ?? '';

      // Extract tripId from groupId (format: trip_123)
      _tripId = int.tryParse(widget.groupId.replaceFirst('trip_', ''));

      if (_tripId != null) {
        // Fetch group data from Firebase
        _groupData = await JointTripGroupRepository.getGroupDetails(_tripId!);

        // Listen to messages in real-time
        _listenToMessages();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error initializing chat: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _listenToMessages() {
    if (_tripId == null) return;

    _messagesSubscription = JointTripGroupChatsRepository.listenToMessages(
      tripId: _tripId!,
      limit: 100,
    ).listen((messages) {
      if (mounted) {
        setState(() {
          // Convert Firebase messages to UI format
          final convertedMessages = messages.map((msg) => _convertFirebaseMessage(msg)).toList();

          // Sort by timestamp OLDEST FIRST (ascending order)
          // Because ListView with reverse:true will display them bottom-to-top
          convertedMessages.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));

          _messages = convertedMessages;
        });
      }
    }, onError: (error) {
      print('Error listening to messages: $error');
    });
  }

  Map<String, dynamic> _convertFirebaseMessage(Map<String, dynamic> firebaseMsg) {
    final timestamp = firebaseMsg['timestamp'] as int;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return {
      'messageId': firebaseMsg['messageId'],
      'sender': firebaseMsg['senderName'],
      'senderId': firebaseMsg['senderId'],
      'text': firebaseMsg['messageText'],
      'time': '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}',
      'date': '${dateTime.day}/${dateTime.month}/${dateTime.year}',
      'isMe': firebaseMsg['senderId'] == _currentUserId,
      'messageType': firebaseMsg['messageType'] ?? 'text',
      'attachmentUrl': firebaseMsg['attachmentUrl'],
      'timestamp': timestamp,
    };
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _tripId == null || _currentUserId == null) {
      return;
    }

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      await JointTripGroupChatsRepository.sendMessage(
        tripId: _tripId!,
        senderId: _currentUserId!,
        senderName: _currentUserName ?? 'User',
        senderAvatar: _currentUserAvatar ?? '',
        messageText: messageText,
        messageType: 'text',
      );

      // Auto scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });

    // Update typing status in Firebase
    if (_tripId != null && _currentUserId != null) {
      JointTripGroupChatsRepository.setTypingStatus(
        tripId: _tripId!,
        userId: _currentUserId!,
        isTyping: text.isNotEmpty,
      );
    }
  }

  void _navigateToGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatGalleryScreen(
          groupId: widget.groupId,
          groupName: widget.groupName,
          members: _getMembers(),
        ),
      ),
    );
  }

  void _navigateToBudget() {
    if (_tripId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load budget: Trip ID not found'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetTrackerScreen(
          groupId: _tripId.toString(), // Pass numeric trip ID as string
          groupName: widget.groupName,
          members: _getMembers(),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMembers() {
    if (_groupData == null) return [];

    final membersMap = _groupData!['members'] as Map<dynamic, dynamic>?;
    if (membersMap == null) return [];

    // Transform Firebase member format to expected format
    return membersMap.values
        .map((m) {
          final member = Map<String, dynamic>.from(m as Map);
          return {
            'id': member['userId']?.toString() ?? '',
            'name': member['userName']?.toString() ?? 'Unknown',
            'avatar': member['userAvatar']?.toString() ?? '',
            'role': member['role']?.toString() ?? 'member',
            'userId': member['userId'], // Keep original for compatibility
            'userName': member['userName'],
            'userAvatar': member['userAvatar'],
          };
        })
        .toList();
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();

    // Clear typing status when leaving chat
    if (_tripId != null && _currentUserId != null) {
      JointTripGroupChatsRepository.setTypingStatus(
        tripId: _tripId!,
        userId: _currentUserId!,
        isTyping: false,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: ChatAppBar(
        groupId: widget.groupId,
        groupName: widget.groupName,
        userImage: widget.userImage,
        groupProfile: _groupData?['groupProfile'], // Pass Firebase group profile image
        description: _groupData?['description'] ?? 'No description available',
        members: _getMembers(),
        isCreator: _groupData?['creatorId'] == _currentUserId,
        createdDate: _groupData?['createdDate'] ?? 'Unknown',
        onGalleryPressed: _navigateToGallery,
        onBudgetPressed: _navigateToBudget,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      final isMe = message['isMe'];
                      final showDate = index == _messages.length - 1 ||
                          _messages[_messages.length - 1 - (index + 1)]['date'] != message['date'];

                      return Column(
                        children: [
                          if (showDate) ChatDateDivider(date: message['date']!),
                          ChatMessageBubble(message: message, isMe: isMe),
                        ],
                      );
                    },
                  ),
          ),
          ChatInputBar(
            messageController: _messageController,
            isTyping: _isTyping,
            onTextChanged: _onTextChanged,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}