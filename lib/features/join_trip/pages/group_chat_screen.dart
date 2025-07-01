import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_app_bar.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_message_bubble.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_date_divider.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_input_bar.dart';
import 'package:journeyq/features/join_trip/pages/chat/chat_attachment_options.dart';

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
  late Map<String, dynamic> _groupData;

  @override
  void initState() {
    super.initState();
    // Load messages from SampleData
    _messages = List.from(SampleData.chatMessages);
    // Get group data
    _groupData = SampleData.getGroupById(widget.groupId) ?? {};
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final now = DateTime.now();
      setState(() {
        _messages.add({
          'sender': 'You',
          'text': _messageController.text.trim(),
          'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
          'date': '${now.day}/${now.month}/${now.year}',
          'isMe': true,
          'messageType': 'text'
        });
        _messageController.clear();
      });
      
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
    }
  }

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ChatAttachmentOptions(),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: ChatAppBar(
        groupId: widget.groupId,
        groupName: widget.groupName,
        userImage: widget.userImage,
        description: _groupData['description'] ?? 'No description available',
        members: List<Map<String, dynamic>>.from(_groupData['members'] ?? []),
        isCreator: _groupData['isCreator'] ?? false,
        createdDate: _groupData['createdDate'] ?? 'Unknown',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
            onShowAttachmentOptions: _showAttachmentOptions,
          ),
        ],
      ),
    );
  }
}