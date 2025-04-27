import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';

class AuthService {
  static Future<ResponseResult> login(String email, String password) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return ResponseResult(success: true, data: response.data);
    } on DioException catch (e) {
      print("Login failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Login failed',
      );
    }
  }

  static Future<ResponseResult> signup(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/signup',
        data: {'username': username, 'email': email, 'password': password},
      );
      return ResponseResult(success: true, data: response.data);
    } on DioException catch (e) {
      print("Signup failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Signup failed',
      );
    }
  }

  static Future<ResponseResult> getConnectionCode() async {
    try {
      // final response = await ApiConfig.dio.get('/auth/user/connection-code');
      return ResponseResult(
        success: true,
        // data: response.data['code'],
        data: {'code': '123456'}, // Mocked data for testing
      );
    } on DioException catch (e) {
      print("Error fetching connection code: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to fetch code',
      );
    }
  }

  static Future<ResponseResult> linkAccounts(String code) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/connect-users',
        data: {'connectionCode': code},
      );
      return ResponseResult(success: true, message: response.data['message']);
    } on DioException catch (e) {
      print("Linking accounts failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to link accounts',
      );
    }
  }
}
