import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Service for generating progressive overload suggestions
class ProgressiveOverloadService {
  /// Analyze exercise history and suggest next steps
  static OverloadSuggestion analyzeAndSuggest({
    required String exerciseName,
    required List<ExerciseSession> history,
    required ExerciseSession lastSession,
  }) {
    if (history.length < 3) {
      return OverloadSuggestion(
        type: OverloadType.maintain,
        message: 'Keep training! Need more data for suggestions.',
        details: 'Complete at least 3 sessions for personalized recommendations.',
        confidence: 0.3,
      );
    }

    // Analyze recent performance
    final recentSessions = history.take(5).toList();
    final avgRPE = recentSessions.map((s) => s.avgRPE).reduce((a, b) => a + b) / recentSessions.length;
    final completedAllSets = lastSession.completedSets >= lastSession.targetSets;
    final hitRepTarget = lastSession.avgReps >= lastSession.targetRepsMin;
    final exceededRepTarget = lastSession.avgReps > lastSession.targetRepsMax;

    // Check for stall (same weight for 3+ sessions without progress)
    final sameWeightSessions = recentSessions
        .where((s) => s.weight == lastSession.weight)
        .length;
    final isStalled = sameWeightSessions >= 3;

    // Generate suggestion based on analysis
    if (avgRPE < 6 && completedAllSets && hitRepTarget) {
      // Too easy - increase weight significantly
      final increase = _calculateWeightIncrease(lastSession.weight, 'large');
      return OverloadSuggestion(
        type: OverloadType.increaseWeight,
        message: 'Time to go heavier!',
        details: 'You\'re crushing it at ${lastSession.weight} lbs. '
            'RPE is low and you\'re hitting all reps easily.',
        suggestedWeight: lastSession.weight + increase,
        weightIncrease: increase,
        confidence: 0.9,
      );
    }

    if (avgRPE >= 6 && avgRPE <= 8 && completedAllSets && exceededRepTarget) {
      // Good progress - standard weight increase
      final increase = _calculateWeightIncrease(lastSession.weight, 'standard');
      return OverloadSuggestion(
        type: OverloadType.increaseWeight,
        message: 'Ready for more weight!',
        details: 'You exceeded your rep target at RPE ${avgRPE.toStringAsFixed(1)}. '
            'Great time to add ${increase.toStringAsFixed(0)} lbs.',
        suggestedWeight: lastSession.weight + increase,
        weightIncrease: increase,
        confidence: 0.85,
      );
    }

    if (avgRPE >= 6 && avgRPE <= 8 && completedAllSets && hitRepTarget && !exceededRepTarget) {
      // Solid work - suggest rep increase first
      return OverloadSuggestion(
        type: OverloadType.increaseReps,
        message: 'Add more reps!',
        details: 'You\'re at ${lastSession.avgReps.toStringAsFixed(0)} reps. '
            'Try to hit ${lastSession.targetRepsMax} reps before adding weight.',
        suggestedReps: lastSession.targetRepsMax,
        confidence: 0.8,
      );
    }

    if (avgRPE > 8.5 && !completedAllSets) {
      // Too hard - might need to deload or reduce
      return OverloadSuggestion(
        type: OverloadType.deload,
        message: 'Consider a deload',
        details: 'RPE is very high (${avgRPE.toStringAsFixed(1)}) and you missed sets. '
            'A deload week might help you recover and come back stronger.',
        suggestedWeight: lastSession.weight * 0.85,
        confidence: 0.75,
      );
    }

    if (isStalled) {
      // Stalled - suggest variation or strategic change
      return OverloadSuggestion(
        type: OverloadType.variation,
        message: 'Time to mix it up!',
        details: 'You\'ve been at ${lastSession.weight} lbs for 3+ sessions. '
            'Try a variation or change rep scheme to break through.',
        alternatives: [
          'Add a pause at the bottom',
          'Try tempo training (3-1-2)',
          'Switch to a variation exercise',
          'Do a heavy single, then back-off sets',
        ],
        confidence: 0.7,
      );
    }

    if (avgRPE >= 7 && avgRPE <= 8.5 && completedAllSets) {
      // Sweet spot - maintain
      return OverloadSuggestion(
        type: OverloadType.maintain,
        message: 'Perfect intensity!',
        details: 'RPE ${avgRPE.toStringAsFixed(1)} is ideal for building strength. '
            'Keep at ${lastSession.weight} lbs and focus on quality reps.',
        confidence: 0.85,
      );
    }

    // Default: maintain current
    return OverloadSuggestion(
      type: OverloadType.maintain,
      message: 'Stay the course',
      details: 'Keep working at ${lastSession.weight} lbs. '
          'Focus on form and consistency.',
      confidence: 0.6,
    );
  }

  static double _calculateWeightIncrease(double currentWeight, String size) {
    // Upper body typically 2.5-5 lbs, lower body 5-10 lbs
    switch (size) {
      case 'large':
        if (currentWeight < 100) return 5;
        if (currentWeight < 200) return 10;
        return 10;
      case 'standard':
        if (currentWeight < 100) return 2.5;
        if (currentWeight < 200) return 5;
        return 5;
      case 'small':
        return 2.5;
      default:
        return 5;
    }
  }

  /// Generate a training block suggestion
  static TrainingBlockSuggestion suggestTrainingBlock({
    required String exerciseName,
    required double current1RM,
    required int weeksToRun,
  }) {
    final weeks = <WeekPlan>[];

    for (int week = 1; week <= weeksToRun; week++) {
      double intensity;
      int reps;
      int sets;

      if (week <= weeksToRun ~/ 3) {
        // Accumulation phase
        intensity = 0.70 + (week * 0.02);
        reps = 8;
        sets = 4;
      } else if (week <= (weeksToRun * 2) ~/ 3) {
        // Transmutation phase
        intensity = 0.78 + ((week - weeksToRun ~/ 3) * 0.03);
        reps = 5;
        sets = 5;
      } else {
        // Realization phase
        intensity = 0.88 + ((week - (weeksToRun * 2) ~/ 3) * 0.03);
        reps = 3;
        sets = 5;
      }

      weeks.add(WeekPlan(
        weekNumber: week,
        weight: (current1RM * intensity).roundToDouble(),
        reps: reps,
        sets: sets,
        intensity: intensity,
        phase: week <= weeksToRun ~/ 3
            ? 'Accumulation'
            : week <= (weeksToRun * 2) ~/ 3
                ? 'Transmutation'
                : 'Realization',
      ));
    }

    return TrainingBlockSuggestion(
      exerciseName: exerciseName,
      current1RM: current1RM,
      projected1RM: current1RM * 1.05, // ~5% increase expected
      weeks: weeks,
    );
  }
}

/// Types of overload suggestions
enum OverloadType {
  increaseWeight,
  increaseReps,
  increaseSets,
  maintain,
  deload,
  variation,
}

/// Overload suggestion model
class OverloadSuggestion {
  final OverloadType type;
  final String message;
  final String details;
  final double? suggestedWeight;
  final double? weightIncrease;
  final int? suggestedReps;
  final int? suggestedSets;
  final List<String>? alternatives;
  final double confidence; // 0.0 to 1.0

  const OverloadSuggestion({
    required this.type,
    required this.message,
    required this.details,
    this.suggestedWeight,
    this.weightIncrease,
    this.suggestedReps,
    this.suggestedSets,
    this.alternatives,
    required this.confidence,
  });

  Color get color {
    switch (type) {
      case OverloadType.increaseWeight:
        return Colors.green;
      case OverloadType.increaseReps:
        return Colors.blue;
      case OverloadType.increaseSets:
        return Colors.purple;
      case OverloadType.maintain:
        return AppColors.primary;
      case OverloadType.deload:
        return Colors.orange;
      case OverloadType.variation:
        return Colors.teal;
    }
  }

  IconData get icon {
    switch (type) {
      case OverloadType.increaseWeight:
        return Icons.trending_up;
      case OverloadType.increaseReps:
        return Icons.repeat;
      case OverloadType.increaseSets:
        return Icons.add_box;
      case OverloadType.maintain:
        return Icons.check_circle;
      case OverloadType.deload:
        return Icons.hotel;
      case OverloadType.variation:
        return Icons.shuffle;
    }
  }
}

/// Exercise session data for analysis
class ExerciseSession {
  final DateTime date;
  final double weight;
  final int completedSets;
  final int targetSets;
  final double avgReps;
  final int targetRepsMin;
  final int targetRepsMax;
  final double avgRPE;

  const ExerciseSession({
    required this.date,
    required this.weight,
    required this.completedSets,
    required this.targetSets,
    required this.avgReps,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.avgRPE,
  });
}

/// Training block suggestion
class TrainingBlockSuggestion {
  final String exerciseName;
  final double current1RM;
  final double projected1RM;
  final List<WeekPlan> weeks;

  const TrainingBlockSuggestion({
    required this.exerciseName,
    required this.current1RM,
    required this.projected1RM,
    required this.weeks,
  });
}

/// Week plan within training block
class WeekPlan {
  final int weekNumber;
  final double weight;
  final int reps;
  final int sets;
  final double intensity;
  final String phase;

  const WeekPlan({
    required this.weekNumber,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.intensity,
    required this.phase,
  });
}
