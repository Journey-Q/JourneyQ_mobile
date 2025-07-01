import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/chat/data.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // Controllers and State Variables
  late TabController _tabController;
  late List<Map<String, dynamic>> _allChats;
  List<Map<String, dynamic>> _filteredChats = [];
  int _currentTabIndex = 0;

  // Constants
  static const int _travellerTabIndex = 0;
  static const int _marketplaceTabIndex = 1;
  static const double _appBarElevation = 0.0;
  static const double _borderRadius = 12.0;
  static const double _avatarRadius = 28.0;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _loadChatData();
    _setupTabListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Initialization Methods
  void _initializeController() {
    _tabController = TabController(length: 2, vsync: this);
  }

  void _loadChatData() {
    _allChats = List.from(chat_data);
    _filterChats();
  }

  void _setupTabListener() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
        _filterChats();
      }
    });
  }

  // Data Processing Methods
  void _filterChats() {
    final chatType = _currentTabIndex == _travellerTabIndex ? 'traveller' : 'marketplace';
    _filteredChats = _allChats.where((chat) => chat['type'] == chatType).toList();
    _sortChatsByTime();
  }

  void _sortChatsByTime() {
    _filteredChats.sort((a, b) {
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
    return _allChats
        .map((chat) => chat['unreadCount'] as int)
        .fold(0, (sum, count) => sum + count);
  }

  int _getTravellerUnreadCount() {
    return _getChatUnreadCount('traveller');
  }

  int _getMarketplaceUnreadCount() {
    return _getChatUnreadCount('marketplace');
  }

  int _getChatUnreadCount(String type) {
    return _allChats
        .where((chat) => chat['type'] == type)
        .map((chat) => chat['unreadCount'] as int)
        .fold(0, (sum, count) => sum + count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody()
    );
  }

  // Main Body Structure
  Widget _buildBody() {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: _currentTabIndex == _travellerTabIndex
              ? _buildChatList('traveller')
              : _buildChatList('marketplace'),
        ),
      ],
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

  // Tab Bar Components
  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TabBar(
        controller: _tabController,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          insets: EdgeInsets.symmetric(horizontal: 10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        tabs: [
          _buildTab(
            icon: Icons.people,
            label: 'Travellers',
            unreadCount: _getTravellerUnreadCount(),
            isSelected: _currentTabIndex == _travellerTabIndex,
          ),
          _buildTab(
            icon: Icons.storefront,
            label: 'Marketplace',
            unreadCount: _getMarketplaceUnreadCount(),
            isSelected: _currentTabIndex == _marketplaceTabIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int unreadCount,
    required bool isSelected,
  }) {
    return Tab(
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              size: 18,
              color: isSelected ? Colors.blue : Colors.black,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label, overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }


  // Chat List Components
  Widget _buildChatList(String type) {
    final chats = _allChats.where((chat) => chat['type'] == type).toList();
    
    if (chats.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: chats.length,
        itemBuilder: (context, index) => _buildChatItem(chats[index]),
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    final isTraveller = type == 'traveller';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isTraveller ? Icons.people_outline : Icons.storefront_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isTraveller ? 'No traveller chats yet' : 'No marketplace chats yet',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTraveller 
                ? 'Start chatting with fellow travellers\nto share experiences and tips!'
                : 'Browse marketplace to find\ntravel gear and services!',
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
                  chat['type'] == 'marketplace' ? Icons.storefront : Icons.person,
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