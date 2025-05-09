class MailModel {
  final String id;
  final int senderId;
  final int receiverId;
  final String subject;
  final String message;
  bool isRead;
  final DateTime createdAt;

  MailModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.subject,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory MailModel.fromJson(Map<String, dynamic> json) {
    return MailModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      subject: json['subject'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'subject': subject,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
