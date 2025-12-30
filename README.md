<p align="center">
  <h1 align="center">MyLift</h1>
  <p align="center">
    <strong>AI-Powered Fitness Companion</strong>
  </p>
  <p align="center">
    Track workouts • Get personalized coaching • Visualize progress • Achieve your goals
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.16+-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/AI-Gemini-4285F4?logo=google" alt="Gemini">
</p>

---

## Overview

MyLift is a comprehensive fitness app that combines intelligent workout tracking with AI-powered coaching. Built with Flutter for iOS and Android, it helps you build consistent training habits, track your progress, and continuously improve your fitness.

---

## Features

### AI Coach
| Feature | Description |
|---------|-------------|
| **Gemini-Powered Chat** | Get personalized advice on form, nutrition, and programming |
| **Voice Input** | Talk to your coach hands-free during workouts |
| **Context-Aware** | AI understands your training history and goals |

### Workout Management
| Feature | Description |
|---------|-------------|
| **Custom Workout Builder** | Create personalized routines with 40+ exercises |
| **Template Library** | Pre-built programs: PPL, Upper/Lower, 5x5, Full Body |
| **Active Workout Tracking** | Log sets, reps, and weight in real-time |
| **Superset Support** | Supersets, drop sets, giant sets, rest-pause |
| **RPE/RIR Tracking** | Rate effort levels for smarter programming |

### Smart Workout Features
| Feature | Description |
|---------|-------------|
| **Rest Timer** | Auto-starts after each set, customizable by exercise type |
| **Rep Tempo** | Track eccentric/concentric phases (3-1-2-0 notation) |
| **Workout Notes** | Add notes to sets and sessions |
| **Demo Videos** | Watch proper form for 20+ exercises |
| **Warm-up Generator** | Progressive warm-up sets based on working weight |
| **Exercise Substitutions** | Find alternatives when equipment is busy |

### Progress Tracking
| Feature | Description |
|---------|-------------|
| **Body Measurements** | Track 11 measurements over time |
| **Progress Photos** | Before/after comparisons |
| **Weight Tracking** | Trend smoothing for accurate progress |
| **Personal Records** | Automatic PR detection with celebrations |

### Analytics & Insights
| Feature | Description |
|---------|-------------|
| **Exercise Progress Charts** | Visualize strength gains per lift |
| **Muscle Group Heatmap** | See training frequency at a glance |
| **Workout Calendar** | View history in calendar format |
| **Progressive Overload AI** | Get recommendations for weight increases |
| **Recovery Score** | Readiness assessment from multiple factors |
| **Streak Tracking** | Stay motivated with workout streaks |
| **Achievements** | Unlock badges for milestones |

### Quality of Life
| Feature | Description |
|---------|-------------|
| **Plate Calculator** | Figure out which plates to load |
| **1RM Calculator** | Estimate max from submaximal lifts |
| **Workout Reminders** | Push notifications for scheduled training |
| **Export/Share** | Share workout templates with friends |
| **Apple Health Sync** | Integrate with iOS Health app |
| **Home Screen Widgets** | Quick workout access from home screen |

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.16+ |
| **Language** | Dart 3.2+ |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Backend** | Firebase (Auth, Firestore, Messaging) |
| **AI** | Google Gemini |
| **Local Storage** | Hive, SharedPreferences |
| **Code Generation** | Freezed, JSON Serializable |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.16+
- Dart SDK 3.2+
- Xcode 15+ (for iOS)
- Android Studio (for Android)
- Firebase account
- Google AI API key

### Installation

```bash
# Clone the repository
git clone https://github.com/cdemeke/my-lift.git
cd my-lift

# Install dependencies
flutter pub get

# Configure Firebase
flutterfire configure --project=your-project-id

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment Setup

Create `.env` in the project root:

```env
GEMINI_API_KEY=your_api_key_here
```

### iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Take progress photos for tracking your fitness journey.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Save and view your progress photos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Enable voice commands for the AI coach.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Speech recognition for hands-free voice input.</string>
```

---

## Project Structure

```
lib/
├── core/
│   ├── constants/           # Colors, dimensions, strings
│   ├── router/              # Navigation (GoRouter)
│   └── theme/               # App theming
├── data/
│   ├── models/              # Data models (Freezed)
│   ├── repositories/        # Data access layer
│   └── services/            # Business logic
│       ├── progressive_overload_service.dart
│       ├── recovery_service.dart
│       ├── workout_reminder_service.dart
│       ├── workout_export_service.dart
│       ├── health_integration_service.dart
│       └── widget_service.dart
├── presentation/
│   ├── achievements/        # Streaks & badges
│   ├── analytics/           # Charts & heatmaps
│   ├── auth/                # Login & registration
│   ├── coach/               # AI chat & voice input
│   ├── history/             # Workout history & calendar
│   ├── home/                # Dashboard
│   ├── onboarding/          # Setup quiz
│   ├── profile/             # Settings
│   ├── progress/            # Measurements, photos, weight
│   ├── tools/               # Calculators
│   └── workout/             # Workout screens
│       ├── screens/
│       └── widgets/
│           ├── rest_timer_overlay.dart
│           ├── rest_timer_settings.dart
│           ├── tempo_selector.dart
│           ├── workout_notes.dart
│           ├── exercise_demo.dart
│           └── ...
└── main.dart
```

---

## Key Features

### Progressive Overload System

The app analyzes your training and suggests how to progress:

```
✅ Increase Weight - When you exceed rep targets at manageable RPE
✅ Increase Reps - When hitting targets but not exceeding
✅ Deload - When RPE is high and performance drops
✅ Variation - When plateaued for 3+ sessions
```

### Recovery Score

Calculated from:
- Training volume (7-day)
- Rest days since last workout
- Sleep quality
- Stress levels
- Muscle soreness

Returns 0-100 score with actionable recommendations.

### Workout Templates

| Program | Days/Week | Best For |
|---------|-----------|----------|
| Push/Pull/Legs | 6 | Intermediate+ |
| Upper/Lower | 4 | All levels |
| 5x5 Strength | 3 | Beginners |
| Full Body | 3 | Beginners |
| Bro Split | 5 | Hypertrophy |

---

## Development

### Commands

```bash
# Generate code after model changes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get

# Run tests
flutter test

# Build release
flutter build apk --release
flutter build ios --release
```

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## Roadmap

- [ ] Apple Watch companion app
- [ ] Social features (share workouts, friend challenges)
- [ ] Nutrition tracking
- [ ] Periodization planning
- [ ] AI form check via camera
- [ ] Workout music integration

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Acknowledgments

- [Flutter](https://flutter.dev) - UI framework
- [Firebase](https://firebase.google.com) - Backend services
- [Google Gemini](https://ai.google.dev) - AI capabilities
- [Riverpod](https://riverpod.dev) - State management

---

<p align="center">
  Built with 💪 by <a href="https://github.com/cdemeke">@cdemeke</a>
</p>
