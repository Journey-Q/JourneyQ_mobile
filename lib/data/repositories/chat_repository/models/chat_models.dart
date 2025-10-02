// Instagram-like Chat Models with full profile support

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderProfileUrl;
  final String content;
  final int timestamp;
  final String messageType;
  final Map<String, bool>? readBy;
  final bool? delivered;
  final String? replyTo;
  final bool? edited;
  final int? editedTimestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderProfileUrl,
    required this.content,
    required this.timestamp,
    this.messageType = 'text',
    this.readBy,
    this.delivered,
    this.replyTo,
    this.edited,
    this.editedTimestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName']?.toString() ?? 'Unknown User',
      senderProfileUrl: json['senderProfileUrl']?.toString(),
      content: json['content']?.toString() ?? '',
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      messageType: json['messageType']?.toString() ?? 'text',
      readBy: json['readBy'] != null ? Map<String, bool>.from(json['readBy']) : null,
      delivered: json['delivered'],
      replyTo: json['replyTo']?.toString(),
      edited: json['edited'],
      editedTimestamp: json['editedTimestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfileUrl': senderProfileUrl,
      'content': content,
      'timestamp': timestamp,
      'messageType': messageType,
      'readBy': readBy,
      'delivered': delivered,
      'replyTo': replyTo,
      'edited': edited,
      'editedTimestamp': editedTimestamp,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderProfileUrl,
    String? content,
    int? timestamp,
    String? messageType,
    Map<String, bool>? readBy,
    bool? delivered,
    String? replyTo,
    bool? edited,
    int? editedTimestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderProfileUrl: senderProfileUrl ?? this.senderProfileUrl,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      readBy: readBy ?? this.readBy,
      delivered: delivered ?? this.delivered,
      replyTo: replyTo ?? this.replyTo,
      edited: edited ?? this.edited,
      editedTimestamp: editedTimestamp ?? this.editedTimestamp,
    );
  }
}

// Instagram-style user profile for chat
class UserProfile {
  final String userId;
  final String username;
  final String displayName;
  final String? profileUrl;
  final String? email;
  final bool isOnline;
  final int lastSeen;
  final int createdAt;
  final int updatedAt;

  UserProfile({
    required this.userId,
    required this.username,
    required this.displayName,
    this.profileUrl,
    this.email,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? json['username']?.toString() ?? 'Unknown User',
      profileUrl: json['profileUrl']?.toString(),
      email: json['email']?.toString(),
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] ?? DateTime.now().millisecondsSinceEpoch,
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'profileUrl': profileUrl,
      'email': email,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Convert to chat participant format
  Map<String, dynamic> toParticipantJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'profileUrl': profileUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}

// Instagram-style chat model with full profile info
class InstagramChat {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserProfileUrl;
  final ChatMessage? lastMessage;
  final int? lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final int? lastSeen;
  final int createdAt;

  InstagramChat({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserProfileUrl,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    this.lastSeen,
    required this.createdAt,
  });

  factory InstagramChat.fromJson(Map<String, dynamic> json) {
    return InstagramChat(
      chatId: json['chatId']?.toString() ?? '',
      otherUserId: json['otherUserId']?.toString() ?? '',
      otherUserName: json['otherUserName']?.toString() ?? 'Unknown User',
      otherUserProfileUrl: json['otherUserProfileUrl']?.toString(),
      lastMessage: json['lastMessage'] != null ? ChatMessage.fromJson(json['lastMessage']) : null,
      lastMessageTime: json['lastMessageTime'],
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'],
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserProfileUrl': otherUserProfileUrl,
      'lastMessage': lastMessage?.toJson(),
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
    };
  }

  // Create a copy with updated values
  InstagramChat copyWith({
    String? chatId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserProfileUrl,
    ChatMessage? lastMessage,
    int? lastMessageTime,
    int? unreadCount,
    bool? isOnline,
    int? lastSeen,
    int? createdAt,
  }) {
    return InstagramChat(
      chatId: chatId ?? this.chatId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserProfileUrl: otherUserProfileUrl ?? this.otherUserProfileUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Legacy models for compatibility
class ChatParticipant {
  final String userId;
  final String name;
  final String? profileUrl;
  final bool isOnline;
  final int lastSeen;

  ChatParticipant({
    required this.userId,
    required this.name,
    this.profileUrl,
    required this.isOnline,
    required this.lastSeen,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? json['displayName']?.toString() ?? json['username']?.toString() ?? 'Unknown User',
      profileUrl: json['profileUrl']?.toString(),
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}

class IndividualChat {
  final String chatId;
  final Map<String, ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final int? lastMessageTime;
  final Map<String, int>? unreadCounts;
  final int createdAt;
  final Map<String, dynamic>? metadata;

  IndividualChat({
    required this.chatId,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCounts,
    required this.createdAt,
    this.metadata,
  });

  factory IndividualChat.fromJson(Map<String, dynamic> json) {
    return IndividualChat(
      chatId: json['chatId']?.toString() ?? '',
      participants: json['participants'] != null 
          ? Map<String, ChatParticipant>.from(
              (json['participants'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(), 
                  ChatParticipant.fromJson(Map<String, dynamic>.from(value))
                ),
              ),
            )
          : {},
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage']) 
          : null,
      lastMessageTime: json['lastMessageTime'],
      unreadCounts: json['unreadCounts'] != null 
          ? Map<String, int>.from(json['unreadCounts'])
          : null,
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'participants': participants.map((key, value) => MapEntry(key, value.toJson())),
      'lastMessage': lastMessage?.toJson(),
      'lastMessageTime': lastMessageTime,
      'unreadCounts': unreadCounts,
      'createdAt': createdAt,
      'metadata': metadata,
    };
  }
  
  // Helper method to get other participant
  ChatParticipant? getOtherParticipant(String currentUserId) {
    return participants.values.firstWhere(
      (participant) => participant.userId != currentUserId,
      orElse: () => participants.values.first,
    );
  }
}

class MessageRequest {
  final String senderId;
  final String senderName;
  final String? senderProfileUrl;
  final String content;
  final String recipientId;
  final String? messageType;
  final String? replyTo;

  MessageRequest({
    required this.senderId,
    required this.senderName,
    this.senderProfileUrl,
    required this.content,
    required this.recipientId,
    this.messageType,
    this.replyTo,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'recipientId': recipientId,
    };
    
    if (senderProfileUrl != null) json['senderProfileUrl'] = senderProfileUrl!;
    if (messageType != null) json['messageType'] = messageType!;
    if (replyTo != null) json['replyTo'] = replyTo!;
    
    return json;
  }

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName']?.toString() ?? 'Unknown User',
      senderProfileUrl: json['senderProfileUrl']?.toString(),
      content: json['content']?.toString() ?? '',
      recipientId: json['recipientId']?.toString() ?? '',
      messageType: json['messageType']?.toString(),
      replyTo: json['replyTo']?.toString(),
    );
  }

  MessageRequest copyWith({
    String? senderId,
    String? senderName,
    String? senderProfileUrl,
    String? content,
    String? recipientId,
    String? messageType,
    String? replyTo,
  }) {
    return MessageRequest(
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderProfileUrl: senderProfileUrl ?? this.senderProfileUrl,
      content: content ?? this.content,
      recipientId: recipientId ?? this.recipientId,
      messageType: messageType ?? this.messageType,
      replyTo: replyTo ?? this.replyTo,
    );
  }

  @override
  String toString() {
    return 'MessageRequest(senderId: $senderId, content: $content, recipientId: $recipientId, messageType: $messageType, replyTo: $replyTo)';
  }
}

class GetAllChatResponse {
  final List<IndividualChat> individualChats;
  final String userId;
  final int totalChats;

  GetAllChatResponse({
    required this.individualChats,
    required this.userId,
    required this.totalChats,
  });

  factory GetAllChatResponse.fromJson(Map<String, dynamic> json) {
    return GetAllChatResponse(
      individualChats: json['individualChats'] != null
          ? (json['individualChats'] as List)
              .map((chat) => IndividualChat.fromJson(chat))
              .toList()
          : [],
      userId: json['userId']?.toString() ?? '',
      totalChats: json['totalChats'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'individualChats': individualChats.map((chat) => chat.toJson()).toList(),
      'userId': userId,
      'totalChats': totalChats,
    };
  }
}

class GetChatResponse {
  final String chatId;
  final String chatType;
  final Map<String, bool>? participants;
  final ChatMessage? lastMessage;
  final List<ChatMessage> messages;

  GetChatResponse({
    required this.chatId,
    required this.chatType,
    this.participants,
    this.lastMessage,
    required this.messages,
  });

  factory GetChatResponse.fromJson(Map<String, dynamic> json) {
    return GetChatResponse(
      chatId: json['chatId']?.toString() ?? '',
      chatType: json['chatType']?.toString() ?? 'individual',
      participants: json['participants'] != null 
          ? Map<String, bool>.from(json['participants']) 
          : null,
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage']) 
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((msg) => ChatMessage.fromJson(msg))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'chatType': chatType,
      'participants': participants,
      'lastMessage': lastMessage?.toJson(),
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }
}

class TypingStatus {
  final String chatId;
  final String userId;
  final bool isTyping;
  final int timestamp;

  TypingStatus({
    required this.chatId,
    required this.userId,
    required this.isTyping,
    required this.timestamp,
  });

  factory TypingStatus.fromJson(Map<String, dynamic> json) {
    return TypingStatus(
      chatId: json['chatId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      isTyping: json['isTyping'] ?? false,
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'userId': userId,
      'isTyping': isTyping,
      'timestamp': timestamp,
    };
  }
}

class UserStatus {
  final String userId;
  final bool isOnline;
  final int lastSeen;
  final String? status;

  UserStatus({
    required this.userId,
    required this.isOnline,
    required this.lastSeen,
    this.status,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      userId: json['userId']?.toString() ?? '',
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] ?? DateTime.now().millisecondsSinceEpoch,
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'status': status,
    };
  }
}