// lib/models/response_result.dart
class ResponseResult {
  final bool success;
  final String? message;
  final dynamic data;

  ResponseResult({required this.success, this.message, this.data});
}
