import 'dart:async';
// import 'package:intl/intl.dart';
import '../models/tasks_mdl.dart';
// import 'package:thesis_frontend/config/api_config.dart';
// import 'package:dio/dio.dart';

class TaskService {
  static Future<List<TaskModel>> fetchTasks() async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // simulate API delay

    const mockApiResponse = {
      "systemTasks": [
        {
          "id": 1,
          "title": "Daily Journal",
          "description": "Write a journal entry",
          "type": "system",
          "recurrenceInterval": "daily",
          "completed": false,
        },
        {
          "id": 2,
          "title": "Weekly Reflection",
          "description": "Reflect on your week",
          "type": "system",
          "recurrenceInterval": "weekly",
          "completed": false,
        },
      ],
      "customTasks": [
        {
          "id": 101,
          "title": "Call Mama Bear",
          "description": "Check in about her day",
          "type": "custom",
          "dueDate": "2025-04-23",
          "recurrenceInterval": null,
          "completed": false,
        },
        {
          "id": 102,
          "title": "Make Tea",
          "description": "",
          "type": "custom",
          "dueDate": "2025-04-24",
          "recurrenceInterval": null,
          "completed": false,
        },
      ],
    };

    final systemTasks =
        (mockApiResponse['systemTasks'] as List)
            .map((json) => TaskModel.fromJson(json))
            .toList();

    final customTasks =
        (mockApiResponse['customTasks'] as List)
            .map((json) => TaskModel.fromJson(json))
            .toList();

    return [...systemTasks, ...customTasks];
  }

  // Create custom task
  // static Future<String?> createCustomTask(
  //   String title,
  //   String? description,
  //   bool isRecurring,
  //   DateTime dueDate,
  //   String recurrenceInterval,
  // ) async {
  //   try {
  //     final formattedDueDate = DateFormat('yyyy-MM-dd').format(dueDate);
  //     final response = await ApiConfig.dio.post(
  //       '/tasks/user/create',
  //       data: {
  //         'title': title,
  //         'description': description,
  //         'isRecurring': isRecurring,
  //         'dueDate': formattedDueDate,
  //         'recurrenceInterval': recurrenceInterval,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data;
  //     }

  //     return null;
  //   } on DioException catch (e) {
  //     print("Login failed: ${e.response?.data}");
  //     return null;
  //   }
  // }

  // Mock complete functions
  static Future<void> completeCustomTask(int taskId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print("Custom Task $taskId completed!");
  }

  static Future<void> completeSystemTask(int taskId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print("System Task $taskId completed!");
  }
}
