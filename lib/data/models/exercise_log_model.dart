import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'exercise_log_model.freezed.dart';
part 'exercise_log_model.g.dart';

/// Represents a logged exercise performance.
/// Stored in Firestore at: /users/{userId}/exerciseLogs/{logId}
@freezed
class ExerciseLog with _$ExerciseLog {
  const factory ExerciseLog({
    /// Unique identifier
    required String id,

    /// Reference to the workout this belongs to
    required String workoutId,

    /// Reference to the exercise performed
    required String exerciseId,

    /// Exercise name (denormalized for display)
    required String exerciseName,

    /// List of completed sets
    @Default([]) List<SetLog> sets,

    /// When this exercise was logged
    @TimestampConverter() required DateTime loggedAt,

    /// Optional notes from user
    String? userNotes,

    /// Whether logged in real-time or after workout
    @Default(false) bool loggedRealTime,

    /// Sync status for offline support: 'synced', 'pending', 'failed'
    @Default('synced') String syncStatus,
  }) = _ExerciseLog;

  factory ExerciseLog.fromJson(Map<String, dynamic> json) =>
      _$ExerciseLogFromJson(json);
}

/// Represents a single set within an exercise log.
@freezed
class SetLog with _$SetLog {
  const factory SetLog({
    /// Set number (1-indexed)
    required int setNumber,

    /// Repetitions completed
    required int reps,

    /// Weight used (0 for bodyweight)
    required double weight,

    /// Weight unit: 'lbs' or 'kg'
    @Default('lbs') String weightUnit,

    /// Whether this was a warmup set
    @Default(false) bool isWarmup,

    /// Whether this was a drop set
    @Default(false) bool isDropSet,

    /// Whether this was to failure
    @Default(false) bool isToFailure,

    /// Perceived difficulty: 'easy', 'moderate', 'hard', 'failure'
    String? difficulty,

    /// Time of completion (for tracking rest times)
    @NullableTimestampConverter() DateTime? completedAt,
  }) = _SetLog;

  factory SetLog.fromJson(Map<String, dynamic> json) => _$SetLogFromJson(json);
}

/// Sync status options
class SyncStatus {
  static const String synced = 'synced';
  static const String pending = 'pending';
  static const String failed = 'failed';

  static const List<String> all = [synced, pending, failed];
}

/// Set difficulty options
class SetDifficulty {
  static const String easy = 'easy';
  static const String moderate = 'moderate';
  static const String hard = 'hard';
  static const String failure = 'failure';

  static const List<String> all = [easy, moderate, hard, failure];

  static String getDisplayName(String difficulty) {
    switch (difficulty) {
      case easy:
        return 'Easy';
      case moderate:
        return 'Moderate';
      case hard:
        return 'Hard';
      case failure:
        return 'To Failure';
      default:
        return difficulty;
    }
  }

  static String getEmoji(String difficulty) {
    switch (difficulty) {
      case easy:
        return '😊';
      case moderate:
        return '💪';
      case hard:
        return '🔥';
      case failure:
        return '😤';
      default:
        return '';
    }
  }
}

/// Extension for calculating exercise log metrics
extension ExerciseLogMetrics on ExerciseLog {
  /// Total volume (weight x reps across all sets)
  double get totalVolume {
    return sets.fold(0, (sum, set) => sum + (set.weight * set.reps));
  }

  /// Total reps across all sets
  int get totalReps {
    return sets.fold(0, (sum, set) => sum + set.reps);
  }

  /// Number of working sets (excludes warmup)
  int get workingSets {
    return sets.where((set) => !set.isWarmup).length;
  }

  /// Max weight lifted
  double get maxWeight {
    if (sets.isEmpty) return 0;
    return sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
  }

  /// Average reps per set
  double get averageReps {
    if (sets.isEmpty) return 0;
    return totalReps / sets.length;
  }
}
