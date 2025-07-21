class User {
  final int? userId;
  final String username;
  final String? password;
  final String email;
  final String? profileUrl;
  final String role;
  final DateTime createdAt;
  final bool isActive;
  final bool isPremium;
  final bool isTripFluence;

  User({
    this.userId,
    required this.username,
    this.password,
    required this.email,
    this.profileUrl,
    required this.role,
    required this.createdAt,
    required this.isActive,
    required this.isPremium,
    required this.isTripFluence,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    userId: json['userId'] is String ? int.tryParse(json['userId']) : json['userId'],
    username: json['username'].toString(),
    password: json['password']?.toString(),
    email: json['email'].toString(),
    profileUrl: json['profile_url']?.toString() ?? json['profileUrl']?.toString(),
    role: json['role'].toString(),
    createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
    isActive: json['is_active'] ?? json['isActive'] ?? true,
    isPremium: json['isPremium'] ?? false,
    isTripFluence: json['isTripFluence'] ?? false,
  );
}

static DateTime _parseDateTime(dynamic dateValue) {
  if (dateValue == null) return DateTime.now();
  
  try {
    if (dateValue is String) {
      return DateTime.parse(dateValue);
    } else if (dateValue is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateValue);
    }
    return DateTime.now();
  } catch (e) {
    return DateTime.now();
  }
}

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'email': email,
      'profile_url': profileUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
      'isPremium': isPremium,
      'isTripFluence': isTripFluence,
    };
  }
}