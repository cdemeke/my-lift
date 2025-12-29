import 'package:freezed_annotation/freezed_annotation.dart';

part 'fitness_goals_model.freezed.dart';
part 'fitness_goals_model.g.dart';

/// User's fitness goals and preferences for workout generation.
/// Embedded within UserModel.
@freezed
class FitnessGoals with _$FitnessGoals {
  const factory FitnessGoals({
    /// Primary goal: 'general_fitness', 'muscle_building', 'weight_loss', 'strength'
    @Default('general_fitness') String primaryGoal,

    /// Experience level: 'beginner', 'intermediate', 'advanced'
    @Default('beginner') String experienceLevel,

    /// Target workout days per week (1-7)
    @Default(4) int workoutDaysPerWeek,

    /// Preferred workout duration in minutes
    @Default(45) int preferredDurationMinutes,

    /// Balance preferences (0.0 to 1.0 each, should sum to 1.0)
    @Default(0.5) double strengthFocus,
    @Default(0.3) double cardioFocus,
    @Default(0.2) double mobilityFocus,

    /// Any injuries or areas to avoid
    @Default([]) List<String> injuryNotes,
  }) = _FitnessGoals;

  factory FitnessGoals.fromJson(Map<String, dynamic> json) =>
      _$FitnessGoalsFromJson(json);
}

/// Primary goal options
class FitnessGoalType {
  static const String generalFitness = 'general_fitness';
  static const String muscleBuilding = 'muscle_building';
  static const String weightLoss = 'weight_loss';
  static const String strength = 'strength';

  static const List<String> all = [
    generalFitness,
    muscleBuilding,
    weightLoss,
    strength,
  ];

  static String getDisplayName(String goal) {
    switch (goal) {
      case generalFitness:
        return 'General Fitness';
      case muscleBuilding:
        return 'Muscle Building';
      case weightLoss:
        return 'Weight Loss';
      case strength:
        return 'Strength';
      default:
        return goal;
    }
  }

  static String getDescription(String goal) {
    switch (goal) {
      case generalFitness:
        return 'Balanced strength, cardio, and mobility';
      case muscleBuilding:
        return 'Focus on hypertrophy and muscle size';
      case weightLoss:
        return 'Burn fat and improve conditioning';
      case strength:
        return 'Build raw strength and power';
      default:
        return '';
    }
  }
}

/// Experience level options
class ExperienceLevel {
  static const String beginner = 'beginner';
  static const String intermediate = 'intermediate';
  static const String advanced = 'advanced';

  static const List<String> all = [beginner, intermediate, advanced];

  static String getDisplayName(String level) {
    switch (level) {
      case beginner:
        return 'Beginner';
      case intermediate:
        return 'Intermediate';
      case advanced:
        return 'Advanced';
      default:
        return level;
    }
  }

  static String getDescription(String level) {
    switch (level) {
      case beginner:
        return 'New to working out (0-1 year)';
      case intermediate:
        return 'Some experience (1-3 years)';
      case advanced:
        return 'Experienced (3+ years)';
      default:
        return '';
    }
  }
}
