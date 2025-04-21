class EmotionLog {
  final DateTime date;
  final String emotion;
  final int userId;
  final String detail;

  EmotionLog({
    required this.date,
    required this.emotion,
    required this.userId,
    this.detail = '',
  });

  factory EmotionLog.fromJson(Map<String, dynamic> json) {
    return EmotionLog(
      date: DateTime.parse(json['date']),
      emotion: json['emotion'],
      userId: json['userId'],
      detail: json['detail'] ?? '',
    );
  }
}
