import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';

/// Workout detail screen showing exercises before starting.
class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock workout data
    final exercises = [
      {'name': 'Bench Press', 'sets': 4, 'reps': '8-10', 'muscle': 'Chest'},
      {'name': 'Incline Dumbbell Press', 'sets': 3, 'reps': '10-12', 'muscle': 'Chest'},
      {'name': 'Shoulder Press', 'sets': 4, 'reps': '8-10', 'muscle': 'Shoulders'},
      {'name': 'Lateral Raises', 'sets': 3, 'reps': '12-15', 'muscle': 'Shoulders'},
      {'name': 'Tricep Pushdowns', 'sets': 3, 'reps': '12-15', 'muscle': 'Triceps'},
      {'name': 'Overhead Tricep Extension', 'sets': 3, 'reps': '10-12', 'muscle': 'Triceps'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: Edit workout
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Workout summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            color: AppColors.primary.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoChip(context, Icons.timer_outlined, '45 min'),
                    const SizedBox(width: AppDimensions.spacingSm),
                    _buildInfoChip(context, Icons.fitness_center, '${exercises.length} exercises'),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Wrap(
                  spacing: AppDimensions.spacingXs,
                  children: ['Chest', 'Shoulders', 'Triceps']
                      .map((muscle) => Chip(
                            label: Text(muscle),
                            backgroundColor: AppColors.grey100,
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          // Coach notes
          Container(
            margin: const EdgeInsets.all(AppDimensions.paddingMd),
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Text(
                    'Focus on controlled movements today. Remember to warm up with lighter weights first!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),

          // Exercise list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              itemCount: exercises.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.grey100,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(exercise['name'] as String),
                  subtitle: Text(
                    '${exercise['sets']} sets × ${exercise['reps']} reps • ${exercise['muscle']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline),
                        onPressed: () {
                          // TODO: Show exercise video
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: () {
                          // TODO: Swap exercise
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push(RoutePaths.exerciseDetailPath('demo'));
                  },
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
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(RoutePaths.quickLogPath(workoutId));
                      },
                      child: const Text(AppStrings.quickLog),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(RoutePaths.activeWorkoutPath(workoutId));
                      },
                      child: const Text(AppStrings.startWorkout),
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

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.grey600),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
