import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Achievements and badges screen.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // Current streak banner
          _buildStreakBanner(context),

          const SizedBox(height: AppDimensions.spacingLg),

          // Quick stats
          Row(
            children: [
              _buildStatCard(context, '24', 'Workouts', Icons.fitness_center),
              const SizedBox(width: AppDimensions.spacingSm),
              _buildStatCard(context, '8', 'Badges', Icons.military_tech),
              const SizedBox(width: AppDimensions.spacingSm),
              _buildStatCard(context, '4', 'PRs', Icons.emoji_events),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Achievement categories
          _buildSectionHeader(context, 'Consistency'),
          _buildAchievementList(context, _consistencyAchievements),

          const SizedBox(height: AppDimensions.spacingLg),

          _buildSectionHeader(context, 'Strength'),
          _buildAchievementList(context, _strengthAchievements),

          const SizedBox(height: AppDimensions.spacingLg),

          _buildSectionHeader(context, 'Milestones'),
          _buildAchievementList(context, _milestoneAchievements),
        ],
      ),
    );
  }

  Widget _buildStreakBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '6',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'days',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Best: 12 days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 8),
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
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildAchievementList(BuildContext context, List<Map<String, dynamic>> achievements) {
    return Column(
      children: achievements.map((achievement) {
        final isUnlocked = achievement['unlocked'] as bool;

        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (achievement['color'] as Color).withOpacity(0.1)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                achievement['icon'] as IconData,
                color: isUnlocked ? achievement['color'] as Color : AppColors.grey400,
                size: 28,
              ),
            ),
            title: Text(
              achievement['title'] as String,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isUnlocked ? null : AppColors.grey500,
              ),
            ),
            subtitle: Text(
              achievement['description'] as String,
              style: TextStyle(
                color: isUnlocked ? AppColors.grey600 : AppColors.grey400,
              ),
            ),
            trailing: isUnlocked
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: AppColors.success, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Unlocked',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${achievement['progress']}/${achievement['target']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey500,
                            ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          value: (achievement['progress'] as int) /
                              (achievement['target'] as int),
                          backgroundColor: AppColors.grey200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }).toList(),
    );
  }

  final _consistencyAchievements = [
    {
      'title': 'First Steps',
      'description': 'Complete your first workout',
      'icon': Icons.directions_walk,
      'color': AppColors.primary,
      'unlocked': true,
      'progress': 1,
      'target': 1,
    },
    {
      'title': 'Week Warrior',
      'description': 'Work out 3 times in a week',
      'icon': Icons.calendar_month,
      'color': Colors.blue,
      'unlocked': true,
      'progress': 3,
      'target': 3,
    },
    {
      'title': 'Streak Master',
      'description': 'Maintain a 7-day streak',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'unlocked': false,
      'progress': 6,
      'target': 7,
    },
    {
      'title': 'Iron Will',
      'description': 'Maintain a 30-day streak',
      'icon': Icons.whatshot,
      'color': Colors.red,
      'unlocked': false,
      'progress': 6,
      'target': 30,
    },
  ];

  final _strengthAchievements = [
    {
      'title': 'Plate Club',
      'description': 'Bench press 135 lbs',
      'icon': Icons.fitness_center,
      'color': Colors.purple,
      'unlocked': true,
      'progress': 1,
      'target': 1,
    },
    {
      'title': 'Two Plate',
      'description': 'Bench press 225 lbs',
      'icon': Icons.fitness_center,
      'color': Colors.indigo,
      'unlocked': false,
      'progress': 185,
      'target': 225,
    },
    {
      'title': 'Big Three',
      'description': 'Total 500 lbs on squat, bench, deadlift',
      'icon': Icons.emoji_events,
      'color': Colors.amber,
      'unlocked': true,
      'progress': 500,
      'target': 500,
    },
  ];

  final _milestoneAchievements = [
    {
      'title': '10 Workouts',
      'description': 'Complete 10 total workouts',
      'icon': Icons.looks_one,
      'color': Colors.teal,
      'unlocked': true,
      'progress': 10,
      'target': 10,
    },
    {
      'title': '50 Workouts',
      'description': 'Complete 50 total workouts',
      'icon': Icons.looks_5,
      'color': Colors.cyan,
      'unlocked': false,
      'progress': 24,
      'target': 50,
    },
    {
      'title': 'Century Club',
      'description': 'Complete 100 total workouts',
      'icon': Icons.military_tech,
      'color': Colors.amber,
      'unlocked': false,
      'progress': 24,
      'target': 100,
    },
  ];
}
