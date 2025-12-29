# MyLift - AI Gym Assistant

A Flutter mobile app for iOS and Android that serves as your personal gym assistant with AI-powered workout generation and digital coaching.

## Features

- **Weekly Workout Generation** - AI-generated workout plans based on your goals and equipment
- **Real-time Workout Logging** - Log sets, reps, and weights during your workout with rest timer
- **AI Digital Coach** - Chat with your AI coach for guidance, motivation, and workout modifications
- **Exercise Library** - Browse exercises with video tutorials and form tips
- **Multiple Gym Profiles** - Save different equipment setups for home, gym, or travel
- **Offline Support** - Cache workouts for offline access
- **Push Notifications** - Coaching check-ins when you miss workouts

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Firebase** - Authentication, Firestore database, Cloud Messaging
- **Gemini 3.0 Flash** - AI for workout generation and coaching
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Hive** - Local caching
- **Freezed** - Immutable data models

## Getting Started

### Prerequisites

1. **Install Flutter**
   ```bash
   # On macOS with Homebrew
   brew install flutter

   # Or download from https://flutter.dev/docs/get-started/install
   ```

2. **Verify installation**
   ```bash
   flutter doctor
   ```

### Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create a new project named "MyLift"
   - Enable Google Analytics (optional)

2. **Add Firebase to Flutter**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase (run from project directory)
   cd my_lift
   flutterfire configure --project=your-firebase-project-id
   ```

3. **Enable Firebase Services**
   - **Authentication**: Enable Email/Password and Google Sign-In
   - **Cloud Firestore**: Create database in production mode
   - **Cloud Messaging**: Enable for push notifications

4. **iOS Setup** (for push notifications)
   - Enable Push Notifications capability in Xcode
   - Enable Background Modes (Remote notifications)
   - Upload APNs key to Firebase Console

### Run the App

```bash
# Get dependencies
flutter pub get

# Generate code (models, providers)
flutter pub run build_runner build --delete-conflicting-outputs

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android

# Run on connected device
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # MaterialApp configuration
├── core/                     # Shared utilities
│   ├── constants/            # Colors, strings, dimensions
│   ├── theme/                # App theming
│   ├── utils/                # Helpers and extensions
│   ├── exceptions/           # Custom exceptions
│   └── router/               # GoRouter configuration
├── data/
│   ├── models/               # Freezed data classes
│   ├── repositories/         # Data access layer
│   ├── datasources/          # Firebase & local storage
│   └── providers/            # Riverpod providers
├── domain/
│   └── services/             # Business logic
└── presentation/
    ├── auth/                 # Login, register screens
    ├── onboarding/           # User setup flow
    ├── home/                 # Dashboard
    ├── workout/              # Workout screens
    ├── exercises/            # Exercise library
    ├── coach/                # AI chat
    ├── profile/              # Settings
    └── history/              # Workout history
```

## Key Files to Understand

| File | Purpose |
|------|---------|
| `lib/data/models/*.dart` | Data models - understand your data structure |
| `lib/core/router/app_router.dart` | Navigation - all app routes defined here |
| `lib/core/theme/app_theme.dart` | Theme - customize colors and styles |
| `lib/presentation/*/screens/*.dart` | Screens - UI for each feature |

## Next Steps to Complete the App

### Phase 1: Firebase Integration
1. Complete Firebase setup with `flutterfire configure`
2. Uncomment Firebase initialization in `main.dart`
3. Implement `AuthRepository` with Firebase Auth
4. Add Firestore read/write in repositories

### Phase 2: AI Integration
1. Set up Gemini API access via Firebase AI Logic
2. Implement `WorkoutGenerationService`
3. Implement `CoachService` for chat

### Phase 3: Data Persistence
1. Connect screens to Firestore
2. Implement Hive caching for offline support
3. Add sync service for offline logs

### Phase 4: Polish
1. Add loading states and error handling
2. Implement push notifications
3. Add animations
4. Test on physical devices

## Development Commands

```bash
# Generate code after model changes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get

# Run tests
flutter test

# Build release APK
flutter build apk --release

# Build for iOS
flutter build ios --release
```

## Troubleshooting

### "Command not found: flutter"
Flutter is not in your PATH. Add it:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Build runner errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS Pod errors
```bash
cd ios
pod deintegrate
pod install
cd ..
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)

## License

This project is for personal use.
