import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/mail_mdl.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';

class MailApiService {
  static Future<List<MailModel>> fetchReceivedMails({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      // print("Fetching received mails with offset: $offset, limit: $limit");
      final response = await ApiConfig.dio.get(
        ApiConstants.getReceivedMails,
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final mails = response.data['mails'] as List;
      return mails.map((mail) => MailModel.fromJson(mail)).toList();
    } on DioException catch (e) {
      print("Error fetching received mails: ${e.response?.data}");
      return [];
    }
  }

  static Future<List<MailModel>> fetchSentMails({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      // print("Fetching sent mails with offset: $offset, limit: $limit");

      final response = await ApiConfig.dio.get(
        ApiConstants.getSentMails,
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final mails = response.data['mails'] as List;
      return mails.map((mail) => MailModel.fromJson(mail)).toList();
    } on DioException catch (e) {
      print("Error fetching sent mails: ${e.response?.data}");
      return [];
    }
  }

  static Future<ResponseResult> sendMail({
    required String subject,
    required String message,
  }) async {
    try {
      final response = await ApiConfig.dio.post(
        ApiConstants.postMail,
        data: {'subject': subject, 'message': message},
      );
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'Mail sent successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      print('Error sending mail: ${e.response?.data}');
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to send mail',
      );
    }
  }

  static Future<ResponseResult> readMail(int mailId) async {
    try {
      final response = await ApiConfig.dio.patch(ApiConstants.readMail(mailId));
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'Mail marked as read',
      );
    } on DioException catch (e) {
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to mark as read',
      );
    }
  }

  static Future<ResponseResult> deleteMail(int mailId) async {
    try {
      final response = await ApiConfig.dio.delete(
        ApiConstants.deleteMail(mailId),
      );
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'Mail deleted successfully',
      );
    } on DioException catch (e) {
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to delete mail',
      );
    }
  }

  static Future<ResponseResult> deleteAllMail() async {
    try {
      final response = await ApiConfig.dio.delete(ApiConstants.deleteAllMail);
      return ResponseResult(
        success: true,
        message: response.data['message'] ?? 'All mails deleted successfully',
      );
    } on DioException catch (e) {
      return ResponseResult(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to delete all mails',
      );
    }
  }
}
