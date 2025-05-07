import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/mail_mdl.dart';

class MailApiService {
  static Future<List<MailModel>> fetchReceivedMails({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
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

  static Future<bool> sendMail(String subject, String message) async {
    try {
      await ApiConfig.dio.post(
        ApiConstants.postMail,
        data: {'subject': subject, 'message': message},
      );
      return true;
    } on DioException catch (e) {
      print('Error sending mail: ${e.response?.data}');
      return false;
    }
  }

  static Future<bool> readMail(int mailId) async {
    try {
      await ApiConfig.dio.patch(ApiConstants.readMail(mailId));
      return true;
    } on DioException catch (e) {
      print('Error marking mail as read: ${e.response?.data}');
      return false;
    }
  }

  static Future<bool> deleteMail(int mailId) async {
    try {
      await ApiConfig.dio.delete(ApiConstants.deleteMail(mailId));
      return true;
    } on DioException catch (e) {
      print('Error deleting mail: ${e.response?.data}');
      return false;
    }
  }

  static Future<bool> deleteAllMail() async {
    try {
      await ApiConfig.dio.delete(ApiConstants.deleteAllMail);
      return true;
    } on DioException catch (e) {
      print('Error deleting all mails: ${e.response?.data}');
      return false;
    }
  }
}
