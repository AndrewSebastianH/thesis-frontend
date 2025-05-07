import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';

class AuthService {
  static Future<ResponseResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiConfig.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return ResponseResult(
        success: true,
        data: response.data,
        message: response.data['message'] ?? 'Login successful',
      );
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
        ApiConstants.signup,
        data: {'username': username, 'email': email, 'password': password},
      );
      return ResponseResult(success: true, data: response.data);
    } on DioException catch (e) {
      final dynamic errorData = e.response?.data;

      String? extractedMessage;

      if (errorData is Map<String, dynamic>) {
        final message = errorData['message'];
        if (message is List &&
            message.isNotEmpty &&
            message.first['msg'] != null) {
          extractedMessage = message.first['msg']; // Take the first message
        } else if (message is String) {
          extractedMessage = message;
        }
      }

      return ResponseResult(
        success: false,
        message: extractedMessage ?? 'Signup failed',
      );
    }
  }

  static Future<ResponseResult> getConnectionCode() async {
    try {
      final response = await ApiConfig.dio.get(
        ApiConstants.getUserConnectionCode,
      );
      return ResponseResult(
        success: true,
        data: response.data,
        message: response.data['message'] ?? 'Code fetched successfully',
      );
    } on DioException catch (e) {
      print("Error fetching connection code: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to fetch code',
      );
    }
  }

  static Future<ResponseResult> findUserByConnectionCode({
    required String connectionCode,
  }) async {
    try {
      final response = await ApiConfig.dio.post(
        ApiConstants.findUser,
        data: {'connectionCode': connectionCode},
      );
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'User found successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      print("Finding user failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Logout failed',
      );
    }
  }

  static Future<ResponseResult> getUserFullInfo() async {
    try {
      final response = await ApiConfig.dio.get(ApiConstants.getUserFullInfo);
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'User info fetched successfully',
        data: response.data,
      );
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
        ApiConstants.chooseRole,
        data: {'role': role},
      );
      return ResponseResult(
        success: true,
        data: response.data,
        message: response.data['message'] ?? 'Role updated successfully',
      );
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
        ApiConstants.connectUser,
        data: {'connectionCode': code},
      );
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'Accounts linked successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      print("Linking accounts failed: ${e.response?.data}");
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to link accounts',
      );
    }
  }
}
