class User {
  final String id;
  final String email;
  final String name;
  final String? username;
  final String? avatar;
  final String? bio;
  final bool isEmailVerified;
  final List<String>? roles;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.avatar,
    this.bio,
    this.isEmailVerified = false,
    this.roles,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      avatar: json['avatar'],
      bio: json['bio'],
      isEmailVerified: json['is_email_verified'] ?? false,
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'avatar': avatar,
      'bio': bio,
      'is_email_verified': isEmailVerified,
      'roles': roles,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool hasRole(String role) {
    return roles?.contains(role) ?? false;
  }

  bool hasAnyRole(List<String> requiredRoles) {
    if (roles == null) return false;
    return requiredRoles.any((role) => roles!.contains(role));
  }
}
