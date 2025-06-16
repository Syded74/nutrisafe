# NutriSafe

NutriSafe is an AI‑powered nutrition profiling app built for the UNICEF
Innovation Lab. The goal is to help Ghanaian families quickly assess the
nutritional safety of grocery products. The mobile app scans or manually
captures nutrition facts, sends the information to a backend XGBoost model,
and displays an easy‑to‑understand health rating.

## Getting Started

1. **Clone the repository**

   ```bash
   git clone <this repo>
   cd nutrisafe
   ```

2. **Install Flutter** (see the [Flutter docs](https://docs.flutter.dev/)) and
   run the app:

   ```bash
   flutter pub get
   flutter run
   ```

3. **Backend API**

   The mobile app expects a Flask API running at `http://localhost:5001` by
   default. Start the backend with:

   ```bash
   python app.py
   ```

   Adjust the `baseUrl` in `lib/services/api_service.dart` if your API runs on a
   different address.
