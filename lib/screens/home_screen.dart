import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'manual_input_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isApiHealthy = false;
  bool _isCheckingApi = true;

  @override
  void initState() {
    super.initState();
    _checkApiHealth();
  }

  Future<void> _checkApiHealth() async {
    final isHealthy = await ApiService.checkApiHealth();
    setState(() {
      _isApiHealthy = isHealthy;
      _isCheckingApi = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriSafe'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade100,
                    Colors.green.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 60,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nutrition Safety Scanner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Powered by AI for Ghanaian families',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // API Status
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _isCheckingApi
                    ? Colors.orange.shade50
                    : _isApiHealthy
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isCheckingApi
                      ? Colors.orange
                      : _isApiHealthy
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isCheckingApi
                        ? Icons.refresh
                        : _isApiHealthy
                        ? Icons.check_circle
                        : Icons.error,
                    color: _isCheckingApi
                        ? Colors.orange
                        : _isApiHealthy
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isCheckingApi
                        ? 'Checking API...'
                        : _isApiHealthy
                        ? 'API Connected'
                        : 'API Offline',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _isCheckingApi
                          ? Colors.orange.shade800
                          : _isApiHealthy
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                  ),
                  const Spacer(),
                  if (!_isCheckingApi && !_isApiHealthy)
                    TextButton(
                      onPressed: _checkApiHealth,
                      child: const Text('Retry'),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons
            Expanded(
              child: Column(
                children: [
                  _buildActionCard(
                    icon: Icons.camera_alt,
                    title: 'Scan Label',
                    subtitle: 'Take photo of nutrition label',
                    color: Colors.blue,
                    onTap: _isApiHealthy
                        ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraScreen(),
                      ),
                    )
                        : null,
                  ),

                  const SizedBox(height: 15),

                  _buildActionCard(
                    icon: Icons.edit,
                    title: 'Manual Input',
                    subtitle: 'Enter nutrition values manually',
                    color: Colors.orange,
                    onTap: _isApiHealthy
                        ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualInputScreen(),
                      ),
                    )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1.0,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}