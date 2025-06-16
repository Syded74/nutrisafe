import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/nutrition_data.dart';

class ApiService {
  // Use proper host when running on an Android emulator. The '10.0.2.2'
  // address routes to the host machine from the Android emulator. Web,
  // iOS and desktop can keep using 'localhost'.
  static final String baseUrl = _resolveBaseUrl();

  static String _resolveBaseUrl() {
    if (kIsWeb) return 'http://localhost:5001';
    if (Platform.isAndroid) return 'http://10.0.2.2:5001';
    return 'http://localhost:5001';
  }

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