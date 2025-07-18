// File: lib/features/marketplace/pages/marketplace_chat.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MarketplaceChatPage extends StatefulWidget {
  const MarketplaceChatPage({Key? key}) : super(key: key);

  @override
  State<MarketplaceChatPage> createState() => _MarketplaceChatPageState();
}

class _MarketplaceChatPageState extends State<MarketplaceChatPage> {
  // Sample chat conversations data
  final List<Map<String, dynamic>> conversations = [
    {
      'id': 'chat_001',
      'name': 'Shangri-La Hotel Colombo',
      'serviceType': 'Hotel',
      'lastMessage': 'Thank you for your inquiry about our premium suite. We have availability for your dates.',
      'timestamp': '2 min ago',
      'unreadCount': 2,
      'isOnline': true,
      'avatar': 'assets/images/shangri_la_avatar.jpg',
      'serviceColor': const Color(0xFF8B4513),
    },
    {
      'id': 'chat_002',
      'name': 'Heritage Tours Lanka',
      'serviceType': 'Tour Package',
      'lastMessage': 'The Cultural Triangle tour package includes all meals and transportation as mentioned.',
      'timestamp': '15 min ago',
      'unreadCount': 0,
      'isOnline': true,
      'avatar': 'assets/images/heritage_tours_avatar.jpg',
      'serviceColor': const Color(0xFF228B22),
    },
    {
      'id': 'chat_003',
      'name': 'Ceylon Roots',
      'serviceType': 'Travel Agency',
      'lastMessage': 'Our driver Kumara will pick you up at 8:00 AM sharp. Please be ready at the hotel lobby.',
      'timestamp': '1 hour ago',
      'unreadCount': 1,
      'isOnline': false,
      'avatar': 'assets/images/ceylon_roots_avatar.jpg',
      'serviceColor': const Color(0xFF20B2AA),
    },
    {
      'id': 'chat_004',
      'name': 'Cinnamon Grand Colombo',
      'serviceType': 'Hotel',
      'lastMessage': 'Your reservation has been confirmed. Check-in time is 2:00 PM.',
      'timestamp': '3 hours ago',
      'unreadCount': 0,
      'isOnline': true,
      'avatar': 'assets/images/cinnamon_grand_avatar.jpg',
      'serviceColor': const Color(0xFF8B4513),
    },
    {
      'id': 'chat_005',
      'name': 'Mountain Escape Tours',
      'serviceType': 'Tour Package',
      'lastMessage': 'The weather forecast looks great for your Hill Country adventure next week!',
      'timestamp': '5 hours ago',
      'unreadCount': 0,
      'isOnline': false,
      'avatar': 'assets/images/mountain_escape_avatar.jpg',
      'serviceColor': const Color(0xFF228B22),
    },
    {
      'id': 'chat_006',
      'name': 'Jetwing Travels',
      'serviceType': 'Travel Agency',
      'lastMessage': 'We can arrange a luxury vehicle for your airport transfer. Would you prefer a sedan or SUV?',
      'timestamp': '1 day ago',
      'unreadCount': 3,
      'isOnline': true,
      'avatar': 'assets/images/jetwing_avatar.jpg',
      'serviceColor': const Color(0xFF20B2AA),
    },
    {
      'id': 'chat_007',
      'name': 'Galle Face Hotel',
      'serviceType': 'Hotel',
      'lastMessage': 'We have upgraded your room to ocean view at no additional cost. Enjoy your stay!',
      'timestamp': '2 days ago',
      'unreadCount': 0,
      'isOnline': false,
      'avatar': 'assets/images/galle_face_avatar.jpg',
      'serviceColor': const Color(0xFF8B4513),
    },
  ];

  void _navigateToChatDetails(String chatId, String name, String serviceType) {
    context.push('/market_chat/details/$chatId?name=${Uri.encodeComponent(name)}&serviceType=${Uri.encodeComponent(serviceType)}');
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => _navigateToChatDetails(chat['id'], chat['name'], chat['serviceType']),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: chat['serviceColor'].withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.asset(
                          chat['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    chat['serviceColor'],
                                    chat['serviceColor'].withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                _getServiceIcon(chat['serviceType']),
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Online indicator
                    if (chat['isOnline'])
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 12),
                
                // Chat content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            chat['timestamp'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Service type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: chat['serviceColor'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          chat['serviceType'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: chat['serviceColor'],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Last message
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['lastMessage'],
                              style: TextStyle(
                                fontSize: 14,
                                color: chat['unreadCount'] > 0 ? Colors.black87 : Colors.grey[600],
                                fontWeight: chat['unreadCount'] > 0 ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // Unread count badge
                          if (chat['unreadCount'] > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088cc),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                chat['unreadCount'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'hotel':
        return Icons.hotel;
      case 'tour package':
        return Icons.tour;
      case 'travel agency':
        return Icons.business;
      default:
        return Icons.chat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversations.where((chat) => chat['unreadCount'] > 0).length;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        titleSpacing: 20,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      body: Column(
        children: [
          
          // Conversations list
          Expanded(
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.messageCircle,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No conversations yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start chatting with hotels and service providers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/marketplace');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088cc),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Browse Marketplace'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      return _buildChatItem(conversations[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}