import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';
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

      return [...customTasks, ...systemTasks];
    } on DioException catch (e) {
      print("Error fetching tasks: ${e.response?.data}");
      return [];
    }
  }

  static Future<ResponseResult> createCustomTask({
    required String title,
    String? description,
    DateTime? dueDate,
    bool isRecurring = false,
    String recurrenceInterval = '',
    bool assignToSelf = false,
  }) async {
    try {
      final formattedDueDate =
          dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate) : null;

      final data = {
        'title': title,
        if (description != null) 'description': description,
        if (!isRecurring) 'dueDate': formattedDueDate,
        'isRecurring': isRecurring,
        if (isRecurring) 'recurrenceInterval': recurrenceInterval,
        'assignToSelf': assignToSelf,
      };

      final response = await ApiConfig.dio.post(
        ApiConstants.createCustomTask,
        data: data,
      );

      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'Task created successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      print("Error creating custom task: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to create task',
      );
    }
  }

  static Future<bool> completeCustomTask(int taskId) async {
    try {
      await ApiConfig.dio.patch(ApiConstants.completeCustomTask(taskId));
      return true;
    } on DioException catch (e) {
      print("Error completing custom task: ${e.response?.data}");
      return false;
    }
  }

  static Future<bool> completeSystemTask(int taskId) async {
    try {
      await ApiConfig.dio.patch(ApiConstants.completeSystemTask(taskId));
      return true;
    } on DioException catch (e) {
      print("Error completing system task: ${e.response?.data}");
      return false;
    }
  }
}
