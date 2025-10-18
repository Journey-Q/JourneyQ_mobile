// Model classes for Joint Trip Group Chat Feature

/// Joint Trip Group Model
class JointTripGroup {
  final String groupId;
  final String groupName;
  final String? groupProfile;
  final int tripId;
  final int creatorId;
  final int createdAt;
  final int updatedAt;
  final Map<String, GroupMember> members;

  JointTripGroup({
    required this.groupId,
    required this.groupName,
    this.groupProfile,
    required this.tripId,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
  });

  /// Create from Firebase data
  factory JointTripGroup.fromMap(Map<String, dynamic> map) {
    final membersData = map['members'] as Map<dynamic, dynamic>? ?? {};
    final members = <String, GroupMember>{};

    membersData.forEach((key, value) {
      if (value is Map) {
        members[key.toString()] =
            GroupMember.fromMap(Map<String, dynamic>.from(value));
      }
    });

    return JointTripGroup(
      groupId: map['groupId']?.toString() ?? '',
      groupName: map['groupName']?.toString() ?? '',
      groupProfile: map['groupProfile']?.toString(),
      tripId: map['tripId'] as int? ?? 0,
      creatorId: map['creatorId'] as int? ?? 0,
      createdAt: map['createdAt'] as int? ?? 0,
      updatedAt: map['updatedAt'] as int? ?? 0,
      members: members,
    );
  }

  /// Convert to Firebase format
  Map<String, dynamic> toMap() {
    final membersMap = <String, dynamic>{};
    members.forEach((key, value) {
      membersMap[key] = value.toMap();
    });

    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupProfile': groupProfile,
      'tripId': tripId,
      'creatorId': creatorId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'members': membersMap,
    };
  }

  /// Get list of members
  List<GroupMember> get membersList => members.values.toList();

  /// Check if user is creator
  bool isCreator(int userId) => creatorId == userId;

  /// Check if user is member
  bool isMember(int userId) => members.containsKey(userId.toString());

  /// Get member count
  int get memberCount => members.length;

  /// Get creator member data
  GroupMember? get creator => members[creatorId.toString()];

  /// Copy with method
  JointTripGroup copyWith({
    String? groupId,
    String? groupName,
    String? groupProfile,
    int? tripId,
    int? creatorId,
    int? createdAt,
    int? updatedAt,
    Map<String, GroupMember>? members,
  }) {
    return JointTripGroup(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      groupProfile: groupProfile ?? this.groupProfile,
      tripId: tripId ?? this.tripId,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      members: members ?? this.members,
    );
  }
}

/// Group Member Model
class GroupMember {
  final int userId;
  final String userName;
  final String userAvatar;
  final int joinedAt;
  final String role; // 'creator' or 'member'

  GroupMember({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.joinedAt,
    required this.role,
  });

  /// Create from Firebase data
  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      userId: map['userId'] as int? ?? 0,
      userName: map['userName']?.toString() ?? '',
      userAvatar: map['userAvatar']?.toString() ?? '',
      joinedAt: map['joinedAt'] as int? ?? 0,
      role: map['role']?.toString() ?? 'member',
    );
  }

  /// Convert to Firebase format
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'joinedAt': joinedAt,
      'role': role,
    };
  }

  /// Check if member is creator
  bool get isCreator => role == 'creator';

  /// Get joined date
  DateTime get joinedDate => DateTime.fromMillisecondsSinceEpoch(joinedAt);

  /// Copy with method
  GroupMember copyWith({
    int? userId,
    String? userName,
    String? userAvatar,
    int? joinedAt,
    String? role,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      joinedAt: joinedAt ?? this.joinedAt,
      role: role ?? this.role,
    );
  }
}

/// Chat Message Model
class ChatMessage {
  final String messageId;
  final int senderId;
  final String senderName;
  final String senderAvatar;
  final String messageText;
  final String messageType; // 'text', 'image', 'location', 'file'
  final int timestamp;
  final String? attachmentUrl;
  final bool isDeleted;
  final int? deletedAt;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.messageText,
    required this.messageType,
    required this.timestamp,
    this.attachmentUrl,
    this.isDeleted = false,
    this.deletedAt,
  });

  /// Create from Firebase data
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId']?.toString() ?? '',
      senderId: map['senderId'] as int? ?? 0,
      senderName: map['senderName']?.toString() ?? '',
      senderAvatar: map['senderAvatar']?.toString() ?? '',
      messageText: map['messageText']?.toString() ?? '',
      messageType: map['messageType']?.toString() ?? 'text',
      timestamp: map['timestamp'] as int? ?? 0,
      attachmentUrl: map['attachmentUrl']?.toString(),
      isDeleted: map['isDeleted'] as bool? ?? false,
      deletedAt: map['deletedAt'] as int?,
    );
  }

  /// Convert to Firebase format
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'messageText': messageText,
      'messageType': messageType,
      'timestamp': timestamp,
      'attachmentUrl': attachmentUrl,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
    };
  }

  /// Get message date
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// Check if message has attachment
  bool get hasAttachment => attachmentUrl != null && attachmentUrl!.isNotEmpty;

  /// Check if message is image
  bool get isImage => messageType == 'image';

  /// Check if message is file
  bool get isFile => messageType == 'file';

  /// Check if message is location
  bool get isLocation => messageType == 'location';

  /// Check if message is text
  bool get isText => messageType == 'text';

  /// Get formatted time (HH:mm)
  String get formattedTime {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get formatted date (dd/MM/yyyy)
  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  /// Check if message is from today
  bool get isToday {
    final now = DateTime.now();
    final messageDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return now.year == messageDate.year &&
        now.month == messageDate.month &&
        now.day == messageDate.day;
  }

  /// Copy with method
  ChatMessage copyWith({
    String? messageId,
    int? senderId,
    String? senderName,
    String? senderAvatar,
    String? messageText,
    String? messageType,
    int? timestamp,
    String? attachmentUrl,
    bool? isDeleted,
    int? deletedAt,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      messageText: messageText ?? this.messageText,
      messageType: messageType ?? this.messageType,
      timestamp: timestamp ?? this.timestamp,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

/// Last Message Model
class LastMessage {
  final String text;
  final int senderId;
  final String senderName;
  final int timestamp;

  LastMessage({
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  /// Create from Firebase data
  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      text: map['text']?.toString() ?? '',
      senderId: map['senderId'] as int? ?? 0,
      senderName: map['senderName']?.toString() ?? '',
      timestamp: map['timestamp'] as int? ?? 0,
    );
  }

  /// Convert to Firebase format
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp,
    };
  }

  /// Get formatted time
  String get formattedTime {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day/$month';
    }
  }

  /// Get preview text (truncated)
  String get previewText {
    if (text.length > 50) {
      return '${text.substring(0, 50)}...';
    }
    return text;
  }

  /// Copy with method
  LastMessage copyWith({
    String? text,
    int? senderId,
    String? senderName,
    int? timestamp,
  }) {
    return LastMessage(
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Group Chat Info Model (combines group and last message)
class GroupChatInfo {
  final JointTripGroup group;
  final LastMessage? lastMessage;
  final int unreadCount;

  GroupChatInfo({
    required this.group,
    this.lastMessage,
    this.unreadCount = 0,
  });

  /// Check if user is creator
  bool isCreator(int userId) => group.isCreator(userId);

  /// Check if user is member
  bool isMember(int userId) => group.isMember(userId);

  /// Get member count
  int get memberCount => group.memberCount;

  /// Copy with method
  GroupChatInfo copyWith({
    JointTripGroup? group,
    LastMessage? lastMessage,
    int? unreadCount,
  }) {
    return GroupChatInfo(
      group: group ?? this.group,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Message Type Enum
enum MessageType {
  text,
  image,
  location,
  file;

  String get value {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.location:
        return 'location';
      case MessageType.file:
        return 'file';
    }
  }

  static MessageType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'location':
        return MessageType.location;
      case 'file':
        return MessageType.file;
      default:
        return MessageType.text;
    }
  }
}

/// Member Role Enum
enum MemberRole {
  creator,
  member;

  String get value {
    switch (this) {
      case MemberRole.creator:
        return 'creator';
      case MemberRole.member:
        return 'member';
    }
  }

  static MemberRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'creator':
        return MemberRole.creator;
      default:
        return MemberRole.member;
    }
  }
}
