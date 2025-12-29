/// Static strings used throughout the MyLift app.
class AppStrings {
  AppStrings._();

  // App info
  static const String appName = 'MyLift';
  static const String appTagline = 'Your AI Gym Assistant';

  // Auth screens
  static const String login = 'Log In';
  static const String signUp = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String orContinueWith = 'Or continue with';
  static const String continueWithGoogle = 'Continue with Google';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signOut = 'Sign Out';

  // Onboarding
  static const String welcome = 'Welcome to MyLift';
  static const String letsGetStarted = "Let's get you set up";
  static const String whatsYourGoal = "What's your fitness goal?";
  static const String selectEquipment = 'Select your available equipment';
  static const String setupGymProfile = 'Set up your gym profile';
  static const String youreAllSet = "You're all set!";
  static const String next = 'Next';
  static const String skip = 'Skip';
  static const String finish = 'Finish';
  static const String getStarted = 'Get Started';

  // Fitness goals
  static const String generalFitness = 'General Fitness';
  static const String generalFitnessDesc = 'Balanced strength, cardio, and mobility';
  static const String muscleBuilding = 'Muscle Building';
  static const String muscleBuildingDesc = 'Focus on hypertrophy and size';
  static const String weightLoss = 'Weight Loss';
  static const String weightLossDesc = 'Burn fat and improve conditioning';
  static const String strength = 'Strength';
  static const String strengthDesc = 'Build raw strength and power';

  // Experience levels
  static const String beginner = 'Beginner';
  static const String beginnerDesc = 'New to working out';
  static const String intermediate = 'Intermediate';
  static const String intermediateDesc = '1-3 years experience';
  static const String advanced = 'Advanced';
  static const String advancedDesc = '3+ years experience';

  // Gym profile types
  static const String homeGym = 'Home Gym';
  static const String commercialGym = 'Commercial Gym';
  static const String travel = 'Travel';
  static const String outdoor = 'Outdoor';
  static const String bodyweightOnly = 'Bodyweight Only';

  // Home screen
  static const String todaysWorkout = "Today's Workout";
  static const String noWorkoutToday = 'Rest day - no workout scheduled';
  static const String startWorkout = 'Start Workout';
  static const String quickLog = 'Quick Log';
  static const String viewDetails = 'View Details';
  static const String weeklyProgress = 'Weekly Progress';
  static const String workoutsCompleted = 'workouts completed';

  // Workout screens
  static const String weeklyPlan = 'Weekly Plan';
  static const String exercises = 'Exercises';
  static const String sets = 'Sets';
  static const String reps = 'Reps';
  static const String weight = 'Weight';
  static const String rest = 'Rest';
  static const String addSet = 'Add Set';
  static const String completeWorkout = 'Complete Workout';
  static const String finishWorkout = 'Finish Workout';
  static const String skipExercise = 'Skip Exercise';
  static const String swapExercise = 'Swap Exercise';
  static const String previousSet = 'Previous';
  static const String nextSet = 'Next';

  // Exercise swap
  static const String whySwapping = 'Why are you swapping?';
  static const String noEquipment = 'No equipment available';
  static const String injury = 'Injury or discomfort';
  static const String preference = 'Personal preference';
  static const String suggestAlternative = 'Suggest alternative';
  static const String browseExercises = 'Browse exercises';
  static const String quickSwap = 'Quick swap';

  // Coach
  static const String coach = 'Coach';
  static const String aiCoach = 'AI Coach';
  static const String askCoach = 'Ask your coach...';
  static const String coachGreeting = "Hey! I'm your AI coach. How can I help you today?";
  static const String missedWorkout = 'I noticed you missed a workout';
  static const String howCanIHelp = 'How can I help?';

  // Profile
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String fitnessGoals = 'Fitness Goals';
  static const String gymProfiles = 'Gym Profiles';
  static const String workoutHistory = 'Workout History';
  static const String notifications = 'Notifications';
  static const String units = 'Units';
  static const String about = 'About';

  // Units
  static const String lbs = 'lbs';
  static const String kg = 'kg';
  static const String minutes = 'min';
  static const String seconds = 'sec';

  // Status
  static const String pending = 'Pending';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String skipped = 'Skipped';

  // Days
  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> weekDaysShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Muscle groups
  static const String chest = 'Chest';
  static const String back = 'Back';
  static const String shoulders = 'Shoulders';
  static const String biceps = 'Biceps';
  static const String triceps = 'Triceps';
  static const String legs = 'Legs';
  static const String quads = 'Quads';
  static const String hamstrings = 'Hamstrings';
  static const String glutes = 'Glutes';
  static const String calves = 'Calves';
  static const String core = 'Core';
  static const String abs = 'Abs';
  static const String fullBody = 'Full Body';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet = 'No internet connection';
  static const String errorInvalidEmail = 'Please enter a valid email';
  static const String errorWeakPassword = 'Password must be at least 6 characters';
  static const String errorPasswordMismatch = 'Passwords do not match';
  static const String errorLoginFailed = 'Login failed. Please check your credentials.';
  static const String errorSignUpFailed = 'Sign up failed. Please try again.';

  // Success
  static const String workoutComplete = 'Workout Complete!';
  static const String greatJob = 'Great job!';
  static const String keepItUp = 'Keep it up!';
}
