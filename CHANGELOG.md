# Changelog

All notable changes to MyLift will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-29

### Added

#### AI-Powered Coaching
- Integrated Google Gemini AI for personalized fitness coaching
- AI coach provides workout suggestions, form tips, and exercise alternatives
- Configurable API key storage in settings
- Fallback responses when AI is unavailable
- Chat history management with clear conversation option

#### Workout Tracking
- Real-time workout session tracking with duration timer
- Exercise logging with sets, reps, and weight input
- Quick weight/rep adjustment buttons (+/- controls)
- Edit previously logged sets
- Visual progress indicators for workout completion
- Auto-advance to next exercise when all sets complete

#### Rest Timer
- Full-screen animated rest timer overlay
- Circular progress indicator with countdown
- Haptic feedback at 5-second warning and completion
- Adjustable rest time (+15s, +30s, -15s, -30s buttons)
- Skip rest option
- Shows next exercise name during rest

#### Progress & Statistics
- Weekly activity chart showing workout days
- Volume trend line chart with data points
- Muscle group distribution pie chart
- Personal records tracking with dates
- Strength progress bars with percentage change
- Estimated 1RM calculations
- Workout history list with details

#### Achievements System
- Current streak banner with fire animation
- Achievement badges for consistency milestones
- Strength achievements (plate club, two-plate, etc.)
- Workout count milestones (10, 50, 100 workouts)
- Progress tracking for locked achievements
- Visual unlock status indicators

#### Exercise Library
- Animated exercise demonstration widget
- Cycling form tips with visual highlights
- Common mistakes warnings
- Equipment requirements display
- Alternative exercise suggestions
- Video tutorial links (YouTube integration)

#### Dark Mode
- Full dark theme support
- Toggle in settings
- Persisted preference using SharedPreferences
- Automatic theme switching

#### User Experience
- Modern home screen with greeting based on time of day
- Quick stats display (streak, workouts, total time)
- Weekly progress visualization
- Motivational quotes that rotate daily
- Quick action buttons for common tasks
- Pull-to-refresh functionality

#### Authentication
- Firebase Authentication integration
- Google Sign-In support
- User profile with photo, name, and email
- Sign out functionality
- Personalized greetings using user's first name

### Technical

#### Architecture
- Clean architecture with presentation/data/core layers
- Riverpod for state management
- GoRouter for navigation with bottom navigation shell
- Freezed for immutable data models

#### Services
- `AiCoachService` - Gemini AI integration
- `AuthService` - Firebase authentication
- `SettingsService` - SharedPreferences storage

#### New Screens
- `ProgressScreen` - Charts and statistics
- `AchievementsScreen` - Badges and streaks
- Enhanced `ActiveWorkoutScreen` - Full workout tracking
- Enhanced `CoachChatScreen` - AI integration
- Enhanced `SettingsScreen` - API key and preferences

#### New Widgets
- `RestTimerOverlay` - Animated rest timer
- `ExerciseDemoWidget` - Animated exercise demonstrations
- `WeeklyActivityChart` - Bar chart for weekly activity
- `VolumeTrendChart` - Line chart for volume trends
- `MuscleGroupChart` - Pie chart for muscle distribution
- `StatCard` - Reusable statistic display card

### Fixed
- Blank home screen after sign-in
- User profile showing placeholder data instead of real user info
- Sign-out not redirecting to login

### Dependencies
- `google_generative_ai` - Gemini AI SDK
- `firebase_auth` - Authentication
- `google_sign_in` - Google OAuth
- `shared_preferences` - Local storage
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `freezed` - Code generation

---

## [Unreleased]

### Planned
- Workout templates and custom workout builder
- Social features (share workouts, challenges)
- Apple Watch / WearOS integration
- Offline mode with sync
- Export workout data (CSV/PDF)
- Push notifications for reminders
- Body measurements tracking
- Photo progress tracking
- Integration with fitness wearables
- Barcode scanner for gym equipment
