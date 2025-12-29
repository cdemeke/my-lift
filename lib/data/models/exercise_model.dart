import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

/// Represents an exercise in the library.
/// Stored in Firestore at: /exercises/{exerciseId} (global, read-only)
@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    /// Unique identifier
    required String id,

    /// Exercise name
    required String name,

    /// Detailed description and instructions
    required String description,

    /// Primary muscle group targeted
    required String primaryMuscleGroup,

    /// Secondary muscle groups worked
    @Default([]) List<String> secondaryMuscleGroups,

    /// Required equipment IDs (empty for bodyweight)
    @Default([]) List<String> requiredEquipment,

    /// Exercise type: 'compound', 'isolation', 'cardio', 'mobility'
    required String exerciseType,

    /// Difficulty: 'beginner', 'intermediate', 'advanced'
    required String difficulty,

    /// Curated YouTube video ID (if available)
    String? youtubeVideoId,

    /// Search keywords for AI video lookup fallback
    @Default([]) List<String> videoSearchKeywords,

    /// Common mistakes to avoid
    @Default([]) List<String> commonMistakes,

    /// Tips for proper form
    @Default([]) List<String> formTips,

    /// Alternative exercise IDs
    @Default([]) List<String> alternativeExerciseIds,

    /// Whether this is a bodyweight exercise
    @Default(false) bool isBodyweight,

    /// Sort order within muscle group
    @Default(0) int sortOrder,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

/// Exercise type options
class ExerciseType {
  static const String compound = 'compound';
  static const String isolation = 'isolation';
  static const String cardio = 'cardio';
  static const String mobility = 'mobility';

  static const List<String> all = [compound, isolation, cardio, mobility];

  static String getDisplayName(String type) {
    switch (type) {
      case compound:
        return 'Compound';
      case isolation:
        return 'Isolation';
      case cardio:
        return 'Cardio';
      case mobility:
        return 'Mobility';
      default:
        return type;
    }
  }
}

/// Muscle group options
class MuscleGroup {
  static const String chest = 'chest';
  static const String back = 'back';
  static const String shoulders = 'shoulders';
  static const String biceps = 'biceps';
  static const String triceps = 'triceps';
  static const String forearms = 'forearms';
  static const String quads = 'quads';
  static const String hamstrings = 'hamstrings';
  static const String glutes = 'glutes';
  static const String calves = 'calves';
  static const String core = 'core';
  static const String fullBody = 'full_body';
  static const String cardio = 'cardio';

  static const List<String> all = [
    chest,
    back,
    shoulders,
    biceps,
    triceps,
    forearms,
    quads,
    hamstrings,
    glutes,
    calves,
    core,
    fullBody,
    cardio,
  ];

  static const List<String> upperBody = [
    chest,
    back,
    shoulders,
    biceps,
    triceps,
    forearms,
  ];

  static const List<String> lowerBody = [
    quads,
    hamstrings,
    glutes,
    calves,
  ];

  static String getDisplayName(String group) {
    switch (group) {
      case chest:
        return 'Chest';
      case back:
        return 'Back';
      case shoulders:
        return 'Shoulders';
      case biceps:
        return 'Biceps';
      case triceps:
        return 'Triceps';
      case forearms:
        return 'Forearms';
      case quads:
        return 'Quadriceps';
      case hamstrings:
        return 'Hamstrings';
      case glutes:
        return 'Glutes';
      case calves:
        return 'Calves';
      case core:
        return 'Core';
      case fullBody:
        return 'Full Body';
      case cardio:
        return 'Cardio';
      default:
        return group;
    }
  }
}

/// Difficulty level options
class ExerciseDifficulty {
  static const String beginner = 'beginner';
  static const String intermediate = 'intermediate';
  static const String advanced = 'advanced';

  static const List<String> all = [beginner, intermediate, advanced];

  static String getDisplayName(String difficulty) {
    switch (difficulty) {
      case beginner:
        return 'Beginner';
      case intermediate:
        return 'Intermediate';
      case advanced:
        return 'Advanced';
      default:
        return difficulty;
    }
  }
}
