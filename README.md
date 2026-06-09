# LingoBreeze Assignment

Repository structure:

- `backend/` — Node.js Express server providing `GET /words` and `POST /words`. Can write to Firestore or local `db.json`.
- `flutter-app/` — Flutter app implementing the `My Vocabulary` feature (Create + Read).
- `Assignment.txt` — assignment specification.

Quick start

1. Start the backend:

```bash
cd backend
npm install
# For local JSON storage
npm run start

# Or, to use Firestore (requires service account JSON):
export USE_FIRESTORE=true
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/serviceAccount.json
npm run start
```

2. Run the Flutter app:

```bash
cd flutter-app
flutter pub get
# Update lib/config.dart BACKEND_BASE_URL if needed (use http://10.0.2.2:3000 for Android emulator)
flutter run
```

Notes
- The Flutter app uses the backend API to retrieve and save vocabulary entries.
- The backend will persist to Firestore when `USE_FIRESTORE=true` and credentials are provided; otherwise it will use `db.json`.
