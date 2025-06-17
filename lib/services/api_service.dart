import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_data.dart';
import '../config.dart';

class ApiService {
  /// Base URL for all API requests without trailing slashes.
  static final String baseUrl = AppConfig.apiBaseUrl;

  static Future<NutritionResult> predictNutrition(
    NutritionData data, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return NutritionResult.fromJson(jsonData);
      } else {
        String message = 'API Error: ${response.statusCode}';
        try {
          final body = jsonDecode(response.body);
          final parts = [body['error'], body['details']]
              .whereType<String>()
              .where((part) => part.isNotEmpty)
              .toList();
          if (parts.isNotEmpty) {
            message += ': ${parts.join(' - ')}';
          }
        } catch (_) {
          // Ignore JSON parse errors and use default message
        }
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  static Future<List<NutritionResult>> batchPredict(List<NutritionData> foods) async {
    try {
      final requestBody = {
        'foods': foods.map((food) => food.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/batch-predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final results = jsonData['batch_results'] as List;

        return results.map((result) => NutritionResult.fromJson(result)).toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  static Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}