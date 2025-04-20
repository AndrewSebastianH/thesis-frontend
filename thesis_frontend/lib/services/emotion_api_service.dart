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
  //   final url = Uri.parse('${ApiConfig.baseUrl}/mood');
  //   final headers = await ApiConfig.getAuthHeaders();

  //   final response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     final List jsonData = jsonDecode(response.body);
  //     return jsonData.map((e) => EmotionLog.fromJson(e)).toList();
  //   } else {
  //     print("Failed to fetch mood logs: ${response.body}");
  //     return [];
  //   }
  // }

  static Future<List<EmotionLog>> fetchEmotionLogs() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      EmotionLog(
        date: DateTime.utc(2025, 4, 14),
        emotion: 'happy',
        userId: '1',
      ),
      EmotionLog(
        date: DateTime.utc(2025, 4, 14),
        emotion: 'neutral',
        userId: '2',
      ),
      EmotionLog(date: DateTime.utc(2025, 4, 13), emotion: 'sad', userId: '1'),
      EmotionLog(
        date: DateTime.utc(2025, 4, 13),
        emotion: 'happy',
        userId: '3',
      ),
      EmotionLog(date: DateTime.utc(2025, 4, 12), emotion: 'sad', userId: '2'),
      EmotionLog(
        date: DateTime.utc(2025, 4, 11),
        emotion: 'neutral',
        userId: '1',
      ),
      EmotionLog(
        date: DateTime.utc(2025, 4, 10),
        emotion: 'happy',
        userId: '3',
      ),
    ];
  }
}
