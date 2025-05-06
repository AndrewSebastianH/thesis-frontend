import 'package:thesis_frontend/config/api_config.dart';

class ApiConstants {
  // Auth
  static String get login => '${ApiConfig.baseUrl}/auth/login';
  static String get signup => '${ApiConfig.baseUrl}/auth/signup';
  static String get chooseRole => '${ApiConfig.baseUrl}/auth/role';
  static String get findUser => '${ApiConfig.baseUrl}/auth/find-user';
  static String get connectUser => '${ApiConfig.baseUrl}/auth/connect-user';
  static String get getUserFullInfo =>
      '${ApiConfig.baseUrl}/auth/user/full-info';
  static String get getUserConnectionCode =>
      '${ApiConfig.baseUrl}/auth/user/connection-code';

  static String get patchUserProfile =>
      '${ApiConfig.baseUrl}/auth/user/profile';

  // Emotion Logs
  static String get getEmotionLog => '${ApiConfig.baseUrl}/emotion-log/';
  static String get postEmotionLog => '${ApiConfig.baseUrl}/emotion-log/';

  // Mailing
  static String get postMail => '${ApiConfig.baseUrl}/mail/';
  static String get getReceivedMails => '${ApiConfig.baseUrl}/mail/received';
  static String get getSentMails => '${ApiConfig.baseUrl}/mail/sent';
  static String readMail(String mailId) =>
      '${ApiConfig.baseUrl}/mail/$mailId/read';
  static String deleteMail(String mailId) =>
      '${ApiConfig.baseUrl}/mail/$mailId';
  static String get deleteAllMail => '${ApiConfig.baseUrl}/mail/all';

  // Insights
  static String get getInsights => '${ApiConfig.baseUrl}/insight/';

  // Tasks
  static String get createCustomTask => '${ApiConfig.baseUrl}/task/user/create';
  static String get getUserTasks => '${ApiConfig.baseUrl}/task/user';
  static String completeCustomTask(String taskId) =>
      '${ApiConfig.baseUrl}/task/complete/custom/$taskId';
  static String completeSystemTask(String taskId) =>
      '${ApiConfig.baseUrl}/task/complete/system/$taskId';
}
