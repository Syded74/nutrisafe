import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nutrisafe/services/api_service.dart';
import 'package:nutrisafe/models/nutrition_data.dart';

void main() {
  test('ApiService.baseUrl strips trailing slashes', () {
    expect(ApiService.baseUrl.endsWith('/'), isFalse);
  });

  test('Endpoint URLs are generated correctly', () {
    final base = ApiService.baseUrl;
    expect(Uri.parse('$base/predict').toString(), '$base/predict');
    expect(Uri.parse('$base/batch-predict').toString(), '$base/batch-predict');
    expect(Uri.parse('$base/health').toString(), '$base/health');
  });

  test('predictNutrition surfaces backend error message', () async {
    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode({'error': 'Bad Request', 'details': 'Invalid data'}),
        400,
      );
    });

    final data = NutritionData(
      caloricValue: 0,
      fat: 0,
      saturatedFat: 0,
      sugars: 0,
      sodium: 0,
      protein: 0,
      vitaminA: 0,
      vitaminC: 0,
      iron: 0,
      calcium: 0,
    );

    expect(
      () => ApiService.predictNutrition(data, client: mockClient),
      throwsA(predicate((e) =>
          e.toString().contains('Bad Request') &&
          e.toString().contains('Invalid data'))),
    );
  });
}
