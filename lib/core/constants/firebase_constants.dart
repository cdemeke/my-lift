/// Firebase collection and field name constants.
class FirebaseConstants {
  FirebaseConstants._();

  // Collection names
  static const String usersCollection = 'users';
  static const String gymProfilesCollection = 'gymProfiles';
  static const String weeklyPlansCollection = 'weeklyPlans';
  static const String workoutsCollection = 'workouts';
  static const String exerciseLogsCollection = 'exerciseLogs';
  static const String chatHistoryCollection = 'chatHistory';
  static const String exercisesCollection = 'exercises';
  static const String equipmentCollection = 'equipment';

  // User document fields
  static const String fieldUid = 'uid';
  static const String fieldEmail = 'email';
  static const String fieldDisplayName = 'displayName';
  static const String fieldPhotoUrl = 'photoUrl';
  static const String fieldFitnessGoals = 'fitnessGoals';
  static const String fieldActiveGymProfileId = 'activeGymProfileId';
  static const String fieldOnboardingComplete = 'onboardingComplete';
  static const String fieldFcmToken = 'fcmToken';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldLastActiveAt = 'lastActiveAt';

  // Fitness goals fields
  static const String fieldPrimaryGoal = 'primaryGoal';
  static const String fieldExperienceLevel = 'experienceLevel';
  static const String fieldWorkoutDaysPerWeek = 'workoutDaysPerWeek';
  static const String fieldPreferredDurationMinutes = 'preferredDurationMinutes';
  static const String fieldStrengthFocus = 'strengthFocus';
  static const String fieldCardioFocus = 'cardioFocus';
  static const String fieldMobilityFocus = 'mobilityFocus';
  static const String fieldInjuryNotes = 'injuryNotes';

  // Gym profile fields
  static const String fieldId = 'id';
  static const String fieldName = 'name';
  static const String fieldType = 'type';
  static const String fieldEquipmentIds = 'equipmentIds';
  static const String fieldNotes = 'notes';
  static const String fieldIcon = 'icon';
  static const String fieldIsDefault = 'isDefault';

  // Workout fields
  static const String fieldWeeklyPlanId = 'weeklyPlanId';
  static const String fieldScheduledDate = 'scheduledDate';
  static const String fieldDayOfWeek = 'dayOfWeek';
  static const String fieldExercises = 'exercises';
  static const String fieldTargetMuscleGroups = 'targetMuscleGroups';
  static const String fieldEstimatedDurationMinutes = 'estimatedDurationMinutes';
  static const String fieldStatus = 'status';
  static const String fieldStartedAt = 'startedAt';
  static const String fieldCompletedAt = 'completedAt';
  static const String fieldCoachNotes = 'coachNotes';
  static const String fieldWasModified = 'wasModified';

  // Exercise log fields
  static const String fieldWorkoutId = 'workoutId';
  static const String fieldExerciseId = 'exerciseId';
  static const String fieldSets = 'sets';
  static const String fieldLoggedAt = 'loggedAt';
  static const String fieldUserNotes = 'userNotes';
  static const String fieldLoggedRealTime = 'loggedRealTime';
  static const String fieldSyncStatus = 'syncStatus';

  // Set log fields
  static const String fieldSetNumber = 'setNumber';
  static const String fieldReps = 'reps';
  static const String fieldWeight = 'weight';
  static const String fieldWeightUnit = 'weightUnit';
  static const String fieldIsWarmup = 'isWarmup';
  static const String fieldIsDropSet = 'isDropSet';
  static const String fieldDifficulty = 'difficulty';

  // Chat message fields
  static const String fieldRole = 'role';
  static const String fieldContent = 'content';
  static const String fieldTimestamp = 'timestamp';
  static const String fieldContextType = 'contextType';
  static const String fieldRelatedWorkoutId = 'relatedWorkoutId';
  static const String fieldRelatedExerciseId = 'relatedExerciseId';

  // Status values
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusSkipped = 'skipped';

  // Sync status values
  static const String syncStatusSynced = 'synced';
  static const String syncStatusPending = 'pending';
  static const String syncStatusFailed = 'failed';

  // Chat roles
  static const String roleUser = 'user';
  static const String roleCoach = 'coach';
}
