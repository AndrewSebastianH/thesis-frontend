import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';

class AuthService {
  static Future<ResponseResult> login({
    required String email,
    required String password,
  }) async {
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

  static Future<ResponseResult> signup({
    required String username,
    required String email,
    required String password,
  }) async {
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

  static Future<ResponseResult> getUserFullInfo() async {
    try {
      final response = await ApiConfig.dio.get('/auth/user/full-info');
      return ResponseResult(success: true, data: response.data);
    } on DioException catch (e) {
      print("Error fetching user info: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to fetch user info',
      );
    }
  }

  static Future<ResponseResult> chooseRole({required String role}) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/role',
        data: {'role': role},
      );
      return ResponseResult(success: true, message: response.data);
    } on DioException catch (e) {
      print("Choosing role failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to choose role',
      );
    }
  }

  static Future<ResponseResult> linkAccounts({required String code}) async {
    try {
      final response = await ApiConfig.dio.post(
        '/auth/connect-users',
        data: {'connectionCode': code},
      );
      return ResponseResult(success: true, message: response.data);
    } on DioException catch (e) {
      print("Linking accounts failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to link accounts',
      );
    }
  }
}
