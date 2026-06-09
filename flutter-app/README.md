# LingoBreeze Flutter App

Minimal Flutter app implementing the `My Vocabulary` feature.

Quick start

1. Ensure the backend is running (see `backend/README.md`).
2. Adjust `lib/config.dart` `BACKEND_BASE_URL` to point to your backend (use `http://10.0.2.2:3000` for Android emulator).
3. From this folder run:

```bash
flutter pub get
flutter run
```

Notes
- The app calls `GET /words` and `POST /words` on the backend to fetch and save words.
- If using Firestore, start the backend with `USE_FIRESTORE=true` and set credentials.
