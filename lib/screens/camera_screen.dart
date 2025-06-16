import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../services/ocr_service.dart';
import 'manual_input_screen.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureAndProcess() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() => _isProcessing = true);

    final imageFile = File(pickedFile.path);

    final nutritionData = await OcrService.processImage(imageFile);

    if (nutritionData == null) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not read nutrition values.')),
        );
      }
      return;
    }

    try {
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
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Nutrition Label'),
      ),
      body: Column(
        children: [
          // Camera Preview Area (Placeholder)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Camera Preview',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Point camera at nutrition label',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Position the nutrition label clearly in view for best OCR results',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Capture Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _captureAndProcess,
                    icon: _isProcessing
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.camera_alt),
                    label: Text(
                      _isProcessing ? 'Processing...' : 'Capture & Analyze',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Manual Input Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualInputScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Manual Input Instead'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}