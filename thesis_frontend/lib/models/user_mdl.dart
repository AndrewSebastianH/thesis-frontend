class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final int? relatedUserId;
  final int expPoints;
  final int? avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.relatedUserId,
    required this.expPoints,
    this.avatar,
  });

  factory UserModel.fromJwt(Map<String, dynamic> jwt) {
    return UserModel(
      id: jwt['id'],
      username: jwt['username'],
      email: jwt['email'],
      role: jwt['role'],
      relatedUserId: jwt['relatedUserId'],
      expPoints: jwt['expPoints'],
      avatar: jwt['avatar'],
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
    role: json['role'],
    relatedUserId: json['relatedUserId'],
    expPoints: json['expPoints'],
    avatar: json['avatar'],
  );
}
