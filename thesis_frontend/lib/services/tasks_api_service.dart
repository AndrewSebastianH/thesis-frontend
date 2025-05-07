import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/tasks_mdl.dart';

class TaskService {
  static Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await ApiConfig.dio.get(ApiConstants.getUserTasks);
      final systemTasks =
          (response.data['systemTasks'] as List)
              .map((json) => TaskModel.fromJson(json))
              .toList();

      final customTasks =
          (response.data['customTasks'] as List)
              .map((json) => TaskModel.fromJson(json))
              .toList();

      return [...systemTasks, ...customTasks];
    } on DioException catch (e) {
      print("Error fetching tasks: ${e.response?.data}");
      return [];
    }
  }

  static Future<bool> createCustomTask({
    required String title,
    String? description,
    required DateTime dueDate,
    bool isRecurring = false,
    String recurrenceInterval = '',
  }) async {
    try {
      final formattedDueDate = DateFormat('yyyy-MM-dd').format(dueDate);
      await ApiConfig.dio.post(
        ApiConstants.createCustomTask,
        data: {
          'title': title,
          'description': description,
          'dueDate': formattedDueDate,
          'isRecurring': isRecurring,
          'recurrenceInterval': recurrenceInterval,
        },
      );
      return true;
    } on DioException catch (e) {
      print("Error creating custom task: ${e.response?.data}");
      return false;
    }
  }

  static Future<bool> completeCustomTask(String taskId) async {
    try {
      await ApiConfig.dio.patch(
        ApiConstants.completeCustomTask(taskId.toString()),
      );
      return true;
    } on DioException catch (e) {
      print("Error completing custom task: ${e.response?.data}");
      return false;
    }
  }

  static Future<bool> completeSystemTask(String taskId) async {
    try {
      await ApiConfig.dio.patch(
        ApiConstants.completeSystemTask(taskId.toString()),
      );
      return true;
    } on DioException catch (e) {
      print("Error completing system task: ${e.response?.data}");
      return false;
    }
  }
}
