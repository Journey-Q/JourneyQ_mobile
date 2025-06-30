// individual_chat_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IndividualChatPage extends StatefulWidget {
  final String chatId;
  final Map<String, dynamic> chatData;

  const IndividualChatPage({
    super.key,
    required this.chatId,
    required this.chatData,
  });

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> _messages;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.chatData['messages'] ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _buildMessagesList(),
          ),
          
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: widget.chatData['userImage'].isNotEmpty
                ? NetworkImage(widget.chatData['userImage'])
                : null,
            backgroundColor: Colors.grey[300],
            child: widget.chatData['userImage'].isEmpty
                ? Icon(
                    widget.chatData['type'] == 'marketplace' ? Icons.storefront : Icons.person,
                    color: Colors.grey[600],
                    size: 18,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.chatData['userName'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.chatData['type'] == 'marketplace' && 
                        (widget.chatData['isVerified'] ?? false)) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                Text(
                  _isTyping ? 'typing...' : 
                  widget.chatData['isOnline'] ? 'Online' : 'Last seen recently',
                  style: TextStyle(
                    color: _isTyping ? Colors.blue : 
                           widget.chatData['isOnline'] ? Colors.green : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: _showChatInfo,
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: widget.chatData['userImage'].isNotEmpty
                  ? NetworkImage(widget.chatData['userImage'])
                  : null,
              backgroundColor: Colors.grey[200],
              child: widget.chatData['userImage'].isEmpty
                  ? Icon(
                      widget.chatData['type'] == 'marketplace' ? Icons.storefront : Icons.person,
                      color: Colors.grey[600],
                      size: 40,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.chatData['userName'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.chatData['type'] == 'marketplace'
                  ? 'Start chatting about products or services'
                  : 'Start your travel conversation',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message['senderId'] == 'user';
        final showTimestamp = index == 0 || 
            _shouldShowTimestamp(_messages[index - 1], message);
        
        return Column(
          children: [
            if (showTimestamp) _buildTimestamp(message['timestamp']),
            _buildMessageBubble(message, isMe),
          ],
        );
      },
    );
  }

  Widget _buildTimestamp(String timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          timestamp,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundImage: widget.chatData['userImage'].isNotEmpty
                  ? NetworkImage(widget.chatData['userImage'])
                  : null,
              backgroundColor: Colors.grey[300],
              child: widget.chatData['userImage'].isEmpty
                  ? Icon(
                      widget.chatData['type'] == 'marketplace' ? Icons.storefront : Icons.person,
                      color: Colors.grey[600],
                      size: 14,
                    )
                  : null,
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
                color: isMe ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildMessageContent(message, isMe),
            ),
          ),
          
          if (isMe) ...[
            const SizedBox(width: 8),
            Icon(
              message['isRead'] ? Icons.done_all : Icons.done,
              color: message['isRead'] ? Colors.blue : Colors.grey,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> message, bool isMe) {
    if (message['messageType'] == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          message['message'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.error, color: Colors.grey),
              ),
            );
          },
        ),
      );
    }
    
    return Text(
      message['message'],
      style: TextStyle(
        color: isMe ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Message input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: _onMessageChanged,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Send button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  bool _shouldShowTimestamp(Map<String, dynamic> prevMessage, Map<String, dynamic> currentMessage) {
    // Show timestamp if messages are far apart or from different days
    // This is a simplified version - you'd want more sophisticated logic
    return prevMessage['timestamp'] != currentMessage['timestamp'];
  }

  void _onMessageChanged(String text) {
    // Simulate typing indicator
    if (text.isNotEmpty && !_isTyping) {
      setState(() {
        _isTyping = true;
      });
      
      // Reset typing after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _messageController.text.isEmpty) {
          setState(() {
            _isTyping = false;
          });
        }
      });
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': 'user',
      'message': messageText,
      'timestamp': _formatTimestamp(DateTime.now()),
      'isRead': false,
      'messageType': 'text',
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _isTyping = false;
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Simulate reply for demo
    _simulateReply();
  }

  void _simulateReply() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      final replies = [
        'Thanks for the message! 😊',
        'That sounds great!',
        'I\'ll get back to you soon',
        'Perfect! Let me check that for you',
        'Absolutely! I agree',
      ];
      
      final randomReply = replies[DateTime.now().millisecond % replies.length];
      
      final replyMessage = {
        'id': 'reply_${DateTime.now().millisecondsSinceEpoch}',
        'senderId': 'other',
        'message': randomReply,
        'timestamp': _formatTimestamp(DateTime.now()),
        'isRead': false,
        'messageType': 'text',
      };

      setState(() {
        _messages.add(replyMessage);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return 'Yesterday';
    }
  }


  

  

  void _showChatInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: widget.chatData['userImage'].isNotEmpty
                  ? NetworkImage(widget.chatData['userImage'])
                  : null,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Text(
              widget.chatData['userName'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Chat'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}