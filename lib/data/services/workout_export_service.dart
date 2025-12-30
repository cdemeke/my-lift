import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Service for exporting and sharing workouts
class WorkoutExportService {
  /// Export workout as JSON
  static String exportAsJson(WorkoutTemplate workout) {
    return const JsonEncoder.withIndent('  ').convert(workout.toJson());
  }

  /// Export workout as readable text format
  static String exportAsText(WorkoutTemplate workout) {
    final buffer = StringBuffer();

    buffer.writeln('═' * 50);
    buffer.writeln('  ${workout.name.toUpperCase()}');
    buffer.writeln('═' * 50);
    buffer.writeln();

    buffer.writeln('📋 Overview');
    buffer.writeln('─' * 30);
    buffer.writeln('Target: ${workout.targetMuscles.join(", ")}');
    buffer.writeln('Duration: ~${workout.estimatedDuration} minutes');
    buffer.writeln('Difficulty: ${workout.difficulty}');
    if (workout.description != null) {
      buffer.writeln('Notes: ${workout.description}');
    }
    buffer.writeln();

    buffer.writeln('💪 Exercises');
    buffer.writeln('─' * 30);

    for (int i = 0; i < workout.exercises.length; i++) {
      final exercise = workout.exercises[i];
      buffer.writeln();
      buffer.writeln('${i + 1}. ${exercise.name}');
      buffer.writeln('   Sets: ${exercise.sets}');
      buffer.writeln('   Reps: ${exercise.repsMin}-${exercise.repsMax}');
      buffer.writeln('   Rest: ${exercise.restSeconds}s');
      if (exercise.notes != null) {
        buffer.writeln('   Note: ${exercise.notes}');
      }
    }

    buffer.writeln();
    buffer.writeln('─' * 30);
    buffer.writeln('Exported from MyLift');
    buffer.writeln('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');

    return buffer.toString();
  }

  /// Export workout as CSV format
  static String exportAsCsv(WorkoutTemplate workout) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Exercise,Sets,Reps Min,Reps Max,Rest (s),Notes');

    // Data rows
    for (final exercise in workout.exercises) {
      buffer.writeln([
        _escapeCsv(exercise.name),
        exercise.sets,
        exercise.repsMin,
        exercise.repsMax,
        exercise.restSeconds,
        _escapeCsv(exercise.notes ?? ''),
      ].join(','));
    }

    return buffer.toString();
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Generate shareable link (mock - would integrate with backend)
  static String generateShareLink(WorkoutTemplate workout) {
    final encoded = base64Encode(utf8.encode(exportAsJson(workout)));
    return 'mylift://workout/$encoded';
  }

  /// Parse shared workout from link
  static WorkoutTemplate? parseShareLink(String link) {
    try {
      final prefix = 'mylift://workout/';
      if (!link.startsWith(prefix)) return null;

      final encoded = link.substring(prefix.length);
      final json = utf8.decode(base64Decode(encoded));
      final map = jsonDecode(json) as Map<String, dynamic>;
      return WorkoutTemplate.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Export workout history as summary
  static String exportWorkoutHistory(List<CompletedWorkout> workouts) {
    final buffer = StringBuffer();

    buffer.writeln('MyLift Workout History');
    buffer.writeln('Exported: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}');
    buffer.writeln();
    buffer.writeln('═' * 50);

    for (final workout in workouts) {
      buffer.writeln();
      buffer.writeln('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(workout.date)}');
      buffer.writeln('Workout: ${workout.name}');
      buffer.writeln('Duration: ${workout.duration} minutes');
      buffer.writeln('Exercises: ${workout.exerciseCount}');
      buffer.writeln('Sets: ${workout.totalSets}');
      buffer.writeln('Volume: ${workout.totalVolume.toStringAsFixed(0)} lbs');
      buffer.writeln('─' * 30);
    }

    final totalWorkouts = workouts.length;
    final totalVolume = workouts.fold(0.0, (sum, w) => sum + w.totalVolume);
    final totalDuration = workouts.fold(0, (sum, w) => sum + w.duration);

    buffer.writeln();
    buffer.writeln('📊 Summary');
    buffer.writeln('Total Workouts: $totalWorkouts');
    buffer.writeln('Total Volume: ${(totalVolume / 1000).toStringAsFixed(1)}k lbs');
    buffer.writeln('Total Time: ${(totalDuration / 60).toStringAsFixed(1)} hours');

    return buffer.toString();
  }

  /// Copy to clipboard with feedback
  static Future<void> copyToClipboard(BuildContext context, String content) async {
    await Clipboard.setData(ClipboardData(text: content));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

/// Workout template for export/import
class WorkoutTemplate {
  final String id;
  final String name;
  final String? description;
  final List<String> targetMuscles;
  final int estimatedDuration;
  final String difficulty;
  final List<ExerciseTemplate> exercises;

  const WorkoutTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.targetMuscles,
    required this.estimatedDuration,
    required this.difficulty,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'targetMuscles': targetMuscles,
        'estimatedDuration': estimatedDuration,
        'difficulty': difficulty,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
      };

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    return WorkoutTemplate(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'],
      description: json['description'],
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      estimatedDuration: json['estimatedDuration'] ?? 60,
      difficulty: json['difficulty'] ?? 'Intermediate',
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseTemplate.fromJson(e))
          .toList(),
    );
  }
}

/// Exercise template for export/import
class ExerciseTemplate {
  final String name;
  final int sets;
  final int repsMin;
  final int repsMax;
  final int restSeconds;
  final String? notes;

  const ExerciseTemplate({
    required this.name,
    required this.sets,
    required this.repsMin,
    required this.repsMax,
    required this.restSeconds,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'repsMin': repsMin,
        'repsMax': repsMax,
        'restSeconds': restSeconds,
        'notes': notes,
      };

  factory ExerciseTemplate.fromJson(Map<String, dynamic> json) {
    return ExerciseTemplate(
      name: json['name'],
      sets: json['sets'],
      repsMin: json['repsMin'],
      repsMax: json['repsMax'],
      restSeconds: json['restSeconds'],
      notes: json['notes'],
    );
  }
}

/// Completed workout for history export
class CompletedWorkout {
  final DateTime date;
  final String name;
  final int duration;
  final int exerciseCount;
  final int totalSets;
  final double totalVolume;

  const CompletedWorkout({
    required this.date,
    required this.name,
    required this.duration,
    required this.exerciseCount,
    required this.totalSets,
    required this.totalVolume,
  });
}
