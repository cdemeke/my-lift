import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/services/auth_service.dart';

/// Home screen - main dashboard showing today's workout and progress.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      body: authState.when(
        data: (user) => _buildContent(context, ref, user?.displayName),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildContent(context, ref, null),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, String? displayName) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // Greeting
          _buildGreeting(context, displayName),

          const SizedBox(height: AppDimensions.spacingLg),

          // Today's workout card
          _buildTodayWorkoutCard(context),

          const SizedBox(height: AppDimensions.spacingLg),

          // Quick stats
          _buildQuickStats(context),

          const SizedBox(height: AppDimensions.spacingLg),

          // Weekly progress
          _buildWeeklyProgress(context),

          const SizedBox(height: AppDimensions.spacingLg),

          // Motivational quote
          _buildMotivationalCard(context),

          const SizedBox(height: AppDimensions.spacingLg),

          // Quick actions
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String? displayName) {
    final firstName = displayName?.split(' ').first ?? '';

    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;
    if (hour < 12) {
      greeting = 'Good morning';
      icon = Icons.wb_sunny_outlined;
    } else if (hour < 17) {
      greeting = 'Good afternoon';
      icon = Icons.wb_sunny;
    } else {
      greeting = 'Good evening';
      icon = Icons.nights_stay_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName.isNotEmpty ? '$greeting, $firstName!' : '$greeting!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppDateUtils.formatLongDate(DateTime.now()),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(
          context,
          icon: Icons.local_fire_department,
          value: '6',
          label: 'Day Streak',
          color: Colors.orange,
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        _buildStatItem(
          context,
          icon: Icons.fitness_center,
          value: '24',
          label: 'Workouts',
          color: AppColors.primary,
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        _buildStatItem(
          context,
          icon: Icons.timer,
          value: '18h',
          label: 'Total Time',
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayWorkoutCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withBlue(200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSm,
                      vertical: AppDimensions.paddingXs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      AppStrings.todaysWorkout,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                'Push Day',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                'Chest • Shoulders • Triceps',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Row(
                children: [
                  _buildWorkoutInfo(Icons.timer_outlined, '45 min'),
                  const SizedBox(width: AppDimensions.spacingMd),
                  _buildWorkoutInfo(Icons.fitness_center, '6 exercises'),
                  const SizedBox(width: AppDimensions.spacingMd),
                  _buildWorkoutInfo(Icons.local_fire_department, '~350 cal'),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(RoutePaths.workoutDetailPath('demo'));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'Start Workout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.weeklyProgress,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '3/4 workouts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final day = AppStrings.weekDaysShort[index];
                final isCompleted = index < 3;
                final isToday = index == 3;

                return Column(
                  children: [
                    Text(
                      day,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isToday ? AppColors.primary : AppColors.grey500,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.success
                            : isToday
                                ? AppColors.primary
                                : AppColors.grey100,
                        border: isToday && !isCompleted
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, size: 20, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isToday ? Colors.white : AppColors.grey600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: LinearProgressIndicator(
                value: 0.75,
                backgroundColor: AppColors.grey200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalCard(BuildContext context) {
    final quotes = [
      "The only bad workout is the one that didn't happen.",
      "Strength doesn't come from what you can do. It comes from overcoming the things you once thought you couldn't.",
      "Your body can stand almost anything. It's your mind you have to convince.",
      "The pain you feel today will be the strength you feel tomorrow.",
    ];
    final randomQuote = quotes[DateTime.now().day % quotes.length];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote, color: AppColors.secondary, size: 32),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Text(
              randomQuote,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.grey700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Row(
          children: [
            _buildActionButton(
              context,
              icon: Icons.calendar_today,
              label: 'Weekly Plan',
              color: Colors.blue,
              onTap: () => context.go(RoutePaths.weeklyPlan),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            _buildActionButton(
              context,
              icon: Icons.fitness_center,
              label: 'Exercises',
              color: Colors.purple,
              onTap: () => context.push(RoutePaths.exerciseLibrary),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            _buildActionButton(
              context,
              icon: Icons.insights,
              label: 'Progress',
              color: Colors.teal,
              onTap: () => context.push(RoutePaths.progress),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
