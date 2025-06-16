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

## Configuration

The API endpoint used by the app can be set at build time using a
`--dart-define` value. By default the app points to `http://localhost:5001`.

To override this value when running or building the app, pass the `API_URL`
define:

```bash
flutter run --dart-define=API_URL=https://api.example.com
```

When building for release, include the same flag:

```bash
flutter build apk --dart-define=API_URL=https://api.example.com
```

If no `API_URL` is provided, the development default (`http://localhost:5001`)
is used.
