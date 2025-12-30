import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/route_names.dart';

/// Pre-built workout templates library.
class WorkoutTemplatesScreen extends ConsumerWidget {
  const WorkoutTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Templates'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Popular'),
              Tab(text: 'Strength'),
              Tab(text: 'Hypertrophy'),
              Tab(text: 'Beginner'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push(RoutePaths.workoutBuilder),
              tooltip: 'Create Custom',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildTemplateList(context, _popularTemplates),
            _buildTemplateList(context, _strengthTemplates),
            _buildTemplateList(context, _hypertrophyTemplates),
            _buildTemplateList(context, _beginnerTemplates),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateList(BuildContext context, List<WorkoutTemplate> templates) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _TemplateCard(template: template);
      },
    );
  }

  static final _popularTemplates = [
    WorkoutTemplate(
      id: 'ppl_push',
      name: 'Push Day',
      description: 'Chest, shoulders, and triceps focused workout',
      muscleGroups: ['Chest', 'Shoulders', 'Triceps'],
      difficulty: 'Intermediate',
      duration: 60,
      exercises: [
        TemplateExercise('Bench Press', 4, '6-8'),
        TemplateExercise('Incline Dumbbell Press', 3, '8-10'),
        TemplateExercise('Shoulder Press', 4, '8-10'),
        TemplateExercise('Lateral Raises', 3, '12-15'),
        TemplateExercise('Tricep Pushdown', 3, '10-12'),
        TemplateExercise('Overhead Extension', 3, '10-12'),
      ],
      color: AppColors.primary,
    ),
    WorkoutTemplate(
      id: 'ppl_pull',
      name: 'Pull Day',
      description: 'Back and biceps focused workout',
      muscleGroups: ['Back', 'Biceps', 'Rear Delts'],
      difficulty: 'Intermediate',
      duration: 60,
      exercises: [
        TemplateExercise('Deadlift', 4, '5-6'),
        TemplateExercise('Pull-Ups', 4, '6-10'),
        TemplateExercise('Barbell Row', 4, '8-10'),
        TemplateExercise('Face Pulls', 3, '15-20'),
        TemplateExercise('Barbell Curl', 3, '10-12'),
        TemplateExercise('Hammer Curl', 3, '10-12'),
      ],
      color: Colors.teal,
    ),
    WorkoutTemplate(
      id: 'ppl_legs',
      name: 'Leg Day',
      description: 'Complete lower body workout',
      muscleGroups: ['Quads', 'Hamstrings', 'Glutes', 'Calves'],
      difficulty: 'Intermediate',
      duration: 70,
      exercises: [
        TemplateExercise('Squat', 4, '6-8'),
        TemplateExercise('Romanian Deadlift', 4, '8-10'),
        TemplateExercise('Leg Press', 3, '10-12'),
        TemplateExercise('Leg Curl', 3, '10-12'),
        TemplateExercise('Leg Extension', 3, '12-15'),
        TemplateExercise('Calf Raises', 4, '15-20'),
      ],
      color: Colors.orange,
    ),
    WorkoutTemplate(
      id: 'upper',
      name: 'Upper Body',
      description: 'Complete upper body in one session',
      muscleGroups: ['Chest', 'Back', 'Shoulders', 'Arms'],
      difficulty: 'Intermediate',
      duration: 75,
      exercises: [
        TemplateExercise('Bench Press', 4, '6-8'),
        TemplateExercise('Barbell Row', 4, '6-8'),
        TemplateExercise('Shoulder Press', 3, '8-10'),
        TemplateExercise('Lat Pulldown', 3, '10-12'),
        TemplateExercise('Dumbbell Curl', 3, '10-12'),
        TemplateExercise('Tricep Pushdown', 3, '10-12'),
      ],
      color: Colors.purple,
    ),
  ];

  static final _strengthTemplates = [
    WorkoutTemplate(
      id: 'strength_5x5',
      name: 'StrongLifts 5x5 - A',
      description: 'Classic strength program: Squat, Bench, Row',
      muscleGroups: ['Full Body'],
      difficulty: 'Beginner',
      duration: 45,
      exercises: [
        TemplateExercise('Squat', 5, '5'),
        TemplateExercise('Bench Press', 5, '5'),
        TemplateExercise('Barbell Row', 5, '5'),
      ],
      color: Colors.red,
    ),
    WorkoutTemplate(
      id: 'strength_5x5_b',
      name: 'StrongLifts 5x5 - B',
      description: 'Classic strength program: Squat, Press, Deadlift',
      muscleGroups: ['Full Body'],
      difficulty: 'Beginner',
      duration: 45,
      exercises: [
        TemplateExercise('Squat', 5, '5'),
        TemplateExercise('Shoulder Press', 5, '5'),
        TemplateExercise('Deadlift', 1, '5'),
      ],
      color: Colors.red,
    ),
    WorkoutTemplate(
      id: 'powerlifting',
      name: 'Powerlifting Focus',
      description: 'Heavy compound movements for max strength',
      muscleGroups: ['Full Body'],
      difficulty: 'Advanced',
      duration: 90,
      exercises: [
        TemplateExercise('Squat', 5, '3-5'),
        TemplateExercise('Bench Press', 5, '3-5'),
        TemplateExercise('Deadlift', 3, '3-5'),
        TemplateExercise('Barbell Row', 4, '5-8'),
        TemplateExercise('Shoulder Press', 4, '5-8'),
      ],
      color: Colors.deepOrange,
    ),
  ];

  static final _hypertrophyTemplates = [
    WorkoutTemplate(
      id: 'chest_hyper',
      name: 'Chest Hypertrophy',
      description: 'High volume chest builder',
      muscleGroups: ['Chest'],
      difficulty: 'Intermediate',
      duration: 50,
      exercises: [
        TemplateExercise('Bench Press', 4, '8-12'),
        TemplateExercise('Incline Dumbbell Press', 4, '10-12'),
        TemplateExercise('Cable Crossover', 3, '12-15'),
        TemplateExercise('Dumbbell Flyes', 3, '12-15'),
        TemplateExercise('Push-Ups', 3, 'AMRAP'),
      ],
      color: Colors.pink,
    ),
    WorkoutTemplate(
      id: 'back_hyper',
      name: 'Back Hypertrophy',
      description: 'Build a thick, wide back',
      muscleGroups: ['Back'],
      difficulty: 'Intermediate',
      duration: 55,
      exercises: [
        TemplateExercise('Pull-Ups', 4, '8-12'),
        TemplateExercise('Barbell Row', 4, '8-12'),
        TemplateExercise('Lat Pulldown', 3, '10-12'),
        TemplateExercise('Seated Cable Row', 3, '10-12'),
        TemplateExercise('Face Pulls', 3, '15-20'),
        TemplateExercise('Straight Arm Pulldown', 3, '12-15'),
      ],
      color: Colors.indigo,
    ),
    WorkoutTemplate(
      id: 'arms_hyper',
      name: 'Arm Blaster',
      description: 'Focused arm development',
      muscleGroups: ['Biceps', 'Triceps'],
      difficulty: 'Beginner',
      duration: 45,
      exercises: [
        TemplateExercise('Barbell Curl', 4, '8-12'),
        TemplateExercise('Skull Crushers', 4, '8-12'),
        TemplateExercise('Hammer Curl', 3, '10-12'),
        TemplateExercise('Tricep Pushdown', 3, '10-12'),
        TemplateExercise('Preacher Curl', 3, '12-15'),
        TemplateExercise('Overhead Extension', 3, '12-15'),
      ],
      color: Colors.amber,
    ),
  ];

  static final _beginnerTemplates = [
    WorkoutTemplate(
      id: 'full_body_a',
      name: 'Full Body - Day A',
      description: 'Beginner-friendly full body workout',
      muscleGroups: ['Full Body'],
      difficulty: 'Beginner',
      duration: 45,
      exercises: [
        TemplateExercise('Goblet Squat', 3, '10-12'),
        TemplateExercise('Push-Ups', 3, '8-12'),
        TemplateExercise('Dumbbell Row', 3, '10-12'),
        TemplateExercise('Plank', 3, '30-60s'),
        TemplateExercise('Lunges', 2, '10 each'),
      ],
      color: Colors.green,
    ),
    WorkoutTemplate(
      id: 'full_body_b',
      name: 'Full Body - Day B',
      description: 'Beginner-friendly full body workout',
      muscleGroups: ['Full Body'],
      difficulty: 'Beginner',
      duration: 45,
      exercises: [
        TemplateExercise('Romanian Deadlift', 3, '10-12'),
        TemplateExercise('Dumbbell Press', 3, '10-12'),
        TemplateExercise('Lat Pulldown', 3, '10-12'),
        TemplateExercise('Leg Press', 3, '12-15'),
        TemplateExercise('Bicycle Crunches', 3, '15 each'),
      ],
      color: Colors.green,
    ),
    WorkoutTemplate(
      id: 'minimal_equip',
      name: 'Minimal Equipment',
      description: 'Great for home or hotel gym',
      muscleGroups: ['Full Body'],
      difficulty: 'Beginner',
      duration: 30,
      exercises: [
        TemplateExercise('Push-Ups', 3, 'AMRAP'),
        TemplateExercise('Bodyweight Squats', 3, '15-20'),
        TemplateExercise('Dumbbell Row', 3, '10-12'),
        TemplateExercise('Lunges', 3, '10 each'),
        TemplateExercise('Plank', 3, '45-60s'),
      ],
      color: Colors.lightGreen,
    ),
  ];
}

/// Template card widget
class _TemplateCard extends StatelessWidget {
  final WorkoutTemplate template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showTemplateDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [template.color, template.color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          template.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      template.difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _buildInfoChip(Icons.timer, '${template.duration} min'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.fitness_center, '${template.exercises.length} exercises'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.repeat, '${template.totalSets} sets'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Muscle groups
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: template.muscleGroups.map((muscle) {
                      return Chip(
                        label: Text(muscle),
                        labelStyle: const TextStyle(fontSize: 11),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Exercise preview
                  Text(
                    'Exercises:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.exercises.take(4).map((e) => e.name).join(' • ') +
                        (template.exercises.length > 4 ? ' +${template.exercises.length - 4} more' : ''),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.grey600),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  void _showTemplateDetails(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TemplateDetailSheet(template: template),
    );
  }
}

/// Template detail bottom sheet
class _TemplateDetailSheet extends StatelessWidget {
  final WorkoutTemplate template;

  const _TemplateDetailSheet({required this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [template.color, template.color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      template.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text(
                  template.description,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatPill(Icons.timer, '${template.duration} min'),
                    const SizedBox(width: 8),
                    _buildStatPill(Icons.fitness_center, '${template.exercises.length} exercises'),
                    const SizedBox(width: 8),
                    _buildStatPill(Icons.repeat, '${template.totalSets} sets'),
                  ],
                ),
              ],
            ),
          ),

          // Exercises list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              itemCount: template.exercises.length,
              itemBuilder: (context, index) {
                final exercise = template.exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: template.color.withOpacity(0.1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: template.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(exercise.name),
                    subtitle: Text('${exercise.sets} sets × ${exercise.reps} reps'),
                  ),
                );
              },
            ),
          ),

          // Action buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Navigate to edit with template data
                        context.push(RoutePaths.workoutBuilder);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Customize'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        HapticFeedback.heavyImpact();
                        // TODO: Start workout with this template
                        context.push(RoutePaths.activeWorkoutPath('template_${template.id}'));
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Workout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Workout template model
class WorkoutTemplate {
  final String id;
  final String name;
  final String description;
  final List<String> muscleGroups;
  final String difficulty;
  final int duration;
  final List<TemplateExercise> exercises;
  final Color color;

  const WorkoutTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroups,
    required this.difficulty,
    required this.duration,
    required this.exercises,
    required this.color,
  });

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);
}

/// Template exercise model
class TemplateExercise {
  final String name;
  final int sets;
  final String reps;

  const TemplateExercise(this.name, this.sets, this.reps);
}
