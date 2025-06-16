import 'package:flutter/material.dart';
import '../models/nutrition_data.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, TextEditingController> _controllers = {
    'calories': TextEditingController(),
    'fat': TextEditingController(),
    'saturated_fat': TextEditingController(),
    'sugars': TextEditingController(),
    'sodium': TextEditingController(),
    'protein': TextEditingController(),
    'vitamin_a': TextEditingController(),
    'vitamin_c': TextEditingController(),
    'iron': TextEditingController(),
    'calcium': TextEditingController(),
  };

  final Map<String, String> _labels = {
    'calories': 'Calories (per 100g)',
    'fat': 'Total Fat (g)',
    'saturated_fat': 'Saturated Fat (g)',
    'sugars': 'Sugars (g)',
    'sodium': 'Sodium (g)',
    'protein': 'Protein (g)',
    'vitamin_a': 'Vitamin A (μg)',
    'vitamin_c': 'Vitamin C (mg)',
    'iron': 'Iron (mg)',
    'calcium': 'Calcium (mg)',
  };

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _analyzeNutrition() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final nutritionData = NutritionData(
        caloricValue: double.parse(_controllers['calories']!.text),
        fat: double.parse(_controllers['fat']!.text),
        saturatedFat: double.parse(_controllers['saturated_fat']!.text),
        sugars: double.parse(_controllers['sugars']!.text),
        sodium: double.parse(_controllers['sodium']!.text),
        protein: double.parse(_controllers['protein']!.text),
        vitaminA: double.parse(_controllers['vitamin_a']!.text),
        vitaminC: double.parse(_controllers['vitamin_c']!.text),
        iron: double.parse(_controllers['iron']!.text),
        calcium: double.parse(_controllers['calcium']!.text),
      );

      final result = await ApiService.predictNutrition(nutritionData);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Input'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter Nutrition Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Fill in the nutrition values per 100g',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),

                    ..._buildInputFields(),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _analyzeNutrition,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Analyze Nutrition',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInputFields() {
    return _controllers.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: entry.value,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _labels[entry.key],
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            if (double.parse(value) < 0) {
              return 'Value cannot be negative';
            }
            return null;
          },
        ),
      );
    }).toList();
  }
}