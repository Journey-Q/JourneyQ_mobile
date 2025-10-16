import 'package:flutter/material.dart';
import 'package:journeyq/features/notification/models/notification_model.dart';
import 'package:journeyq/features/notification/repository/notification_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationRepository _repository = NotificationRepository();
  late Stream<List<NotificationModel>> _notificationsStream;
  late Stream<int> _unreadCountStream;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    final authProvider = AuthProvider();
    _initializeNotifications(authProvider);
  }

  void _initializeNotifications(AuthProvider authProvider) {
    _currentUserId = authProvider.user?.userId;

    if (_currentUserId != null) {
      _notificationsStream = _repository.listenToNotifications(_currentUserId!.toString());
      _unreadCountStream = _repository.listenToUnreadCount(_currentUserId!.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(0),
        body: const Center(
          child: Text('Please login to view notifications'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(0),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<int>(
              stream: _unreadCountStream,
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                return SizedBox(
                  height: 0, // No visible widget, just for state
                  child: Builder(
                    builder: (context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() {});
                      });
                      return const SizedBox.shrink();
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<List<NotificationModel>>(
                stream: _notificationsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                final authProvider = AuthProvider();
                                _initializeNotifications(authProvider);
                              });
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final notifications = snapshot.data ?? [];
                  final unreadCount = notifications.where((n) => !n.isRead).length;

                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Column(
                      children: [
  
                        Expanded(
                          child: _buildNotificationsList(notifications),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int unreadCount) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
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
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
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

  Widget _buildMarkAllReadSection(int unreadCount) {
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
              'You have $unreadCount unread notification${unreadCount == 1 ? '' : 's'}',
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

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
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

    final groupedNotifications = _groupNotificationsByTime(notifications);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final group = groupedNotifications[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (group['header'] != null) _buildTimeHeader(group['header']),
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

  Widget _buildNotificationItem(NotificationModel notification) {
    final isFollowRequest = notification.notificationType == NotificationType.followRequest &&
        (notification.followRequestStatus == null || notification.followRequestStatus == 'pending');

    return Dismissible(
      key: Key(notification.id ?? notification.senderId + notification.timestamp.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification);
      },
      child: InkWell(
        onTap: isFollowRequest ? null : () => _onNotificationTap(notification),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : Colors.blue[50]?.withOpacity(0.3),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: _buildNotificationAvatar(notification),
                title: _buildNotificationContent(notification),
                trailing: _buildNotificationTrailing(notification),
              ),
              if (isFollowRequest) _buildFollowRequestActions(notification),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationAvatar(NotificationModel notification) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: notification.senderProfileUrl != null &&
                  notification.senderProfileUrl!.isNotEmpty
              ? NetworkImage(notification.senderProfileUrl!)
              : null,
          backgroundColor: Colors.grey[300],
          child: notification.senderProfileUrl == null ||
                  notification.senderProfileUrl!.isEmpty
              ? Icon(
                  _getNotificationIcon(notification.typeString),
                  color: Colors.grey[600],
                  size: 24,
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.typeString),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              _getNotificationIcon(notification.typeString),
              size: 8,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationContent(NotificationModel notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: notification.senderName ?? 'Someone',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: notification.message,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          notification.timeAgo,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNotificationTrailing(NotificationModel notification) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!notification.isRead)
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

  Widget _buildFollowRequestActions(NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleRejectFollowRequest(notification),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleAcceptFollowRequest(notification),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Accept'),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.chat_bubble;
      case 'follow':
        return Icons.person_add;
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

  List<Map<String, dynamic>> _groupNotificationsByTime(
      List<NotificationModel> notifications) {
    final groups = <Map<String, dynamic>>[];

    final today = <NotificationModel>[];
    final yesterday = <NotificationModel>[];
    final thisWeek = <NotificationModel>[];
    final older = <NotificationModel>[];

    for (final notification in notifications) {
      final timeAgo = notification.timeAgo;

      if (timeAgo.contains('m') || timeAgo.contains('h') || timeAgo == 'now') {
        today.add(notification);
      } else if (timeAgo == '1d') {
        yesterday.add(notification);
      } else if (timeAgo.contains('d')) {
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

  Future<void> _markAllAsRead() async {
    if (_currentUserId == null) return;

    final success = await _repository.markAllAsRead(_currentUserId!.toString());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'All notifications marked as read'
                : 'Failed to mark notifications as read',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    if (_currentUserId == null || notification.id == null) return;

    final success = await _repository.deleteNotification(
      _currentUserId!.toString(),
      notification.id!,
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete notification'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onNotificationTap(NotificationModel notification) async {
    if (_currentUserId == null || notification.id == null) return;

    if (!notification.isRead) {
      await _repository.markAsRead(_currentUserId!.toString(), notification.id!);
    }

    // Navigate based on notification type
    if (notification.postId != null) {
      // Navigate to post detail screen
      // Navigator.pushNamed(context, '/post', arguments: notification.postId);
    }
  }

  Future<void> _handleRefresh() async {
    if (_currentUserId != null) {
      setState(() {
        final authProvider = AuthProvider();
        _initializeNotifications(authProvider);
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _handleAcceptFollowRequest(NotificationModel notification) async {
    if (_currentUserId == null || notification.id == null) return;

    // Check if followId is available
    if (notification.followId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid follow request - missing follow ID'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final success = await _repository.acceptFollowRequest(notification.followId!);

    if (success) {
      // Delete the notification from Firebase after accepting
      await _repository.deleteNotification(
        _currentUserId!.toString(),
        notification.id!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Accepted follow request from ${notification.senderName ?? "user"}'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to accept follow request'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleRejectFollowRequest(NotificationModel notification) async {
    if (_currentUserId == null || notification.id == null) return;

    // Check if followId is available
    if (notification.followId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid follow request - missing follow ID'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final success = await _repository.rejectFollowRequest(notification.followId!);

    if (success) {
      // Delete the notification from Firebase after rejecting
      await _repository.deleteNotification(
        _currentUserId!.toString(),
        notification.id!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rejected follow request from ${notification.senderName ?? "user"}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reject follow request'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
