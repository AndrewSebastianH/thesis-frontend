import '../models/response_result_mdl.dart';

extension ResponseResultX on ResponseResult {
  T successOrThrow<T>() {
    if (success) {
      return data as T;
    } else {
      throw Exception(message ?? 'An unknown error occurred');
    }
  }
}
