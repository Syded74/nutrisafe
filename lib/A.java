import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  final Map<String, double> nutritionData;

  const ResultScreen({super.key, required this.nutritionData});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String result = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPrediction();
  }

  Future<void> getPrediction() async {
    try {
      const String apiUrl = "http://YOUR_API_URL/predict"; // Replace with your real Flask API URL

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(widget.nutritionData),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          result = decoded['prediction'];
          isLoading = false;
        });
      } else {
        setState(() {
          result = "API Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Prediction")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Prediction Result:",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    result,
                    style: const TextStyle(fontSize: 30, color: Colors.green),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text("Start New Scan"),
                  )
                ],
              ),
      ),
    );
  }
}