# nutrisafe

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## API Configuration

The application communicates with a backend API defined by the `API_URL`
environment variable. If no value is provided, it defaults to
`https://web-production-0fba.up.railway.app/`.

You can override this value when running or building the app using Flutter's `--dart-define` option:

```bash
flutter run --dart-define=API_URL=https://your-api-endpoint.com
```

Use the same flag when building release artifacts, e.g. `flutter build apk`.
