import 'package:flutter/material.dart';

/// Service for calculating recovery scores and readiness
class RecoveryService {
  /// Calculate overall recovery score (0-100)
  static RecoveryScore calculateRecoveryScore({
    required List<WorkoutLog> recentWorkouts,
    required int hoursSleptLastNight,
    required int perceivedStressLevel, // 1-10
    required int perceivedSoreness, // 1-10
    DateTime? lastWorkoutDate,
  }) {
    double score = 100.0;
    final factors = <RecoveryFactor>[];

    // Factor 1: Training load (last 7 days)
    final weeklyVolume = _calculateWeeklyVolume(recentWorkouts);
    final volumeImpact = _assessVolumeImpact(weeklyVolume);
    score += volumeImpact.impact;
    factors.add(volumeImpact);

    // Factor 2: Days since last workout
    if (lastWorkoutDate != null) {
      final daysSinceWorkout = DateTime.now().difference(lastWorkoutDate).inDays;
      final restImpact = _assessRestDays(daysSinceWorkout);
      score += restImpact.impact;
      factors.add(restImpact);
    }

    // Factor 3: Sleep quality
    final sleepImpact = _assessSleep(hoursSleptLastNight);
    score += sleepImpact.impact;
    factors.add(sleepImpact);

    // Factor 4: Stress level
    final stressImpact = _assessStress(perceivedStressLevel);
    score += stressImpact.impact;
    factors.add(stressImpact);

    // Factor 5: Muscle soreness
    final sorenessImpact = _assessSoreness(perceivedSoreness);
    score += sorenessImpact.impact;
    factors.add(sorenessImpact);

    // Clamp to 0-100
    score = score.clamp(0, 100);

    return RecoveryScore(
      score: score.round(),
      status: _getRecoveryStatus(score),
      recommendation: _getRecommendation(score, factors),
      factors: factors,
      readyMuscleGroups: _getReadyMuscleGroups(recentWorkouts),
      fatiguedMuscleGroups: _getFatiguedMuscleGroups(recentWorkouts),
    );
  }

  static double _calculateWeeklyVolume(List<WorkoutLog> workouts) {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentWorkouts = workouts.where((w) => w.date.isAfter(oneWeekAgo));
    return recentWorkouts.fold(0.0, (sum, w) => sum + w.totalVolume);
  }

  static RecoveryFactor _assessVolumeImpact(double weeklyVolume) {
    // Baseline assumption: moderate volume is good
    if (weeklyVolume < 10000) {
      return RecoveryFactor(
        name: 'Training Volume',
        status: 'Low',
        impact: 5,
        description: 'Light training load - well recovered',
        icon: Icons.fitness_center,
        color: Colors.green,
      );
    } else if (weeklyVolume < 30000) {
      return RecoveryFactor(
        name: 'Training Volume',
        status: 'Moderate',
        impact: 0,
        description: 'Balanced training load',
        icon: Icons.fitness_center,
        color: Colors.blue,
      );
    } else if (weeklyVolume < 50000) {
      return RecoveryFactor(
        name: 'Training Volume',
        status: 'High',
        impact: -10,
        description: 'Heavy training load - monitor recovery',
        icon: Icons.fitness_center,
        color: Colors.orange,
      );
    } else {
      return RecoveryFactor(
        name: 'Training Volume',
        status: 'Very High',
        impact: -20,
        description: 'Very high load - consider deload',
        icon: Icons.fitness_center,
        color: Colors.red,
      );
    }
  }

  static RecoveryFactor _assessRestDays(int days) {
    if (days == 0) {
      return RecoveryFactor(
        name: 'Rest',
        status: 'Just Trained',
        impact: -15,
        description: 'Trained today - muscles need recovery',
        icon: Icons.hotel,
        color: Colors.orange,
      );
    } else if (days == 1) {
      return RecoveryFactor(
        name: 'Rest',
        status: '1 Day Rest',
        impact: -5,
        description: '1 day since last workout',
        icon: Icons.hotel,
        color: Colors.yellow.shade700,
      );
    } else if (days == 2) {
      return RecoveryFactor(
        name: 'Rest',
        status: 'Recovered',
        impact: 5,
        description: '2 days rest - good recovery time',
        icon: Icons.hotel,
        color: Colors.green,
      );
    } else if (days <= 4) {
      return RecoveryFactor(
        name: 'Rest',
        status: 'Well Rested',
        impact: 10,
        description: 'Fully recovered',
        icon: Icons.hotel,
        color: Colors.green,
      );
    } else {
      return RecoveryFactor(
        name: 'Rest',
        status: 'Extended Rest',
        impact: 5,
        description: 'Long rest period - ready to train',
        icon: Icons.hotel,
        color: Colors.blue,
      );
    }
  }

  static RecoveryFactor _assessSleep(int hours) {
    if (hours >= 8) {
      return RecoveryFactor(
        name: 'Sleep',
        status: 'Excellent',
        impact: 10,
        description: '$hours hours - optimal recovery',
        icon: Icons.bedtime,
        color: Colors.green,
      );
    } else if (hours >= 7) {
      return RecoveryFactor(
        name: 'Sleep',
        status: 'Good',
        impact: 5,
        description: '$hours hours - adequate rest',
        icon: Icons.bedtime,
        color: Colors.lightGreen,
      );
    } else if (hours >= 6) {
      return RecoveryFactor(
        name: 'Sleep',
        status: 'Fair',
        impact: -5,
        description: '$hours hours - could use more',
        icon: Icons.bedtime,
        color: Colors.orange,
      );
    } else {
      return RecoveryFactor(
        name: 'Sleep',
        status: 'Poor',
        impact: -15,
        description: '$hours hours - recovery impaired',
        icon: Icons.bedtime,
        color: Colors.red,
      );
    }
  }

  static RecoveryFactor _assessStress(int level) {
    if (level <= 3) {
      return RecoveryFactor(
        name: 'Stress',
        status: 'Low',
        impact: 5,
        description: 'Relaxed state - good for training',
        icon: Icons.spa,
        color: Colors.green,
      );
    } else if (level <= 5) {
      return RecoveryFactor(
        name: 'Stress',
        status: 'Moderate',
        impact: 0,
        description: 'Normal stress levels',
        icon: Icons.spa,
        color: Colors.blue,
      );
    } else if (level <= 7) {
      return RecoveryFactor(
        name: 'Stress',
        status: 'Elevated',
        impact: -10,
        description: 'Higher stress - impacts recovery',
        icon: Icons.spa,
        color: Colors.orange,
      );
    } else {
      return RecoveryFactor(
        name: 'Stress',
        status: 'High',
        impact: -20,
        description: 'High stress - consider rest day',
        icon: Icons.spa,
        color: Colors.red,
      );
    }
  }

  static RecoveryFactor _assessSoreness(int level) {
    if (level <= 2) {
      return RecoveryFactor(
        name: 'Soreness',
        status: 'None',
        impact: 5,
        description: 'No muscle soreness',
        icon: Icons.accessibility_new,
        color: Colors.green,
      );
    } else if (level <= 4) {
      return RecoveryFactor(
        name: 'Soreness',
        status: 'Mild',
        impact: 0,
        description: 'Light DOMS - normal recovery',
        icon: Icons.accessibility_new,
        color: Colors.blue,
      );
    } else if (level <= 6) {
      return RecoveryFactor(
        name: 'Soreness',
        status: 'Moderate',
        impact: -10,
        description: 'Noticeable soreness - train different muscles',
        icon: Icons.accessibility_new,
        color: Colors.orange,
      );
    } else {
      return RecoveryFactor(
        name: 'Soreness',
        status: 'Severe',
        impact: -20,
        description: 'Significant soreness - rest recommended',
        icon: Icons.accessibility_new,
        color: Colors.red,
      );
    }
  }

  static RecoveryStatus _getRecoveryStatus(double score) {
    if (score >= 85) return RecoveryStatus.optimal;
    if (score >= 70) return RecoveryStatus.good;
    if (score >= 50) return RecoveryStatus.moderate;
    if (score >= 30) return RecoveryStatus.low;
    return RecoveryStatus.depleted;
  }

  static String _getRecommendation(double score, List<RecoveryFactor> factors) {
    if (score >= 85) {
      return 'You\'re fully recovered and ready for an intense workout. '
          'Great day to push for PRs or tackle your hardest exercises.';
    } else if (score >= 70) {
      return 'Good recovery status. You can train at normal intensity. '
          'Listen to your body and don\'t push too hard if something feels off.';
    } else if (score >= 50) {
      return 'Moderate recovery. Consider a lighter workout or focus on '
          'muscle groups that feel fresh. Active recovery is a good option.';
    } else if (score >= 30) {
      return 'Recovery is compromised. Light movement or stretching recommended. '
          'Address the limiting factors (sleep, stress) before intense training.';
    } else {
      return 'Take a rest day. Your body needs time to recover. '
          'Focus on sleep, nutrition, and stress management.';
    }
  }

  static List<String> _getReadyMuscleGroups(List<WorkoutLog> workouts) {
    final muscleLastTrained = <String, DateTime>{};

    for (final workout in workouts) {
      for (final muscle in workout.muscleGroups) {
        if (!muscleLastTrained.containsKey(muscle) ||
            workout.date.isAfter(muscleLastTrained[muscle]!)) {
          muscleLastTrained[muscle] = workout.date;
        }
      }
    }

    final ready = <String>[];
    final now = DateTime.now();

    for (final entry in muscleLastTrained.entries) {
      final daysSince = now.difference(entry.value).inDays;
      if (daysSince >= 2) {
        ready.add(entry.key);
      }
    }

    // Add muscles never trained
    const allMuscles = ['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps',
        'Quadriceps', 'Hamstrings', 'Glutes', 'Calves', 'Core'];
    for (final muscle in allMuscles) {
      if (!muscleLastTrained.containsKey(muscle)) {
        ready.add(muscle);
      }
    }

    return ready;
  }

  static List<String> _getFatiguedMuscleGroups(List<WorkoutLog> workouts) {
    final muscleLastTrained = <String, DateTime>{};

    for (final workout in workouts) {
      for (final muscle in workout.muscleGroups) {
        if (!muscleLastTrained.containsKey(muscle) ||
            workout.date.isAfter(muscleLastTrained[muscle]!)) {
          muscleLastTrained[muscle] = workout.date;
        }
      }
    }

    final fatigued = <String>[];
    final now = DateTime.now();

    for (final entry in muscleLastTrained.entries) {
      final daysSince = now.difference(entry.value).inDays;
      if (daysSince < 2) {
        fatigued.add(entry.key);
      }
    }

    return fatigued;
  }
}

/// Recovery status levels
enum RecoveryStatus {
  optimal,
  good,
  moderate,
  low,
  depleted,
}

/// Overall recovery score
class RecoveryScore {
  final int score;
  final RecoveryStatus status;
  final String recommendation;
  final List<RecoveryFactor> factors;
  final List<String> readyMuscleGroups;
  final List<String> fatiguedMuscleGroups;

  const RecoveryScore({
    required this.score,
    required this.status,
    required this.recommendation,
    required this.factors,
    required this.readyMuscleGroups,
    required this.fatiguedMuscleGroups,
  });

  Color get color {
    switch (status) {
      case RecoveryStatus.optimal:
        return Colors.green;
      case RecoveryStatus.good:
        return Colors.lightGreen;
      case RecoveryStatus.moderate:
        return Colors.orange;
      case RecoveryStatus.low:
        return Colors.deepOrange;
      case RecoveryStatus.depleted:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case RecoveryStatus.optimal:
        return 'Optimal';
      case RecoveryStatus.good:
        return 'Good';
      case RecoveryStatus.moderate:
        return 'Moderate';
      case RecoveryStatus.low:
        return 'Low';
      case RecoveryStatus.depleted:
        return 'Depleted';
    }
  }
}

/// Individual recovery factor
class RecoveryFactor {
  final String name;
  final String status;
  final double impact;
  final String description;
  final IconData icon;
  final Color color;

  const RecoveryFactor({
    required this.name,
    required this.status,
    required this.impact,
    required this.description,
    required this.icon,
    required this.color,
  });
}

/// Workout log for recovery calculation
class WorkoutLog {
  final DateTime date;
  final List<String> muscleGroups;
  final double totalVolume;
  final int duration; // minutes

  const WorkoutLog({
    required this.date,
    required this.muscleGroups,
    required this.totalVolume,
    required this.duration,
  });
}
