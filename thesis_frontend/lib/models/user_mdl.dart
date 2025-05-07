class UserModel {
  final int id;
  final String username;
  final String email;
  final String? role;
  final int? relatedUserId;
  final int expPoints;
  final int? avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.role,
    this.relatedUserId,
    required this.expPoints,
    this.avatar,
  });

  factory UserModel.fromJwt(Map<String, dynamic> jwt) {
    return UserModel(
      id: jwt['id'],
      username: '',
      email: '',
      role: jwt['role'],
      relatedUserId: jwt['relatedUserId'],
      expPoints: 0,
      avatar: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role': role,
    'relatedUserId': relatedUserId,
    'expPoints': expPoints,
    'avatar': avatar,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    role: json['role'] as String?,
    relatedUserId: json['relatedUserId'],
    expPoints: json['expPoints'] ?? 0,
    avatar: json['avatar'],
  );
}
