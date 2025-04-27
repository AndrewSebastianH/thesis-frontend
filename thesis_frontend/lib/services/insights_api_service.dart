// services/insight_api_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:thesis_frontend/models/insights_mdl.dart';
// import 'package:dio/dio.dart';

class InsightApiService {
  static Future<InsightModel> fetchInsight(String type, String range) async {
    try {
      // In real use:
      // final response = await http.get(Uri.parse('https://yourapi.com/api/insight?type=$type'));

      // Mock data for now:
      final mockJson = {
        "tasks": {
          "custom": [
            {"taskId": "c1", "title": "Feed the Cat", "completedTimes": 5},
            {
              "taskId": "c2",
              "title": "Help with Homework",
              "completedTimes": 3,
            },
          ],
          "system": [
            {"taskId": "s1", "title": "Say Good Morning", "completedTimes": 15},
            {
              "taskId": "s2",
              "title": "Compliment Relative",
              "completedTimes": 7,
            },
          ],
        },
        "emotions": {
          "sad": 5,
          "neutral": 10,
          "happy": 20,
          "mostCommonEmotion": "happy",
          "lastEmotionDate": "2025-04-27",
        },
      };

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // If real API uncomment this:
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   return InsightModel.fromJson(data);
      // } else {
      //   throw Exception('Failed to load insights');
      // }

      // Using mock data
      return InsightModel.fromJson(mockJson);
    } catch (e) {
      throw Exception('Error fetching insights: $e');
    }
  }
}
