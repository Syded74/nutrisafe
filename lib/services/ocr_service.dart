import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/nutrition_data.dart';

class OcrService {
  /// Extracts all text from the given [imageFile] using Google ML Kit's
  /// [TextRecognizer].
  static Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    return recognizedText.text;
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
      debugPrint('Error parsing nutrition text: $e');
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
      debugPrint('Error processing image: $e');
      return null;
    }
  }
}