class TaskModel {
  final int id;
  final String title;
  final String? description;
  final String type; // "custom" or "system"
  final String? recurrenceInterval; // system only
  final String? dueDate; // custom only
  final bool completed;

  const TaskModel({
    required this.id,
    required this.title,
    required this.type,
    required this.completed,
    this.description,
    this.recurrenceInterval,
    this.dueDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      recurrenceInterval: json['recurrenceInterval'],
      dueDate: json['dueDate'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'recurrenceInterval': recurrenceInterval,
      'dueDate': dueDate,
      'completed': completed,
    };
  }

  bool get isSystemTask => type == 'system';
  bool get isCustomTask => type == 'custom';
}
