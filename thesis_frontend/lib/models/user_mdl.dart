class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? relatedUserId;
  final int expPoints;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.relatedUserId,
    required this.expPoints,
  });

  factory UserModel.fromJwt(Map<String, dynamic> jwt) {
    return UserModel(
      id: jwt['id'].toString(),
      username: jwt['username'],
      email: jwt['email'],
      role: jwt['role'],
      relatedUserId: jwt['relatedUserId']?.toString(),
      expPoints: jwt['expPoints'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role': role,
    'relatedUserId': relatedUserId,
    'expPoints': expPoints,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    role: json['role'],
    relatedUserId: json['relatedUserId'],
    expPoints: json['expPoints'],
  );
}
