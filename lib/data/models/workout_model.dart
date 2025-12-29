import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'workout_model.freezed.dart';
part 'workout_model.g.dart';

/// Represents a single workout session.
/// Stored in Firestore at: /users/{userId}/workouts/{workoutId}
@freezed
class Workout with _$Workout {
  const factory Workout({
    /// Unique identifier
    required String id,

    /// Reference to parent weekly plan
    required String weeklyPlanId,

    /// Workout name (e.g., "Push Day", "Full Body A")
    required String name,

    /// Scheduled date for this workout
    @TimestampConverter() required DateTime scheduledDate,

    /// Day of week (1=Monday, 7=Sunday)
    required int dayOfWeek,

    /// List of planned exercises
    required List<PlannedExercise> exercises,

    /// Workout focus areas
    @Default([]) List<String> targetMuscleGroups,

    /// Estimated duration in minutes
    required int estimatedDurationMinutes,

    /// Status: 'pending', 'in_progress', 'completed', 'skipped'
    @Default('pending') String status,

    /// When workout was started (null if not started)
    @NullableTimestampConverter() DateTime? startedAt,

    /// When workout was completed (null if not completed)
    @NullableTimestampConverter() DateTime? completedAt,

    /// AI-generated notes/tips for this workout
    String? coachNotes,

    /// Whether this workout was modified from original plan
    @Default(false) bool wasModified,
  }) = _Workout;

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);
}

/// Represents a planned exercise within a workout.
@freezed
class PlannedExercise with _$PlannedExercise {
  const factory PlannedExercise({
    /// Reference to exercise in the library
    required String exerciseId,

    /// Exercise name (denormalized for display)
    required String exerciseName,

    /// Order in the workout
    required int order,

    /// Target number of sets
    required int targetSets,

    /// Target rep range (e.g., "8-12")
    required String targetReps,

    /// Recommended rest time in seconds
    @Default(90) int restSeconds,

    /// Optional notes from AI coach
    String? notes,

    /// Whether this exercise was swapped from original
    @Default(false) bool wasSwapped,

    /// Original exercise ID if swapped
    String? originalExerciseId,

    /// Completion status: 'pending', 'completed', 'skipped'
    @Default('pending') String status,
  }) = _PlannedExercise;

  factory PlannedExercise.fromJson(Map<String, dynamic> json) =>
      _$PlannedExerciseFromJson(json);
}

/// Workout status options
class WorkoutStatus {
  static const String pending = 'pending';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String skipped = 'skipped';

  static const List<String> all = [pending, inProgress, completed, skipped];

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'Pending';
      case inProgress:
        return 'In Progress';
      case completed:
        return 'Completed';
      case skipped:
        return 'Skipped';
      default:
        return status;
    }
  }
}

/// Exercise status within a workout
class ExerciseStatus {
  static const String pending = 'pending';
  static const String completed = 'completed';
  static const String skipped = 'skipped';

  static const List<String> all = [pending, completed, skipped];
}
