import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;

import '../../core/constants/app_colors.dart';

/// Types of personal records
enum PrType {
  oneRm('1RM', 'One-rep max'),
  maxWeight('Max Weight', 'Heaviest weight lifted'),
  maxReps('Max Reps', 'Most reps at a weight'),
  maxVolume('Max Volume', 'Highest single-set volume');

  final String label;
  final String description;

  const PrType(this.label, this.description);
}

/// A single personal record entry
class PersonalRecord {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final PrType type;
  final double value;
  final double? weight;
  final int? reps;
  final DateTime date;
  final String? notes;

  PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.type,
    required this.value,
    this.weight,
    this.reps,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseId': exerciseId,
    'exerciseName': exerciseName,
    'type': type.name,
    'value': value,
    'weight': weight,
    'reps': reps,
    'date': date.toIso8601String(),
    'notes': notes,
  };

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      type: PrType.values.firstWhere((e) => e.name == json['type']),
      value: (json['value'] as num).toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      reps: json['reps'] as int?,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }
}

/// Provider for personal records
final personalRecordsProvider = StateNotifierProvider<PersonalRecordsNotifier, PersonalRecordsState>((ref) {
  return PersonalRecordsNotifier();
});

/// Personal records state
class PersonalRecordsState {
  final Map<String, List<PersonalRecord>> recordsByExercise;
  final bool isLoading;
  final PersonalRecord? lastPr;

  const PersonalRecordsState({
    this.recordsByExercise = const {},
    this.isLoading = true,
    this.lastPr,
  });

  PersonalRecordsState copyWith({
    Map<String, List<PersonalRecord>>? recordsByExercise,
    bool? isLoading,
    PersonalRecord? lastPr,
  }) {
    return PersonalRecordsState(
      recordsByExercise: recordsByExercise ?? this.recordsByExercise,
      isLoading: isLoading ?? this.isLoading,
      lastPr: lastPr,
    );
  }

  /// Get all PRs for an exercise
  List<PersonalRecord> getRecordsForExercise(String exerciseId) {
    return recordsByExercise[exerciseId] ?? [];
  }

  /// Get current PR of a specific type for an exercise
  PersonalRecord? getCurrentPr(String exerciseId, PrType type) {
    final records = getRecordsForExercise(exerciseId);
    final ofType = records.where((r) => r.type == type).toList();
    if (ofType.isEmpty) return null;
    return ofType.reduce((a, b) => a.value >= b.value ? a : b);
  }

  /// Get all-time PRs across all exercises
  List<PersonalRecord> get allTimePrs {
    final all = <PersonalRecord>[];
    for (final records in recordsByExercise.values) {
      // Get best PR of each type per exercise
      final byType = <PrType, PersonalRecord>{};
      for (final record in records) {
        if (!byType.containsKey(record.type) || record.value > byType[record.type]!.value) {
          byType[record.type] = record;
        }
      }
      all.addAll(byType.values);
    }
    return all;
  }

  /// Get recent PRs (last 30 days)
  List<PersonalRecord> get recentPrs {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return allTimePrs.where((pr) => pr.date.isAfter(cutoff)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}

/// Personal records notifier
class PersonalRecordsNotifier extends StateNotifier<PersonalRecordsState> {
  PersonalRecordsNotifier() : super(const PersonalRecordsState()) {
    _loadRecords();
  }

  static const _storageKey = 'personal_records';

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final Map<String, dynamic> json = jsonDecode(data);
      final recordsByExercise = <String, List<PersonalRecord>>{};

      json.forEach((key, value) {
        final List<dynamic> list = value as List;
        recordsByExercise[key] = list.map((e) => PersonalRecord.fromJson(e)).toList();
      });

      state = state.copyWith(recordsByExercise: recordsByExercise, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = <String, dynamic>{};

    state.recordsByExercise.forEach((key, value) {
      json[key] = value.map((e) => e.toJson()).toList();
    });

    await prefs.setString(_storageKey, jsonEncode(json));
  }

  /// Check if a set is a new PR and record it
  PersonalRecord? checkAndRecordPr({
    required String exerciseId,
    required String exerciseName,
    required double weight,
    required int reps,
  }) {
    PersonalRecord? newPr;

    // Calculate 1RM using Brzycki formula
    final estimated1Rm = reps == 1 ? weight : weight * (36 / (37 - reps));

    // Check 1RM PR
    final current1Rm = state.getCurrentPr(exerciseId, PrType.oneRm);
    if (current1Rm == null || estimated1Rm > current1Rm.value) {
      newPr = _recordPr(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        type: PrType.oneRm,
        value: estimated1Rm,
        weight: weight,
        reps: reps,
      );
    }

    // Check max weight PR (only for 1-5 reps to keep it meaningful)
    if (reps <= 5) {
      final currentMaxWeight = state.getCurrentPr(exerciseId, PrType.maxWeight);
      if (currentMaxWeight == null || weight > currentMaxWeight.value) {
        final pr = _recordPr(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          type: PrType.maxWeight,
          value: weight,
          weight: weight,
          reps: reps,
        );
        newPr ??= pr;
      }
    }

    // Check max reps PR at this weight (within 5% tolerance)
    final existingMaxReps = _getMaxRepsAtWeight(exerciseId, weight);
    if (existingMaxReps == null || reps > existingMaxReps) {
      // Only count as PR if reps are significant (5+)
      if (reps >= 5) {
        final pr = _recordPr(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          type: PrType.maxReps,
          value: reps.toDouble(),
          weight: weight,
          reps: reps,
          notes: 'Max reps at ${weight.toStringAsFixed(1)} lbs',
        );
        newPr ??= pr;
      }
    }

    // Check max volume PR (weight × reps)
    final volume = weight * reps;
    final currentMaxVolume = state.getCurrentPr(exerciseId, PrType.maxVolume);
    if (currentMaxVolume == null || volume > currentMaxVolume.value) {
      final pr = _recordPr(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        type: PrType.maxVolume,
        value: volume,
        weight: weight,
        reps: reps,
        notes: '${weight.toStringAsFixed(1)} × $reps = ${volume.toStringAsFixed(0)}',
      );
      newPr ??= pr;
    }

    return newPr;
  }

  int? _getMaxRepsAtWeight(String exerciseId, double weight) {
    final records = state.getRecordsForExercise(exerciseId);
    final atWeight = records.where((r) {
      if (r.weight == null) return false;
      // Within 5% tolerance
      return (r.weight! - weight).abs() / weight < 0.05;
    });

    if (atWeight.isEmpty) return null;
    return atWeight.map((r) => r.reps ?? 0).reduce(math.max);
  }

  PersonalRecord _recordPr({
    required String exerciseId,
    required String exerciseName,
    required PrType type,
    required double value,
    double? weight,
    int? reps,
    String? notes,
  }) {
    final pr = PersonalRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      type: type,
      value: value,
      weight: weight,
      reps: reps,
      date: DateTime.now(),
      notes: notes,
    );

    final newRecords = Map<String, List<PersonalRecord>>.from(state.recordsByExercise);
    newRecords[exerciseId] = [...(newRecords[exerciseId] ?? []), pr];

    state = state.copyWith(recordsByExercise: newRecords, lastPr: pr);
    _save();

    return pr;
  }

  /// Delete a PR
  Future<void> deletePr(String exerciseId, String prId) async {
    final newRecords = Map<String, List<PersonalRecord>>.from(state.recordsByExercise);
    newRecords[exerciseId] = newRecords[exerciseId]?.where((r) => r.id != prId).toList() ?? [];
    state = state.copyWith(recordsByExercise: newRecords);
    await _save();
  }

  /// Clear last PR notification
  void clearLastPr() {
    state = state.copyWith(lastPr: null);
  }
}

/// PR celebration widget
class PrCelebration extends StatefulWidget {
  final PersonalRecord pr;
  final VoidCallback onDismiss;

  const PrCelebration({
    super.key,
    required this.pr,
    required this.onDismiss,
  });

  @override
  State<PrCelebration> createState() => _PrCelebrationState();
}

class _PrCelebrationState extends State<PrCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'NEW PR!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.pr.exerciseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatPrValue(widget.pr),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.pr.type.label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrValue(PersonalRecord pr) {
    switch (pr.type) {
      case PrType.oneRm:
        return '${pr.value.toStringAsFixed(1)} lbs (est.)';
      case PrType.maxWeight:
        return '${pr.value.toStringAsFixed(1)} lbs × ${pr.reps} reps';
      case PrType.maxReps:
        return '${pr.reps} reps @ ${pr.weight?.toStringAsFixed(1)} lbs';
      case PrType.maxVolume:
        return '${pr.value.toStringAsFixed(0)} total volume';
    }
  }
}

/// PR badge widget for exercise cards
class PrBadge extends StatelessWidget {
  final PersonalRecord pr;
  final bool mini;

  const PrBadge({
    super.key,
    required this.pr,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    if (mini) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.emoji_events,
          size: 12,
          color: Colors.white,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            'PR: ${pr.type.label}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
