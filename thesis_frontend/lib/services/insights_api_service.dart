import 'package:dio/dio.dart';
import 'package:thesis_frontend/config/api_config.dart';
import 'package:thesis_frontend/constants/api_endpoints_constants.dart';
import 'package:thesis_frontend/models/insights_mdl.dart';

class InsightApiService {
  static Future<InsightModel?> fetchInsight({
    required String type,
    required String range,
  }) async {
    try {
      print("Fetching insights with type: $type, range: $range");
      final response = await ApiConfig.dio.get(
        ApiConstants.getInsights,
        queryParameters: {'type': type, 'range': range},
      );

      return InsightModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error fetching insights: ${e.response?.data}');
      return null;
    }
  }
}
