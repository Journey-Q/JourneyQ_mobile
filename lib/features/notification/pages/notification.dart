// notification_page.dart
import 'package:flutter/material.dart';
import 'package:journeyq/features/notification/data.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<Map<String, dynamic>> _notifications;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(notification_data);
    _calculateUnreadCount();
  }

  void _calculateUnreadCount() {
    _unreadCount = _notifications
        .where((notification) => !notification['isRead'])
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              // Mark all as read section
              if (_unreadCount > 0) _buildMarkAllReadSection(),

              // Notifications list
              Expanded(child: _buildNotificationsList()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_unreadCount',
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
        child: Container(height: 1, color: Colors.grey[200]),
      ),
    );
  }

  Widget _buildMarkAllReadSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.mark_email_read_outlined,
            color: Colors.blue[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You have $_unreadCount unread notification${_unreadCount == 1 ? '' : 's'}',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: _markAllAsRead,
            child: Text(
              'Mark all as read',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (_notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'When someone likes or comments on your posts,\nyou\'ll see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Group notifications by time
    final groupedNotifications = _groupNotificationsByTime();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final group = groupedNotifications[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time group header
            if (group['header'] != null) _buildTimeHeader(group['header']),

            // Notifications in this group
            ...group['notifications'].map<Widget>((notification) {
              return _buildNotificationItem(notification);
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildTimeHeader(String header) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        header,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      decoration: BoxDecoration(
        color: notification['isRead']
            ? Colors.white
            : Colors.blue[50]?.withOpacity(0.3),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildNotificationAvatar(notification),
        title: _buildNotificationContent(notification),
        trailing: _buildNotificationTrailing(notification),
      ),
    );
  }

  Widget _getSystemIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'achievement':
        iconData = Icons.travel_explore;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey[600]!;
    }

    return Icon(iconData, color: iconColor, size: 24);
  }

  Widget _buildNotificationAvatar(Map<String, dynamic> notification) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage:
              notification['userImage'] != null &&
                  notification['userImage'].isNotEmpty
              ? NetworkImage(notification['userImage'])
              : null,
          backgroundColor: Colors.grey[300],
          child:
              notification['userImage'] == null ||
                  notification['userImage'].isEmpty
              ? _getSystemIcon(notification['type'])
              : null,
        ),
        // Notification type indicator
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification['type']),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              _getNotificationIcon(notification['type']),
              size: 8,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationContent(Map<String, dynamic> notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: notification['userName'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: notification['message'],
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          notification['timeAgo'],
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNotificationTrailing(Map<String, dynamic> notification) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Post thumbnail if available
        if (notification['postImage'] != null) ...[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(notification['postImage']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        // Unread indicator
        if (!notification['isRead'])
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  

  

  // Helper methods for notification icons and colors
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.chat_bubble;
      case 'follow':
        return Icons.person_add;
      case 'achievement':
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.blue;
      case 'follow':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Group notifications by time periods
  List<Map<String, dynamic>> _groupNotificationsByTime() {
    final groups = <Map<String, dynamic>>[];
    final now = DateTime.now();

    final today = <Map<String, dynamic>>[];
    final yesterday = <Map<String, dynamic>>[];
    final thisWeek = <Map<String, dynamic>>[];
    final older = <Map<String, dynamic>>[];

    for (final notification in _notifications) {
      final timeAgo = notification['timeAgo'] as String;

      if (timeAgo.contains('m') || timeAgo.contains('h') || timeAgo == 'now') {
        today.add(notification);
      } else if (timeAgo == '1d') {
        yesterday.add(notification);
      } else if (timeAgo.contains('d') && !timeAgo.contains('w')) {
        final days = int.tryParse(timeAgo.replaceAll('d', '')) ?? 0;
        if (days <= 7) {
          thisWeek.add(notification);
        } else {
          older.add(notification);
        }
      } else {
        older.add(notification);
      }
    }

    if (today.isNotEmpty) {
      groups.add({'header': 'Today', 'notifications': today});
    }
    if (yesterday.isNotEmpty) {
      groups.add({'header': 'Yesterday', 'notifications': yesterday});
    }
    if (thisWeek.isNotEmpty) {
      groups.add({'header': 'This Week', 'notifications': thisWeek});
    }
    if (older.isNotEmpty) {
      groups.add({'header': 'Earlier', 'notifications': older});
    }

    return groups;
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
      _unreadCount = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulate new notifications
    setState(() {
      // You could add new notifications here
      _calculateUnreadCount();
    });

    if (mounted) {
     
    }
  }
}
