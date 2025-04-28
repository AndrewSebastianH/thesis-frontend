// import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/models/mail_mdl.dart';
// import 'package:dio/dio.dart';

class MailApiService {
  static Future<List<MailModel>> fetchReceivedMails() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network

    final response = {
      "total": 2,
      "mails": [
        {
          "id": "uuid-1",
          "senderId": 1,
          "receiverId": 2,
          "subject": "Hello!",
          "message": "Hope your day is nice today ☀️",
          "isRead": false,
          "createdAt":
              DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
        },
        {
          "id": "uuid-2",
          "senderId": 1,
          "receiverId": 2,
          "subject": "Good job!",
          "message": "I’m proud of you!",
          "isRead": true,
          "createdAt":
              DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String(),
        },
      ],
    };

    return (response['mails'] as List)
        .map((mail) => MailModel.fromJson(mail))
        .toList();
  }

  static Future<List<MailModel>> fetchSentMails() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final response = {
      "total": 3,
      "mails": [
        {
          "id": "uuid-3",
          "senderId": 2,
          "receiverId": 1,
          "subject": "Important",
          "message": "You mean the world to me 💛",
          "isRead": false,
          "createdAt":
              DateTime.now()
                  .subtract(const Duration(days: 3))
                  .toIso8601String(),
        },
        {
          "id": "uuid-4",
          "senderId": 2,
          "receiverId": 1,
          "subject": "Reminder",
          "message": "WASH THE DISHES NNNNOOOOOOOOOOW",
          "isRead": true,
          "createdAt":
              DateTime.now()
                  .subtract(const Duration(days: 3))
                  .toIso8601String(),
        },
        {
          "id": "uuid-5",
          "senderId": 2,
          "receiverId": 1,
          "subject": "Dor",
          "message": "Bagi duit dong mau jajan",
          "isRead": true,
          "createdAt":
              DateTime.now()
                  .subtract(const Duration(days: 3))
                  .toIso8601String(),
        },
      ],
    };

    return (response['mails'] as List)
        .map((mail) => MailModel.fromJson(mail))
        .toList();
  }

  static Future<bool> sendMail(String message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulate success
    return true;
  }

  static Future<bool> readMail(String mailId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simulate marking mail as read
    return true;
  }

  static Future<bool> deleteMail(String mailId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simulate deletion
    return true;
  }

  static Future<bool> deleteAllMail(String mailId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simulate deletion
    return true;
  }
}
