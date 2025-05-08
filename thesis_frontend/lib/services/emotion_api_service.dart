import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/emotion_log_mdl.dart';
import 'package:dio/dio.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';

class EmotionService {
  static Future<ResponseResult> submitEmotion({
    required String emotion,
    String? detail,
    required String date,
  }) async {
    try {
      final response = await ApiConfig.dio.post(
        ApiConstants.postEmotionLog,
        data: {'date': date, 'emotion': emotion, 'detail': detail},
      );

      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'Emotion logged successfully',
      );
    } on DioException catch (e) {
      print("Error logging emotion: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to log emotion',
      );
    }
  }

  static Future<List<EmotionLog>> fetchEmotionLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await ApiConfig.dio.get(
        ApiConstants.getEmotionLog,
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final userMap = response.data['user'] as Map<String, dynamic>?;
      final relativeMap = response.data['relative'] as Map<String, dynamic>?;

      final int userId = userMap?['id'] as int? ?? -1;
      final int relativeId = relativeMap?['id'] as int? ?? -1;

      final userLogs = (userMap?['logs'] as List<dynamic>? ?? []).map((log) {
        return EmotionLog(
          date: DateTime.parse(log['date']),
          emotion: log['emotion'],
          userId: userId,
          detail: log['detail'] ?? '',
        );
      });

      final relativeLogs = (relativeMap?['logs'] as List<dynamic>? ?? []).map((
        log,
      ) {
        return EmotionLog(
          date: DateTime.parse(log['date']),
          emotion: log['emotion'],
          userId: relativeId,
          detail: log['detail'] ?? '',
        );
      });

      return [...userLogs, ...relativeLogs];
    } on DioException catch (e) {
      print("Error fetching emotion logs: ${e.response?.data}");
      return [];
    }
  }
}
