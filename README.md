# LingoBreeze

LingoBreeze is a language-learning application feature that allows users to save and view vocabulary words they want to learn. This repository contains the complete implementation of the **My Vocabulary** feature (Create + Read flows), comprising a Node.js REST API backend and a Flutter client app.

## Repository Structure

The project is structured as follows:

*   **`backend/`**: A Node.js Express server providing the vocabulary API endpoints (`GET /words` and `POST /words`). Supports dual storage modes (Local JSON database and Firebase Firestore).
*   **`flutter-app/`**: A cross-platform Flutter application implementing the vocabulary UI, built using **Clean Architecture** patterns, Material 3, and state management.

---

## Key Features

1.  **Dual Theme Support**: Modern Light and Dark theme configurations with HSL-based palettes for visual comfort.
2.  **State Management & Transitions**: Graceful handles for Loading (custom animated skeleton lists), Loaded (card lists with date badges), Empty ("Add your first word" flow), and Error states (interactive retry options).
3.  **Local/Cloud Sync**: Seamless persistence with local `db.json` files for fast prototyping and Firebase Firestore for production.
4.  **Robust Form Validation**: Instant client-side validation for word input fields alongside server-side validation.

---

## Flutter App Architecture

The client application is organized using **Clean Architecture** principles to separate concerns and ensure testability:

```
flutter-app/lib/
├── core/
│   ├── error/          # Failure abstractions
│   ├── theme/          # Custom light and dark themes (HSL-based)
│   └── usecases/       # UseCase interface definitions
└── features/
    └── vocabulary/     # Vocabulary Feature
        ├── data/       # Data models, repository implementations, HTTP data sources
        ├── domain/     # Entities, repository contracts, and use cases (GetWords, AddWord)
        └── presentation/ # ChangeNotifier providers, screen pages, and reusable widgets
```

---

## Getting Started

### 1. Prerequisite Checks
*   **Flutter SDK**: `>= 3.0.0`
*   **Node.js**: `>= 16.x`
*   **npm**: `>= 8.x`

---

### Quick Start (One-Step Run Script)

To automatically install dependencies, launch the Node.js backend in the background, and start the Flutter application in one terminal command, run the root-level script:

```bash
./run.sh
```
*Note: Stopping this script (via `Ctrl+C`) automatically shuts down the background backend server.*

---

### 2. Running the Backend

The backend server listens on port `3000` by default.

#### Option A: Local Storage (db.json)
This mode reads and writes to a local `db.json` file inside the `backend/` directory. No external credentials needed.

```bash
cd backend
npm install
npm run start
```

#### Option B: Firebase Firestore (Emulator or Cloud)
To use Firebase Firestore, set `USE_FIRESTORE=true`.

*   **Using Firestore Emulator (Recommended for Grading)**
    ```bash
    # Start the Firestore emulator in one terminal window
    cd backend
    firebase emulators:start --only firestore
    
    # In another terminal window, start the server pointed to the emulator:
    export USE_FIRESTORE=true
    export FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
    export GOOGLE_CLOUD_PROJECT=lingobreeze-demo
    npm run start
    ```

*   **Using Cloud Firestore (Production service account)**
    Generate a Service Account key JSON file from the Firebase Console (Project Settings -> Service Accounts) and set:
    ```bash
    export USE_FIRESTORE=true
    export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/serviceAccountKey.json
    npm run start
    ```

---

### 3. Running the Flutter App

1.  Navigate to the `flutter-app` directory:
    ```bash
    cd flutter-app
    ```
2.  Restore dependencies:
    ```bash
    flutter pub get
    ```
3.  Configure API Endpoint:
    Open `lib/config.dart` and confirm/update the `BACKEND_BASE_URL` to point to your backend.
    *   For macOS/iOS Simulator: `http://localhost:3000`
    *   For Android Emulator: `http://10.0.2.2:3000`
4.  Run the app:
    ```bash
    flutter run
    ```

---

## Running Tests

### Flutter Tests
The codebase includes unit tests for the data models, HTTP data source requests, repository layer, providers, and widget smoke tests for the UI states.

To execute the test suite:
```bash
cd flutter-app
flutter test
```
