import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/chat/data.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Controllers and State Variables
  late List<Map<String, dynamic>> _travellerChats;

  // Constants
  static const double _appBarElevation = 0.0;
  static const double _borderRadius = 12.0;
  static const double _avatarRadius = 28.0;

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  // Initialization Methods
  void _loadChatData() {
    _travellerChats = chat_data
        .where((chat) => chat['type'] == 'traveller')
        .toList();
    _sortChatsByTime();
  }

  void _sortChatsByTime() {
    _travellerChats.sort((a, b) {
      final timeA = _parseTimeAgo(a['lastMessageTime']);
      final timeB = _parseTimeAgo(b['lastMessageTime']);
      return timeA.compareTo(timeB);
    });
  }

  int _parseTimeAgo(String timeAgo) {
    final timeValue = int.tryParse(timeAgo.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    
    if (timeAgo.contains('m')) return timeValue;
    if (timeAgo.contains('h')) return timeValue * 60;
    if (timeAgo.contains('d')) return timeValue * 1440;
    
    return 0;
  }

  // Counter Methods
  int _getTotalUnreadCount() {
    return _travellerChats
        .map((chat) => chat['unreadCount'] as int)
        .fold(0, (sum, count) => sum + count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildChatList(),
    );
  }

  // App Bar Components
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: _appBarElevation,
      scrolledUnderElevation: _appBarElevation,
      leading: _buildBackButton(),
      title: _buildAppBarTitle(),
      bottom: _buildAppBarBorder(),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildAppBarTitle() {
    final totalUnread = _getTotalUnreadCount();
    
    return Row(
      children: [
        const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (totalUnread > 0) ...[
          const SizedBox(width: 8),
          _buildUnreadBadge(
            count: totalUnread,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ],
      ],
    );
  }

  PreferredSize _buildAppBarBorder() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }

  // Chat List Components
  Widget _buildChatList() {
    if (_travellerChats.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _travellerChats.length,
        itemBuilder: (context, index) => _buildChatItem(_travellerChats[index]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No traveller chats yet',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with fellow travellers\nto share experiences and tips!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: chat['unreadCount'] > 0 
            ? Colors.blue[50]?.withOpacity(0.3) 
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildChatAvatar(chat),
        title: _buildChatTitle(chat),
        subtitle: _buildChatSubtitle(chat),
        trailing: _buildChatTrailing(chat),
        onTap: () => _openChat(chat),
      ),
    );
  }

  // Chat Item Components
  Widget _buildChatAvatar(Map<String, dynamic> chat) {
    return Stack(
      children: [
        CircleAvatar(
          radius: _avatarRadius,
          backgroundImage: chat['userImage'].isNotEmpty
              ? NetworkImage(chat['userImage'])
              : null,
          backgroundColor: Colors.grey[300],
          child: chat['userImage'].isEmpty
              ? Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 28,
                )
              : null,
        ),
        if (chat['isOnline']) _buildOnlineIndicator(),  
      ],
    );
  }

  Widget _buildOnlineIndicator() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildChatTitle(Map<String, dynamic> chat) {
    return Row(
      children: [
        Expanded(
          child: Text(
            chat['userName'],
            style: TextStyle(
              fontWeight: chat['unreadCount'] > 0 ? FontWeight.w600 : FontWeight.w500,
              fontSize: 16,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget _buildChatSubtitle(Map<String, dynamic> chat) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        chat['lastMessage'],
        style: TextStyle(
          color: chat['unreadCount'] > 0 ? Colors.black87 : Colors.grey[600],
          fontSize: 14,
          fontWeight: chat['unreadCount'] > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildChatTrailing(Map<String, dynamic> chat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          chat['lastMessageTime'],
          style: TextStyle(
            color: chat['unreadCount'] > 0 ? Colors.blue : Colors.grey[500],
            fontSize: 12,
            fontWeight: chat['unreadCount'] > 0 ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        if (chat['unreadCount'] > 0)
          _buildUnreadBadge(
            count: chat['unreadCount'],
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          ),
      ],
    );
  }

  Widget _buildUnreadBadge({
    required int count,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Event Handlers
  void _openChat(Map<String, dynamic> chat) {
    setState(() {
      chat['unreadCount'] = 0;
    });
    context.push('/chat/${chat['id']}', extra: chat);
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _showSnackBar('Chats refreshed');
    }
  }

  // Helper Methods
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}