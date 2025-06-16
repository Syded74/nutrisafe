class NutritionData {
  final double caloricValue;
  final double fat;
  final double saturatedFat;
  final double sugars;
  final double sodium;
  final double protein;
  final double vitaminA;
  final double vitaminC;
  final double iron;
  final double calcium;

  NutritionData({
    required this.caloricValue,
    required this.fat,
    required this.saturatedFat,
    required this.sugars,
    required this.sodium,
    required this.protein,
    required this.vitaminA,
    required this.vitaminC,
    required this.iron,
    required this.calcium,
  });

  Map<String, dynamic> toJson() {
    return {
      'caloric_value': caloricValue,
      'fat': fat,
      'saturated_fat': saturatedFat,
      'sugars': sugars,
      'sodium': sodium,
      'protein': protein,
      'vitamin_a': vitaminA,
      'vitamin_c': vitaminC,
      'iron': iron,
      'calcium': calcium,
    };
  }

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      caloricValue: json['caloric_value']?.toDouble() ?? 0.0,
      fat: json['fat']?.toDouble() ?? 0.0,
      saturatedFat: json['saturated_fat']?.toDouble() ?? 0.0,
      sugars: json['sugars']?.toDouble() ?? 0.0,
      sodium: json['sodium']?.toDouble() ?? 0.0,
      protein: json['protein']?.toDouble() ?? 0.0,
      vitaminA: json['vitamin_a']?.toDouble() ?? 0.0,
      vitaminC: json['vitamin_c']?.toDouble() ?? 0.0,
      iron: json['iron']?.toDouble() ?? 0.0,
      calcium: json['calcium']?.toDouble() ?? 0.0,
    );
  }
}

class NutritionResult {
  final String category;
  final double confidence;
  final int riskLevel;
  final String message;
  final List<String> tips;
  final String color;

  NutritionResult({
    required this.category,
    required this.confidence,
    required this.riskLevel,
    required this.message,
    required this.tips,
    required this.color,
  });

  factory NutritionResult.fromJson(Map<String, dynamic> json) {
    final prediction = json['prediction'];
    final advice = json['advice'];

    return NutritionResult(
      category: prediction['category'] ?? 'Unknown',
      confidence: prediction['confidence']?.toDouble() ?? 0.0,
      riskLevel: prediction['risk_level'] ?? 0,
      message: advice['message'] ?? '',
      tips: List<String>.from(advice['tips'] ?? []),
      color: advice['color'] ?? '#4CAF50',
    );
  }
}