# LingoBreeze Backend

Simple Express backend for the LingoBreeze assignment. Provides:

- `GET /words` - returns saved vocabulary entries
- `POST /words` - adds a new vocabulary entry

It supports two storage modes:

Firestore (recommended for full assignment):

1. Create a Firebase project at https://console.firebase.google.com/ and enable Firestore (in Native/Datastore mode).
2. In the Firebase console go to Project Settings → Service accounts → Generate new private key. This downloads a JSON file.
3. Save that file somewhere secure on your machine (do NOT commit it).
4. Set environment variables before starting the server:

```bash
export USE_FIRESTORE=true
export GOOGLE_APPLICATION_CREDENTIALS=/full/path/to/serviceAccountKey.json
```

Alternatively you can set `FIREBASE_SERVICE_ACCOUNT_PATH` to the path of the JSON file.

The backend will then persist vocabulary entries to the `words` collection in Firestore.

Helpful notes:
- Make sure Firestore rules allow your server to write/read (server uses service account so rules are not restrictive in this flow).
- If you prefer not to use Firestore, the server will fall back to a local `db.json` file.

Run locally:
1. Firestore (recommended for full assignment): set `USE_FIRESTORE=true` and provide `GOOGLE_APPLICATION_CREDENTIALS` or `FIREBASE_SERVICE_ACCOUNT_PATH` pointing to your service account JSON file.
2. Local JSON file (fallback): the server will read/write `db.json` in the backend folder.

Run locally:

```bash
cd backend
npm install
npm run start
```

Run with Firestore emulator (no billing - recommended for grading)

```bash
# start the emulator (keep this terminal open)
cd /Users/mizhabas/Projects/Assignment/backend
firebase emulators:start --only firestore

# in a separate terminal start the backend pointed at the emulator
export USE_FIRESTORE=true
export FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
export GOOGLE_CLOUD_PROJECT=lingobreeze-20260607-1
node index.js
```

Notes:
- The emulator UI is usually at http://127.0.0.1:4000 (open to inspect data).
- For reviewers: the project includes `firebase.json` and `.firebaserc` so running the emulator and backend is straightforward.
