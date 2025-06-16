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

## Configuring the API endpoint

The app communicates with a Flask backend. By default the base URL is
`http://localhost:5001`. You can override this when building or running the
app by setting the `API_BASE_URL` compile-time variable:

```bash
flutter run --dart-define=API_BASE_URL=https://your-server.com
```

or when building a release:

```bash
flutter build apk --dart-define=API_BASE_URL=https://your-server.com
```

If no value is provided, the app falls back to `http://localhost:5001`.
