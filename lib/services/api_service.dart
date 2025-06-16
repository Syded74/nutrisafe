import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_data.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5001';

  static Future<NutritionResult> predictNutrition(NutritionData data) async {
    try {
      final response = await http.post(
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
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
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