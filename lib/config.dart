class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://web-production-0fba.up.railway.app/',
  );
}
