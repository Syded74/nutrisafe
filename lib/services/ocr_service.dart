import 'dart:io';
import '../models/nutrition_data.dart';

class OcrService {
  // Placeholder for Google ML Kit OCR integration
  static Future<String> extractTextFromImage(File imageFile) async {
    // TODO: Implement Google ML Kit Text Recognition
    // This is where you'll integrate:
    // - google_mlkit_text_recognition package
    // - Process the image file
    // - Extract text from nutrition labels

    await Future.delayed(const Duration(seconds: 1)); // Simulate processing

    // Return mock extracted text for now
    return '''
    Nutrition Facts
    Per 100g
    Energy: 250 kcal
    Fat: 12g
    Saturated Fat: 3g
    Sugars: 15g
    Sodium: 0.5g
    Protein: 8g
    Vitamin A: 20μg
    Vitamin C: 10mg
    Iron: 2mg
    Calcium: 100mg
    ''';
  }

  static NutritionData? parseNutritionText(String text) {
    // Simple text parsing logic
    // TODO: Implement more robust parsing with regex

    try {
      final lines = text.toLowerCase().split('\n');
      final values = <String, double>{};

      for (final line in lines) {
        // Parse common nutrition label formats
        if (line.contains('energy') || line.contains('calories')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['calories'] = double.parse(match.group(1)!);
        }

        if (line.contains('fat') && !line.contains('saturated')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['fat'] = double.parse(match.group(1)!);
        }

        if (line.contains('saturated')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['saturated_fat'] = double.parse(match.group(1)!);
        }

        if (line.contains('sugar')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['sugars'] = double.parse(match.group(1)!);
        }

        if (line.contains('sodium')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['sodium'] = double.parse(match.group(1)!);
        }

        if (line.contains('protein')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['protein'] = double.parse(match.group(1)!);
        }

        if (line.contains('vitamin a')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['vitamin_a'] = double.parse(match.group(1)!);
        }

        if (line.contains('vitamin c')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['vitamin_c'] = double.parse(match.group(1)!);
        }

        if (line.contains('iron')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['iron'] = double.parse(match.group(1)!);
        }

        if (line.contains('calcium')) {
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(line);
          if (match != null) values['calcium'] = double.parse(match.group(1)!);
        }
      }

      // Return parsed data if we have enough values
      if (values.length >= 5) {
        return NutritionData(
          caloricValue: values['calories'] ?? 0.0,
          fat: values['fat'] ?? 0.0,
          saturatedFat: values['saturated_fat'] ?? 0.0,
          sugars: values['sugars'] ?? 0.0,
          sodium: values['sodium'] ?? 0.0,
          protein: values['protein'] ?? 0.0,
          vitaminA: values['vitamin_a'] ?? 0.0,
          vitaminC: values['vitamin_c'] ?? 0.0,
          iron: values['iron'] ?? 0.0,
          calcium: values['calcium'] ?? 0.0,
        );
      }
    } catch (e) {
      print('Error parsing nutrition text: $e');
    }

    return null;
  }

  static Future<NutritionData?> processImage(File imageFile) async {
    try {
      // Extract text from image
      final extractedText = await extractTextFromImage(imageFile);

      // Parse nutrition data from text
      final nutritionData = parseNutritionText(extractedText);

      return nutritionData;
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }
}