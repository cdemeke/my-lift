/// Route name constants for navigation.
class RouteNames {
  RouteNames._();

  // Auth routes
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';

  // Onboarding routes
  static const String onboarding = 'onboarding';
  static const String fitnessGoals = 'fitness-goals';
  static const String equipmentSetup = 'equipment-setup';
  static const String gymProfileSetup = 'gym-profile-setup';

  // Main routes (with bottom nav)
  static const String home = 'home';
  static const String weeklyPlan = 'weekly-plan';
  static const String coach = 'coach';
  static const String profile = 'profile';
  static const String progress = 'progress';

  // Workout routes
  static const String workoutDetail = 'workout-detail';
  static const String activeWorkout = 'active-workout';
  static const String workoutComplete = 'workout-complete';
  static const String quickLog = 'quick-log';

  // Exercise routes
  static const String exerciseLibrary = 'exercise-library';
  static const String exerciseDetail = 'exercise-detail';
  static const String videoPlayer = 'video-player';

  // Profile routes
  static const String settings = 'settings';
  static const String gymProfiles = 'gym-profiles';
  static const String editGymProfile = 'edit-gym-profile';
  static const String editGoals = 'edit-goals';
  static const String workoutHistory = 'workout-history';
  static const String historyDetail = 'history-detail';
  static const String achievements = 'achievements';
}

/// Route path constants.
class RoutePaths {
  RoutePaths._();

  // Auth paths
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Onboarding paths
  static const String onboarding = '/onboarding';
  static const String fitnessGoals = '/onboarding/goals';
  static const String equipmentSetup = '/onboarding/equipment';
  static const String gymProfileSetup = '/onboarding/gym-profile';

  // Main paths
  static const String home = '/home';
  static const String weeklyPlan = '/plan';
  static const String coach = '/coach';
  static const String profile = '/profile';
  static const String progress = '/progress';

  // Workout paths
  static const String workoutDetail = '/workout/:workoutId';
  static const String activeWorkout = '/workout/:workoutId/active';
  static const String workoutComplete = '/workout/:workoutId/complete';
  static const String quickLog = '/workout/:workoutId/quick-log';

  // Exercise paths
  static const String exerciseLibrary = '/exercises';
  static const String exerciseDetail = '/exercises/:exerciseId';
  static const String videoPlayer = '/exercises/:exerciseId/video';

  // Profile paths
  static const String settings = '/profile/settings';
  static const String gymProfiles = '/profile/gyms';
  static const String editGymProfile = '/profile/gyms/:profileId';
  static const String editGoals = '/profile/goals';
  static const String workoutHistory = '/profile/history';
  static const String historyDetail = '/profile/history/:logId';
  static const String achievements = '/achievements';

  /// Build workout detail path with ID.
  static String workoutDetailPath(String workoutId) => '/workout/$workoutId';

  /// Build active workout path with ID.
  static String activeWorkoutPath(String workoutId) =>
      '/workout/$workoutId/active';

  /// Build workout complete path with ID.
  static String workoutCompletePath(String workoutId) =>
      '/workout/$workoutId/complete';

  /// Build quick log path with ID.
  static String quickLogPath(String workoutId) =>
      '/workout/$workoutId/quick-log';

  /// Build exercise detail path with ID.
  static String exerciseDetailPath(String exerciseId) =>
      '/exercises/$exerciseId';

  /// Build video player path with exercise ID.
  static String videoPlayerPath(String exerciseId) =>
      '/exercises/$exerciseId/video';

  /// Build edit gym profile path with ID.
  static String editGymProfilePath(String profileId) =>
      '/profile/gyms/$profileId';

  /// Build history detail path with log ID.
  static String historyDetailPath(String logId) => '/profile/history/$logId';
}
