import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thesis_frontend/config/apiConfig.dart';
import 'package:thesis_frontend/models/emotion_log_mdl.dart';

class EmotionService {
  // Log mood
  static Future<bool> submitEmotion(String emotion) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/mood');
    final headers = await ApiConfig.getAuthHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'emotion': emotion}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Mood submission failed: ${response.body}");
      return false;
    }
  }

  // // Fetch mood logs for the calendar
  // static Future<List<EmotionLog>> fetchEmotionLogs() async {
  //   final url = Uri.parse('${ApiConfig.baseUrl}/user/full-info');
  //   final headers = await ApiConfig.getAuthHeaders();

  //   final response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = jsonDecode(response.body);

  //     final userLogsJson = data['user']['logs'] as List<dynamic>;
  //     final relatedLogsJson = data['relatedUser']?['logs'] as List<dynamic>? ?? [];

  //     final userLogs = userLogsJson.map((e) {
  //       return EmotionLog.fromJson({
  //         ...e,
  //         'userId': data['user']['id'],
  //       });
  //     });

  //     final relatedLogs = relatedLogsJson.map((e) {
  //       return EmotionLog.fromJson({
  //         ...e,
  //         'userId': data['relatedUser']['id'],
  //       });
  //     });

  //     return [...userLogs, ...relatedLogs];
  //   } else {
  //     print("Failed to fetch emotion logs: ${response.body}");
  //     return [];
  //   }
  // }

  static Future<List<EmotionLog>> fetchEmotionLogs() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    // Simulated API response
    final data = {
      "user": {
        "id": 1,
        "username": "Bearl Benson",
        "logs": [
          {
            "date": "2025-04-14",
            "emotion": "happy",
            "detail": "Had fun playing with Mama today! 🐻",
          },
          {
            "date": "2025-04-13",
            "emotion": "sad",
            "detail":
                "I didn’t get to see Mama all day... I missed her a lot 😞",
          },
          {
            "date": "2025-04-11",
            "emotion": "neutral",
            "detail": "Just a regular day, nothing special happened.",
          },
        ],
      },
      "relative": {
        "id": 2,
        "username": "Mama Bear",
        "logs": [
          {
            "date": "2025-04-14",
            "emotion": "neutral",
            "detail":
                "Work was tiring, but I’m glad I saw Bearl smiling today.",
          },
          {
            "date": "2025-04-13",
            "emotion": "happy",
            "detail": "Bearl gave me a drawing and it made my whole day 💖",
          },
          {
            "date": "2025-04-12",
            "emotion": "sad",
            "detail": "I yelled earlier... I feel really guilty about it 😢",
          },
          {
            "date": "2025-04-10",
            "emotion": "happy",
            "detail":
                "We watched a movie together and cuddled. Perfect evening!",
          },
        ],
      },
    };

    final userMap = data['user'] as Map<String, dynamic>?;
    final relativeMap = data['relative'] as Map<String, dynamic>?;

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
  }
}
