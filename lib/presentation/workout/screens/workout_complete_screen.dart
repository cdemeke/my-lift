import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';

/// Workout completion screen with summary.
class WorkoutCompleteScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutCompleteScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // Congratulations text
              Text(
                AppStrings.workoutComplete,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                AppStrings.greatJob,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey500,
                    ),
              ),

              const SizedBox(height: AppDimensions.spacingXl),

              // Stats summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Column(
                    children: [
                      Text(
                        'Workout Summary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context, '45', 'min', Icons.timer),
                          _buildStatItem(context, '18', 'sets', Icons.fitness_center),
                          _buildStatItem(context, '4,320', 'lbs', Icons.scale),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              // Personal records (if any)
              Card(
                color: AppColors.secondary.withOpacity(0.1),
                child: ListTile(
                  leading: const Icon(
                    Icons.emoji_events,
                    color: AppColors.secondary,
                  ),
                  title: const Text('New Personal Record!'),
                  subtitle: const Text('Bench Press: 185 lbs × 8 reps'),
                ),
              ),

              const Spacer(),

              // Coach feedback prompt
              Card(
                color: AppColors.primaryLight.withOpacity(0.1),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.chat, color: Colors.white, size: 20),
                  ),
                  title: const Text('How did it feel?'),
                  subtitle: const Text('Chat with your coach'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(RoutePaths.coach),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // Action buttons
              ElevatedButton(
                onPressed: () => context.go(RoutePaths.home),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
        ),
      ],
    );
  }
}
