// services/auth_api_service.dart
import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';

class AuthService {
  static Future<String?> login(String email, String password) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      }
      return null;
    } on DioException catch (e) {
      print("Login failed: ${e.response?.data}");
      return null;
    }
  }

  static Future<bool> signup(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/signup',
        data: {'username': username, 'email': email, 'password': password},
      );

      return response.statusCode == 201;
    } on DioException catch (e) {
      print("Signup failed: ${e.response?.data}");
      return false;
    }
  }
}
