import 'dart:io';

/// Application-wide configuration values.
class AppConfig {
  /// Returns the base URL used for API requests.
  ///
  /// The value is resolved in the following order:
  /// 1. Compile-time constant passed via `--dart-define=API_URL`.
  /// 2. Runtime environment variable `API_URL` if available.
  /// 3. A built-in default value.
  static String get apiBaseUrl {
    const compileTimeUrl = String.fromEnvironment('API_URL');
    final runtimeUrl = Platform.environment['API_URL'];

    final url = compileTimeUrl.isNotEmpty
        ? compileTimeUrl
        : (runtimeUrl != null && runtimeUrl.isNotEmpty)
            ? runtimeUrl
            : 'https://web-production-0fba.up.railway.app/';

    return _stripTrailingSlashes(url);
  }

  /// Removes any trailing slashes from [url].
  static String _stripTrailingSlashes(String url) =>
      url.replaceAll(RegExp(r'/+\$'), '');
}
