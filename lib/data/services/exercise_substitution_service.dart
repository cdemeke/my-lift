import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Exercise category for substitutions
enum ExerciseCategory {
  compound,
  isolation,
  pushHorizontal,
  pushVertical,
  pullHorizontal,
  pullVertical,
  hipHinge,
  squat,
  lunge,
  core,
}

/// Equipment type
enum EquipmentType {
  barbell,
  dumbbell,
  cable,
  machine,
  bodyweight,
  kettlebell,
  bands,
}

/// Exercise data for substitution matching
class ExerciseData {
  final String id;
  final String name;
  final List<String> targetMuscles;
  final ExerciseCategory category;
  final EquipmentType equipment;
  final int difficulty; // 1-5
  final String? notes;

  const ExerciseData({
    required this.id,
    required this.name,
    required this.targetMuscles,
    required this.category,
    required this.equipment,
    required this.difficulty,
    this.notes,
  });
}

/// Substitution suggestion
class ExerciseSubstitution {
  final ExerciseData exercise;
  final int matchScore; // 0-100
  final String reason;
  final List<String> pros;
  final List<String> cons;

  const ExerciseSubstitution({
    required this.exercise,
    required this.matchScore,
    required this.reason,
    this.pros = const [],
    this.cons = const [],
  });
}

/// Exercise substitution database
const exerciseDatabase = <ExerciseData>[
  // Chest - Push Horizontal
  ExerciseData(id: 'bench_press', name: 'Barbell Bench Press', targetMuscles: ['Chest', 'Triceps', 'Front Delt'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.barbell, difficulty: 3),
  ExerciseData(id: 'db_bench', name: 'Dumbbell Bench Press', targetMuscles: ['Chest', 'Triceps', 'Front Delt'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'incline_bench', name: 'Incline Barbell Press', targetMuscles: ['Upper Chest', 'Triceps', 'Front Delt'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.barbell, difficulty: 3),
  ExerciseData(id: 'db_incline', name: 'Incline Dumbbell Press', targetMuscles: ['Upper Chest', 'Triceps', 'Front Delt'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'machine_chest', name: 'Chest Press Machine', targetMuscles: ['Chest', 'Triceps'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.machine, difficulty: 1),
  ExerciseData(id: 'cable_fly', name: 'Cable Fly', targetMuscles: ['Chest'], category: ExerciseCategory.isolation, equipment: EquipmentType.cable, difficulty: 2),
  ExerciseData(id: 'pushups', name: 'Push-Ups', targetMuscles: ['Chest', 'Triceps', 'Core'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.bodyweight, difficulty: 2),
  ExerciseData(id: 'dips', name: 'Dips', targetMuscles: ['Chest', 'Triceps', 'Front Delt'], category: ExerciseCategory.pushHorizontal, equipment: EquipmentType.bodyweight, difficulty: 3),

  // Shoulders - Push Vertical
  ExerciseData(id: 'ohp', name: 'Overhead Press', targetMuscles: ['Shoulders', 'Triceps'], category: ExerciseCategory.pushVertical, equipment: EquipmentType.barbell, difficulty: 3),
  ExerciseData(id: 'db_shoulder', name: 'Dumbbell Shoulder Press', targetMuscles: ['Shoulders', 'Triceps'], category: ExerciseCategory.pushVertical, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'arnold_press', name: 'Arnold Press', targetMuscles: ['Shoulders', 'Triceps'], category: ExerciseCategory.pushVertical, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'machine_shoulder', name: 'Shoulder Press Machine', targetMuscles: ['Shoulders', 'Triceps'], category: ExerciseCategory.pushVertical, equipment: EquipmentType.machine, difficulty: 1),
  ExerciseData(id: 'lat_raise', name: 'Lateral Raises', targetMuscles: ['Side Delt'], category: ExerciseCategory.isolation, equipment: EquipmentType.dumbbell, difficulty: 1),

  // Back - Pull Horizontal
  ExerciseData(id: 'bb_row', name: 'Barbell Row', targetMuscles: ['Lats', 'Rhomboids', 'Biceps'], category: ExerciseCategory.pullHorizontal, equipment: EquipmentType.barbell, difficulty: 3),
  ExerciseData(id: 'db_row', name: 'Dumbbell Row', targetMuscles: ['Lats', 'Rhomboids', 'Biceps'], category: ExerciseCategory.pullHorizontal, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'cable_row', name: 'Seated Cable Row', targetMuscles: ['Lats', 'Rhomboids', 'Biceps'], category: ExerciseCategory.pullHorizontal, equipment: EquipmentType.cable, difficulty: 2),
  ExerciseData(id: 'machine_row', name: 'Machine Row', targetMuscles: ['Lats', 'Rhomboids'], category: ExerciseCategory.pullHorizontal, equipment: EquipmentType.machine, difficulty: 1),
  ExerciseData(id: 'tbar_row', name: 'T-Bar Row', targetMuscles: ['Lats', 'Rhomboids', 'Biceps'], category: ExerciseCategory.pullHorizontal, equipment: EquipmentType.barbell, difficulty: 2),

  // Back - Pull Vertical
  ExerciseData(id: 'pullup', name: 'Pull-Ups', targetMuscles: ['Lats', 'Biceps'], category: ExerciseCategory.pullVertical, equipment: EquipmentType.bodyweight, difficulty: 4),
  ExerciseData(id: 'chinup', name: 'Chin-Ups', targetMuscles: ['Lats', 'Biceps'], category: ExerciseCategory.pullVertical, equipment: EquipmentType.bodyweight, difficulty: 3),
  ExerciseData(id: 'lat_pulldown', name: 'Lat Pulldown', targetMuscles: ['Lats', 'Biceps'], category: ExerciseCategory.pullVertical, equipment: EquipmentType.cable, difficulty: 2),
  ExerciseData(id: 'assisted_pullup', name: 'Assisted Pull-Ups', targetMuscles: ['Lats', 'Biceps'], category: ExerciseCategory.pullVertical, equipment: EquipmentType.machine, difficulty: 2),

  // Legs - Squat
  ExerciseData(id: 'squat', name: 'Barbell Squat', targetMuscles: ['Quads', 'Glutes', 'Core'], category: ExerciseCategory.squat, equipment: EquipmentType.barbell, difficulty: 4),
  ExerciseData(id: 'front_squat', name: 'Front Squat', targetMuscles: ['Quads', 'Core'], category: ExerciseCategory.squat, equipment: EquipmentType.barbell, difficulty: 4),
  ExerciseData(id: 'goblet_squat', name: 'Goblet Squat', targetMuscles: ['Quads', 'Glutes'], category: ExerciseCategory.squat, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'leg_press', name: 'Leg Press', targetMuscles: ['Quads', 'Glutes'], category: ExerciseCategory.squat, equipment: EquipmentType.machine, difficulty: 2),
  ExerciseData(id: 'hack_squat', name: 'Hack Squat', targetMuscles: ['Quads', 'Glutes'], category: ExerciseCategory.squat, equipment: EquipmentType.machine, difficulty: 2),

  // Legs - Hip Hinge
  ExerciseData(id: 'deadlift', name: 'Conventional Deadlift', targetMuscles: ['Hamstrings', 'Glutes', 'Back'], category: ExerciseCategory.hipHinge, equipment: EquipmentType.barbell, difficulty: 4),
  ExerciseData(id: 'sumo_dl', name: 'Sumo Deadlift', targetMuscles: ['Hamstrings', 'Glutes', 'Quads'], category: ExerciseCategory.hipHinge, equipment: EquipmentType.barbell, difficulty: 4),
  ExerciseData(id: 'rdl', name: 'Romanian Deadlift', targetMuscles: ['Hamstrings', 'Glutes'], category: ExerciseCategory.hipHinge, equipment: EquipmentType.barbell, difficulty: 3),
  ExerciseData(id: 'db_rdl', name: 'Dumbbell RDL', targetMuscles: ['Hamstrings', 'Glutes'], category: ExerciseCategory.hipHinge, equipment: EquipmentType.dumbbell, difficulty: 2),
  ExerciseData(id: 'hip_thrust', name: 'Hip Thrust', targetMuscles: ['Glutes', 'Hamstrings'], category: ExerciseCategory.hipHinge, equipment: EquipmentType.barbell, difficulty: 2),
  ExerciseData(id: 'cable_pull_through', name: 'Cable Pull Through', targetMuscles: ['Glutes', 'Hamstrings'], category: ExerciseCategory.hipHinge, equipment: EquipmentType.cable, difficulty: 2),

  // Arms
  ExerciseData(id: 'bb_curl', name: 'Barbell Curl', targetMuscles: ['Biceps'], category: ExerciseCategory.isolation, equipment: EquipmentType.barbell, difficulty: 1),
  ExerciseData(id: 'db_curl', name: 'Dumbbell Curl', targetMuscles: ['Biceps'], category: ExerciseCategory.isolation, equipment: EquipmentType.dumbbell, difficulty: 1),
  ExerciseData(id: 'cable_curl', name: 'Cable Curl', targetMuscles: ['Biceps'], category: ExerciseCategory.isolation, equipment: EquipmentType.cable, difficulty: 1),
  ExerciseData(id: 'hammer_curl', name: 'Hammer Curl', targetMuscles: ['Biceps', 'Brachialis'], category: ExerciseCategory.isolation, equipment: EquipmentType.dumbbell, difficulty: 1),
  ExerciseData(id: 'tricep_pushdown', name: 'Tricep Pushdown', targetMuscles: ['Triceps'], category: ExerciseCategory.isolation, equipment: EquipmentType.cable, difficulty: 1),
  ExerciseData(id: 'skull_crusher', name: 'Skull Crushers', targetMuscles: ['Triceps'], category: ExerciseCategory.isolation, equipment: EquipmentType.barbell, difficulty: 2),
  ExerciseData(id: 'overhead_ext', name: 'Overhead Tricep Extension', targetMuscles: ['Triceps'], category: ExerciseCategory.isolation, equipment: EquipmentType.dumbbell, difficulty: 1),
];

/// Find exercise substitutions
List<ExerciseSubstitution> findSubstitutions(
  String exerciseId, {
  List<EquipmentType>? availableEquipment,
  int? maxDifficulty,
}) {
  final exercise = exerciseDatabase.firstWhere(
    (e) => e.id == exerciseId,
    orElse: () => exerciseDatabase.first,
  );

  final substitutions = <ExerciseSubstitution>[];

  for (final candidate in exerciseDatabase) {
    if (candidate.id == exerciseId) continue;

    // Check equipment availability
    if (availableEquipment != null && !availableEquipment.contains(candidate.equipment)) {
      continue;
    }

    // Check difficulty
    if (maxDifficulty != null && candidate.difficulty > maxDifficulty) {
      continue;
    }

    // Calculate match score
    var score = 0;
    final pros = <String>[];
    final cons = <String>[];

    // Same category is a strong match
    if (candidate.category == exercise.category) {
      score += 40;
      pros.add('Same movement pattern');
    }

    // Muscle overlap
    final muscleOverlap = exercise.targetMuscles
        .where((m) => candidate.targetMuscles.contains(m))
        .length;
    score += (muscleOverlap / exercise.targetMuscles.length * 30).round();
    if (muscleOverlap == exercise.targetMuscles.length) {
      pros.add('Targets same muscles');
    } else if (muscleOverlap > 0) {
      pros.add('Similar muscle focus');
    }

    // Equipment preference
    if (candidate.equipment == exercise.equipment) {
      score += 15;
    } else {
      // Slight bonus for easier equipment
      if (candidate.equipment == EquipmentType.dumbbell ||
          candidate.equipment == EquipmentType.machine) {
        score += 5;
        pros.add('Easier setup');
      }
    }

    // Difficulty comparison
    if (candidate.difficulty < exercise.difficulty) {
      score += 10;
      pros.add('Easier to perform');
    } else if (candidate.difficulty > exercise.difficulty) {
      cons.add('More technically demanding');
    }

    // Minimum score threshold
    if (score < 30) continue;

    String reason;
    if (score >= 70) {
      reason = 'Excellent substitute';
    } else if (score >= 50) {
      reason = 'Good alternative';
    } else {
      reason = 'Possible option';
    }

    substitutions.add(ExerciseSubstitution(
      exercise: candidate,
      matchScore: score.clamp(0, 100),
      reason: reason,
      pros: pros,
      cons: cons,
    ));
  }

  // Sort by match score
  substitutions.sort((a, b) => b.matchScore.compareTo(a.matchScore));

  return substitutions.take(5).toList();
}

/// Exercise substitution widget
class ExerciseSubstitutionSheet extends StatelessWidget {
  final String exerciseId;
  final String exerciseName;
  final Function(ExerciseData)? onSelect;

  const ExerciseSubstitutionSheet({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final substitutions = findSubstitutions(exerciseId);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),

          // Header
          Row(
            children: [
              const Icon(Icons.swap_horiz, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Substitute for',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey500,
                          ),
                    ),
                    Text(
                      exerciseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Substitutions list
          Expanded(
            child: substitutions.isEmpty
                ? Center(
                    child: Text(
                      'No substitutions found',
                      style: TextStyle(color: AppColors.grey500),
                    ),
                  )
                : ListView.builder(
                    itemCount: substitutions.length,
                    itemBuilder: (context, index) {
                      final sub = substitutions[index];
                      return _SubstitutionCard(
                        substitution: sub,
                        onSelect: () {
                          onSelect?.call(sub.exercise);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Substitution card widget
class _SubstitutionCard extends StatelessWidget {
  final ExerciseSubstitution substitution;
  final VoidCallback onSelect;

  const _SubstitutionCard({
    required this.substitution,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final matchColor = substitution.matchScore >= 70
        ? AppColors.success
        : substitution.matchScore >= 50
            ? Colors.orange
            : AppColors.grey500;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      substitution.exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: matchColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${substitution.matchScore}% match',
                      style: TextStyle(
                        color: matchColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                substitution.reason,
                style: TextStyle(color: matchColor, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _TagChip(
                    label: substitution.exercise.equipment.name,
                    icon: Icons.fitness_center,
                  ),
                  _TagChip(
                    label: 'Difficulty ${substitution.exercise.difficulty}/5',
                    icon: Icons.signal_cellular_alt,
                  ),
                ],
              ),
              if (substitution.pros.isNotEmpty || substitution.cons.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (substitution.pros.isNotEmpty)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, size: 14, color: AppColors.success),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                substitution.pros.first,
                                style: const TextStyle(color: AppColors.success, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (substitution.cons.isNotEmpty)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.warning, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                substitution.cons.first,
                                style: const TextStyle(color: Colors.orange, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Tag chip widget
class _TagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TagChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.grey600),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
