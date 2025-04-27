// models/insight_mdl.dart
class InsightModel {
  final List<TaskInsight> customTasks;
  final List<TaskInsight> systemTasks;
  final EmotionSummary emotions;

  InsightModel({
    required this.customTasks,
    required this.systemTasks,
    required this.emotions,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      customTasks:
          (json['tasks']['custom'] as List)
              .map((e) => TaskInsight.fromJson(e))
              .toList(),
      systemTasks:
          (json['tasks']['system'] as List)
              .map((e) => TaskInsight.fromJson(e))
              .toList(),
      emotions: EmotionSummary.fromJson(json['emotions']),
    );
  }
}

class TaskInsight {
  final String taskId;
  final String title;
  final int completedTimes;

  TaskInsight({
    required this.taskId,
    required this.title,
    required this.completedTimes,
  });

  factory TaskInsight.fromJson(Map<String, dynamic> json) {
    return TaskInsight(
      taskId: json['taskId'],
      title: json['title'],
      completedTimes: json['completedTimes'],
    );
  }
}

class EmotionSummary {
  final int happy;
  final int neutral;
  final int sad;
  final String mostCommonEmotion;
  final String? lastEmotionDate;

  EmotionSummary({
    required this.happy,
    required this.neutral,
    required this.sad,
    required this.mostCommonEmotion,
    this.lastEmotionDate,
  });

  factory EmotionSummary.fromJson(Map<String, dynamic> json) {
    return EmotionSummary(
      happy: json['happy'] ?? 0,
      neutral: json['neutral'] ?? 0,
      sad: json['sad'] ?? 0,
      mostCommonEmotion: json['mostCommonEmotion'] ?? 'neutral',
      lastEmotionDate: json['lastEmotionDate'],
    );
  }
}
