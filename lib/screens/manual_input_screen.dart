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
        caloricValue:
            double.tryParse(_controllers['calories']!.text) ?? 0.0,
        fat: double.tryParse(_controllers['fat']!.text) ?? 0.0,
        saturatedFat:
            double.tryParse(_controllers['saturated_fat']!.text) ?? 0.0,
        sugars: double.tryParse(_controllers['sugars']!.text) ?? 0.0,
        sodium: double.tryParse(_controllers['sodium']!.text) ?? 0.0,
        protein: double.tryParse(_controllers['protein']!.text) ?? 0.0,
        vitaminA: double.tryParse(_controllers['vitamin_a']!.text) ?? 0.0,
        vitaminC: double.tryParse(_controllers['vitamin_c']!.text) ?? 0.0,
        iron: double.tryParse(_controllers['iron']!.text) ?? 0.0,
        calcium: double.tryParse(_controllers['calcium']!.text) ?? 0.0,
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
              return null; // allow empty input
            }
            final parsed = double.tryParse(value);
            if (parsed == null) {
              return 'Please enter a valid number';
            }
            if (parsed < 0) {
              return 'Value cannot be negative';
            }
            return null;
          },
        ),
      );
    }).toList();
  }
}