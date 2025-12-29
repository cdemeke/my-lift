import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'weekly_plan_model.freezed.dart';
part 'weekly_plan_model.g.dart';

/// Represents a generated weekly workout plan.
/// Stored in Firestore at: /users/{userId}/weeklyPlans/{planId}
@freezed
class WeeklyPlan with _$WeeklyPlan {
  const factory WeeklyPlan({
    /// Unique identifier
    required String id,

    /// Start date of the week (Monday)
    @TimestampConverter() required DateTime weekStartDate,

    /// End date of the week (Sunday)
    @TimestampConverter() required DateTime weekEndDate,

    /// List of workout IDs for this week
    @Default([]) List<String> workoutIds,

    /// Gym profile ID used for generation
    required String gymProfileId,

    /// When the plan was generated
    @TimestampConverter() required DateTime generatedAt,

    /// AI-generated summary of the week's focus
    String? weekSummary,

    /// Status: 'active', 'completed', 'archived'
    @Default('active') String status,

    /// Number of workouts completed this week
    @Default(0) int completedWorkouts,

    /// Total workouts planned
    @Default(0) int totalWorkouts,
  }) = _WeeklyPlan;

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) =>
      _$WeeklyPlanFromJson(json);
}

/// Weekly plan status options
class WeeklyPlanStatus {
  static const String active = 'active';
  static const String completed = 'completed';
  static const String archived = 'archived';

  static const List<String> all = [active, completed, archived];

  static String getDisplayName(String status) {
    switch (status) {
      case active:
        return 'Active';
      case completed:
        return 'Completed';
      case archived:
        return 'Archived';
      default:
        return status;
    }
  }
}
