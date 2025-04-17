import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thesis_frontend/config/apiConfig.dart';

class MoodService {
  static Future<bool> submitMood(String mood) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/mood');
    final headers = await ApiConfig.getAuthHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'mood': mood}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Mood submission failed: ${response.body}");
      return false;
    }
  }
}
