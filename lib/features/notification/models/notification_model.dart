class NotificationModel {
  final String senderId;
  final String receiverId;
  final NotificationType notificationType;
  final String? content;
  final int timestamp;
  final bool isRead;
  final String? senderName;
  final String? senderProfileUrl;
  final String? postId;
  final String? postName;
  final String? commentId;
  final String? id;
  final String? followRequestStatus; // pending, accepted, rejected
  final int? followId; // Follow request ID for accept/reject operations

  NotificationModel({
    required this.senderId,
    required this.receiverId,
    required this.notificationType,
    this.content,
    required this.timestamp,
    this.isRead = false,
    this.senderName,
    this.senderProfileUrl,
    this.postId,
    this.postName,
    this.commentId,
    this.id,
    this.followRequestStatus,
    this.followId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      senderId: json['sender_id'] as String? ?? '',
      receiverId: json['receiver_id'] as String? ?? '',
      notificationType: _parseNotificationType(json['notification_type']),
      content: json['content'] as String?,
      timestamp: json['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      isRead: json['is_read'] as bool? ?? false,
      senderName: json['sender_name'] as String?,
      senderProfileUrl: json['sender_profile_url'] as String?,
      postId: json['post_id'] as String?,
      postName: json['post_name'] as String?,
      commentId: json['comment_id'] as String?,
      id: json['id'] as String?,
      followRequestStatus: json['follow_request_status'] as String?,
      followId: json['follow_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'notification_type': notificationType.name,
      'content': content,
      'timestamp': timestamp,
      'is_read': isRead,
      'sender_name': senderName,
      'sender_profile_url': senderProfileUrl,
      'post_id': postId,
      'post_name': postName,
      'comment_id': commentId,
      if (id != null) 'id': id,
      if (followRequestStatus != null) 'follow_request_status': followRequestStatus,
      if (followId != null) 'follow_id': followId,
    };
  }

  static NotificationType _parseNotificationType(dynamic type) {
    if (type == null) return NotificationType.like;

    final typeStr = type.toString().toUpperCase();

    switch (typeStr) {
      case 'LIKE':
        return NotificationType.like;
      case 'COMMENT':
        return NotificationType.comment;
      case 'FOLLOW_REQUEST':
      case 'FOLLOW':
        return NotificationType.followRequest;
      default:
        return NotificationType.like;
    }
  }

  NotificationModel copyWith({
    String? senderId,
    String? receiverId,
    NotificationType? notificationType,
    String? content,
    int? timestamp,
    bool? isRead,
    String? senderName,
    String? senderProfileUrl,
    String? postId,
    String? postName,
    String? commentId,
    String? id,
    String? followRequestStatus,
    int? followId,
  }) {
    return NotificationModel(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      notificationType: notificationType ?? this.notificationType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      senderName: senderName ?? this.senderName,
      senderProfileUrl: senderProfileUrl ?? this.senderProfileUrl,
      postId: postId ?? this.postId,
      postName: postName ?? this.postName,
      commentId: commentId ?? this.commentId,
      id: id ?? this.id,
      followRequestStatus: followRequestStatus ?? this.followRequestStatus,
      followId: followId ?? this.followId,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final notificationTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(notificationTime);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w';
    } else {
      return '${(difference.inDays / 30).floor()}mo';
    }
  }

  String get message {
    if (content != null && content!.isNotEmpty) {
      return content!;
    }

    switch (notificationType) {
      case NotificationType.like:
        return postName != null ? 'liked your photo from $postName' : 'liked your post';
      case NotificationType.comment:
        return 'commented on your post';
      case NotificationType.followRequest:
        if (followRequestStatus == 'accepted') {
          return 'accepted your follow request';
        } else if (followRequestStatus == 'rejected') {
          return 'rejected your follow request';
        }
        return 'sent you a follow request';
    }
  }

  String get typeString {
    switch (notificationType) {
      case NotificationType.like:
        return 'like';
      case NotificationType.comment:
        return 'comment';
      case NotificationType.followRequest:
        return 'follow';
    }
  }
}

enum NotificationType {
  like,
  comment,
  followRequest,
}
