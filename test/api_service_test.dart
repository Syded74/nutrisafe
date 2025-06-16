import 'package:flutter_test/flutter_test.dart';
import 'package:nutrisafe/services/api_service.dart';

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
}
