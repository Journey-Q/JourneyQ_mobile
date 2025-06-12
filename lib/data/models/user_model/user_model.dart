class User {
  final String id;
  final String email;
  final String name;
  final String? username;
  final String? avatar;
  final String? role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.avatar,
    this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      avatar: json['avatar'],
      role: json['role'],
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
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

}
