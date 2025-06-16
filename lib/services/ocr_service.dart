import 'dart:io';
import 'dart:developer';

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
    // Uses regular expressions to extract numeric values for common nutrients.

    double? _parseValue(String line, List<String> labels) {
      final joined = labels.map(RegExp.escape).join("|");
      final regex = RegExp("(?:" + joined + ")[^0-9]*(\\d+(?:\\.\\d+)?)", caseSensitive: false);
      final match = regex.firstMatch(line);
      return match != null ? double.tryParse(match.group(1)!) : null;
    }

    try {
      final lines = text.toLowerCase().split('\n');
      final values = <String, double>{};

      for (final line in lines) {
        final calories = _parseValue(line, ["energy", "calories", "kcal"]);
        if (calories != null) values["calories"] = calories;

        final fat = _parseValue(line, ["fat"]);
        if (fat != null && !line.contains("saturated")) values["fat"] = fat;

        final saturated = _parseValue(line, ["saturated"]);
        if (saturated != null) values["saturated_fat"] = saturated;

        final sugar = _parseValue(line, ["sugar"]);
        if (sugar != null) values["sugars"] = sugar;

        final sodium = _parseValue(line, ["sodium", "salt"]);
        if (sodium != null) values["sodium"] = sodium;

        final protein = _parseValue(line, ["protein"]);
        if (protein != null) values["protein"] = protein;

        final vitaminA = _parseValue(line, ["vitamin a"]);
        if (vitaminA != null) values["vitamin_a"] = vitaminA;

        final vitaminC = _parseValue(line, ["vitamin c"]);
        if (vitaminC != null) values["vitamin_c"] = vitaminC;

        final iron = _parseValue(line, ["iron"]);
        if (iron != null) values["iron"] = iron;

        final calcium = _parseValue(line, ["calcium"]);
        if (calcium != null) values["calcium"] = calcium;
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
      log('Error parsing nutrition text: $e');
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
      log('Error processing image: $e');
      return null;
    }
  }
}