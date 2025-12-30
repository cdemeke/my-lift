import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/auth/screens/forgot_password_screen.dart';
import '../../presentation/onboarding/screens/onboarding_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/workout/screens/weekly_plan_screen.dart';
import '../../presentation/workout/screens/workout_detail_screen.dart';
import '../../presentation/workout/screens/active_workout_screen.dart';
import '../../presentation/workout/screens/workout_complete_screen.dart';
import '../../presentation/workout/screens/workout_builder_screen.dart';
import '../../presentation/workout/screens/workout_templates_screen.dart';
import '../../presentation/exercises/screens/exercise_library_screen.dart';
import '../../presentation/exercises/screens/exercise_detail_screen.dart';
import '../../presentation/coach/screens/coach_chat_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/profile/screens/gym_profiles_screen.dart';
import '../../presentation/profile/screens/settings_screen.dart';
import '../../presentation/history/screens/history_screen.dart';
import '../../presentation/progress/screens/progress_screen.dart';
import '../../presentation/achievements/screens/achievements_screen.dart';
import '../../presentation/progress/screens/measurements_screen.dart';
import '../../presentation/progress/screens/progress_photos_screen.dart';
import '../../presentation/progress/screens/weight_tracking_screen.dart';
import '../../presentation/tools/screens/plate_calculator_screen.dart';
import '../../presentation/tools/screens/one_rm_calculator_screen.dart';
import '../../presentation/onboarding/screens/onboarding_quiz_screen.dart';
import 'route_names.dart';

/// Provider for the GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router(ref);
});

/// App router configuration using GoRouter.
class AppRouter {
  AppRouter._();

  /// Global navigator key.
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Shell navigator key for bottom nav.
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Create the router instance.
  static GoRouter router(Ref ref) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RoutePaths.login,
      debugLogDiagnostics: true,
      routes: [
        // Auth routes (no bottom nav)
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Onboarding routes
        GoRoute(
          path: RoutePaths.onboarding,
          name: RouteNames.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: RoutePaths.onboardingQuiz,
          name: RouteNames.onboardingQuiz,
          builder: (context, state) => const OnboardingQuizScreen(),
        ),

        // Main app with bottom navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            // Home tab
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),

            // Weekly plan tab
            GoRoute(
              path: RoutePaths.weeklyPlan,
              name: RouteNames.weeklyPlan,
              builder: (context, state) => const WeeklyPlanScreen(),
            ),

            // Coach tab
            GoRoute(
              path: RoutePaths.coach,
              name: RouteNames.coach,
              builder: (context, state) => const CoachChatScreen(),
            ),

            // Profile tab
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),

        // Workout routes (full screen, no bottom nav)
        GoRoute(
          path: RoutePaths.workoutDetail,
          name: RouteNames.workoutDetail,
          builder: (context, state) {
            final workoutId = state.pathParameters['workoutId']!;
            return WorkoutDetailScreen(workoutId: workoutId);
          },
        ),
        GoRoute(
          path: RoutePaths.activeWorkout,
          name: RouteNames.activeWorkout,
          builder: (context, state) {
            final workoutId = state.pathParameters['workoutId']!;
            return ActiveWorkoutScreen(workoutId: workoutId);
          },
        ),
        GoRoute(
          path: RoutePaths.workoutComplete,
          name: RouteNames.workoutComplete,
          builder: (context, state) {
            final workoutId = state.pathParameters['workoutId']!;
            return WorkoutCompleteScreen(workoutId: workoutId);
          },
        ),
        GoRoute(
          path: RoutePaths.workoutBuilder,
          name: RouteNames.workoutBuilder,
          builder: (context, state) => const WorkoutBuilderScreen(),
        ),
        GoRoute(
          path: RoutePaths.workoutBuilderEdit,
          builder: (context, state) {
            final workoutId = state.pathParameters['workoutId'];
            return WorkoutBuilderScreen(workoutId: workoutId);
          },
        ),
        GoRoute(
          path: RoutePaths.workoutTemplates,
          name: RouteNames.workoutTemplates,
          builder: (context, state) => const WorkoutTemplatesScreen(),
        ),

        // Exercise routes
        GoRoute(
          path: RoutePaths.exerciseLibrary,
          name: RouteNames.exerciseLibrary,
          builder: (context, state) => const ExerciseLibraryScreen(),
        ),
        GoRoute(
          path: RoutePaths.exerciseDetail,
          name: RouteNames.exerciseDetail,
          builder: (context, state) {
            final exerciseId = state.pathParameters['exerciseId']!;
            return ExerciseDetailScreen(exerciseId: exerciseId);
          },
        ),

        // Profile sub-routes
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: RoutePaths.gymProfiles,
          name: RouteNames.gymProfiles,
          builder: (context, state) => const GymProfilesScreen(),
        ),
        GoRoute(
          path: RoutePaths.workoutHistory,
          name: RouteNames.workoutHistory,
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: RoutePaths.progress,
          name: RouteNames.progress,
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: RoutePaths.achievements,
          name: RouteNames.achievements,
          builder: (context, state) => const AchievementsScreen(),
        ),
        GoRoute(
          path: RoutePaths.measurements,
          name: RouteNames.measurements,
          builder: (context, state) => const MeasurementsScreen(),
        ),
        GoRoute(
          path: RoutePaths.progressPhotos,
          name: RouteNames.progressPhotos,
          builder: (context, state) => const ProgressPhotosScreen(),
        ),
        GoRoute(
          path: RoutePaths.weightTracking,
          name: RouteNames.weightTracking,
          builder: (context, state) => const WeightTrackingScreen(),
        ),
        GoRoute(
          path: RoutePaths.plateCalculator,
          name: RouteNames.plateCalculator,
          builder: (context, state) => const PlateCalculatorScreen(),
        ),
        GoRoute(
          path: RoutePaths.oneRmCalculator,
          name: RouteNames.oneRmCalculator,
          builder: (context, state) => const OneRmCalculatorScreen(),
        ),
      ],

      // Error page
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(RoutePaths.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),

      // Redirect logic
      redirect: (context, state) {
        // TODO: Add auth state check here
        // final isLoggedIn = ref.read(authStateProvider).value != null;
        // final isOnAuthPage = state.matchedLocation == RoutePaths.login ||
        //     state.matchedLocation == RoutePaths.register;
        //
        // if (!isLoggedIn && !isOnAuthPage) {
        //   return RoutePaths.login;
        // }
        //
        // if (isLoggedIn && isOnAuthPage) {
        //   return RoutePaths.home;
        // }

        return null;
      },
    );
  }
}

/// Main shell widget with bottom navigation.
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNav(),
    );
  }
}

/// Bottom navigation bar for main app sections.
class MainBottomNav extends StatelessWidget {
  const MainBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine current index from location
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;

    if (location.startsWith(RoutePaths.home)) {
      currentIndex = 0;
    } else if (location.startsWith(RoutePaths.weeklyPlan)) {
      currentIndex = 1;
    } else if (location.startsWith(RoutePaths.coach)) {
      currentIndex = 2;
    } else if (location.startsWith(RoutePaths.profile)) {
      currentIndex = 3;
    }

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go(RoutePaths.home);
            break;
          case 1:
            context.go(RoutePaths.weeklyPlan);
            break;
          case 2:
            context.go(RoutePaths.coach);
            break;
          case 3:
            context.go(RoutePaths.profile);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Plan',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_outlined),
          selectedIcon: Icon(Icons.chat),
          label: 'Coach',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
