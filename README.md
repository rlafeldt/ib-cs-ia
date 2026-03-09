# Insurance Management App

A cross-platform Flutter application for managing insurance contracts and claims, built as an IB Computer Science Internal Assessment project. The app features separate user and admin interfaces, Firebase authentication, and Firestore-backed data management.

## Features

- **User Authentication** — Sign up, log in, and password recovery via Firebase Auth
- **Contract Management** — Create, view, and manage insurance contracts
- **Claims Processing** — Submit and track insurance claims
- **Admin Dashboard** — Dedicated admin interface for managing users, contracts, and claims
- **PDF & Excel Export** — Generate PDF documents and Excel spreadsheets from app data
- **Responsive Design** — Adaptive layouts for mobile and desktop screens
- **Data Visualization** — Monthly returns chart powered by fl_chart

## Tech Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Auth, Firestore, Cloud Functions)
- **State Management:** Riverpod, GetX
- **Platforms:** iOS, Android, Web, macOS, Linux, Windows

## Project Structure

```
lib/
├── main.dart
├── models/            # Data models (User, Contract, Claim)
├── screens/
│   ├── admin/         # Admin dashboard, user/contract/claim management
│   ├── auth/          # Login, signup, forgot password
│   └── ...            # User-facing screens
├── services/
│   ├── api/           # PDF and Excel generation
│   ├── auth/          # Authentication logic
│   ├── controllers/   # GetX controllers
│   └── providers/     # Riverpod providers
├── widgets/           # Reusable UI components
└── assets/            # Images and icons
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.1.0)
- A Firebase project

### Firebase Setup

Firebase configuration files are excluded from version control for security. To set up Firebase locally:

1. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Configure Firebase for your project:
   ```bash
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` and the platform-specific config files (`google-services.json`, `GoogleService-Info.plist`).

### Run the App

```bash
flutter pub get
flutter run
```

### Cloud Functions

The `functions/` directory contains Firebase Cloud Functions. To deploy:

```bash
cd functions
npm install
firebase deploy --only functions
```
