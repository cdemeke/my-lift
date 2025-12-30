import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Streak tracking and achievements system
class StreakWidget extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int totalWorkouts;
  final VoidCallback? onTap;

  const StreakWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalWorkouts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade400,
              Colors.deepOrange.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Streak fire icon with animation effect
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 40,
                    color: Colors.white,
                  ),
                  if (currentStreak >= 7)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.orange.shade600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$currentStreak Day Streak',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStreakMessage(currentStreak),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StreakStat(
                        icon: Icons.emoji_events,
                        value: '$longestStreak',
                        label: 'Best',
                      ),
                      const SizedBox(width: 16),
                      _StreakStat(
                        icon: Icons.fitness_center,
                        value: '$totalWorkouts',
                        label: 'Total',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  String _getStreakMessage(int streak) {
    if (streak >= 30) return "Legendary! A full month of gains! 🏆";
    if (streak >= 21) return "Three weeks strong! Unstoppable! 💪";
    if (streak >= 14) return "Two weeks! You're on fire! 🔥";
    if (streak >= 7) return "One week streak! Keep it going!";
    if (streak >= 3) return "Great start! Build the habit!";
    if (streak >= 1) return "You showed up! That's what counts!";
    return "Start your streak today!";
  }
}

class _StreakStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StreakStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Achievement badge model
class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final String? progressText;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.progressText,
  });
}

/// Achievement card widget
class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: achievement.isUnlocked
              ? achievement.color.withOpacity(0.1)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: achievement.isUnlocked
                ? achievement.color.withOpacity(0.3)
                : AppColors.grey300,
          ),
        ),
        child: Row(
          children: [
            // Badge icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? achievement.color.withOpacity(0.2)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                achievement.icon,
                color: achievement.isUnlocked
                    ? achievement.color
                    : AppColors.grey400,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        achievement.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: achievement.isUnlocked
                              ? null
                              : AppColors.grey500,
                        ),
                      ),
                      if (achievement.isUnlocked) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: achievement.color,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                  if (!achievement.isUnlocked && achievement.progress > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: achievement.progress,
                            backgroundColor: AppColors.grey300,
                            valueColor: AlwaysStoppedAnimation(achievement.color),
                          ),
                        ),
                        if (achievement.progressText != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            achievement.progressText!,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Predefined achievements
class Achievements {
  static const List<Achievement> all = [
    // Workout streaks
    Achievement(
      id: 'streak_3',
      name: 'Getting Started',
      description: 'Complete a 3-day workout streak',
      icon: Icons.local_fire_department,
      color: Colors.orange,
    ),
    Achievement(
      id: 'streak_7',
      name: 'Week Warrior',
      description: 'Complete a 7-day workout streak',
      icon: Icons.local_fire_department,
      color: Colors.deepOrange,
    ),
    Achievement(
      id: 'streak_30',
      name: 'Monthly Master',
      description: 'Complete a 30-day workout streak',
      icon: Icons.local_fire_department,
      color: Colors.red,
    ),

    // Total workouts
    Achievement(
      id: 'workouts_10',
      name: 'First Steps',
      description: 'Complete 10 workouts',
      icon: Icons.fitness_center,
      color: Colors.blue,
    ),
    Achievement(
      id: 'workouts_50',
      name: 'Dedicated',
      description: 'Complete 50 workouts',
      icon: Icons.fitness_center,
      color: Colors.indigo,
    ),
    Achievement(
      id: 'workouts_100',
      name: 'Century Club',
      description: 'Complete 100 workouts',
      icon: Icons.fitness_center,
      color: Colors.purple,
    ),

    // Strength milestones
    Achievement(
      id: 'bench_135',
      name: 'Plate Club',
      description: 'Bench press 135 lbs (1 plate each side)',
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),
    Achievement(
      id: 'bench_225',
      name: 'Two Plate Bench',
      description: 'Bench press 225 lbs',
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),
    Achievement(
      id: 'squat_315',
      name: 'Three Plate Squat',
      description: 'Squat 315 lbs',
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),
    Achievement(
      id: 'deadlift_405',
      name: 'Four Plate Deadlift',
      description: 'Deadlift 405 lbs',
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),

    // PRs
    Achievement(
      id: 'first_pr',
      name: 'Personal Best',
      description: 'Set your first personal record',
      icon: Icons.star,
      color: Colors.green,
    ),
    Achievement(
      id: 'pr_10',
      name: 'PR Hunter',
      description: 'Set 10 personal records',
      icon: Icons.star,
      color: Colors.teal,
    ),

    // Consistency
    Achievement(
      id: 'early_bird',
      name: 'Early Bird',
      description: 'Complete 5 workouts before 7 AM',
      icon: Icons.wb_sunny,
      color: Colors.yellow.shade700,
    ),
    Achievement(
      id: 'night_owl',
      name: 'Night Owl',
      description: 'Complete 5 workouts after 9 PM',
      icon: Icons.nightlight_round,
      color: Colors.indigo,
    ),

    // Volume
    Achievement(
      id: 'volume_100k',
      name: 'Heavy Lifter',
      description: 'Lift 100,000 lbs total volume',
      icon: Icons.trending_up,
      color: Colors.red,
    ),

    // Variety
    Achievement(
      id: 'exercises_20',
      name: 'Well Rounded',
      description: 'Perform 20 different exercises',
      icon: Icons.grid_view,
      color: Colors.cyan,
    ),
  ];
}

/// Achievements list screen
class AchievementsListScreen extends StatelessWidget {
  const AchievementsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock unlocked achievements
    final unlockedIds = {'streak_3', 'workouts_10', 'first_pr', 'bench_135'};

    final achievements = Achievements.all.map((a) {
      if (unlockedIds.contains(a.id)) {
        return Achievement(
          id: a.id,
          name: a.name,
          description: a.description,
          icon: a.icon,
          color: a.color,
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        );
      }
      // Add progress for some locked achievements
      double progress = 0;
      String? progressText;
      if (a.id == 'streak_7') {
        progress = 0.57;
        progressText = '4/7 days';
      } else if (a.id == 'workouts_50') {
        progress = 0.32;
        progressText = '16/50';
      }
      return Achievement(
        id: a.id,
        name: a.name,
        description: a.description,
        icon: a.icon,
        color: a.color,
        progress: progress,
        progressText: progressText,
      );
    }).toList();

    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  value: '${unlocked.length}',
                  label: 'Unlocked',
                  icon: Icons.lock_open,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.grey300,
                ),
                _StatItem(
                  value: '${locked.length}',
                  label: 'Locked',
                  icon: Icons.lock,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.grey300,
                ),
                _StatItem(
                  value: '${(unlocked.length / achievements.length * 100).toInt()}%',
                  label: 'Complete',
                  icon: Icons.pie_chart,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Unlocked
          if (unlocked.isNotEmpty) ...[
            Text(
              'Unlocked',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...unlocked.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AchievementCard(achievement: a),
            )),
            const SizedBox(height: 24),
          ],

          // Locked
          Text(
            'In Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...locked.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AchievementCard(achievement: a),
          )),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey500,
          ),
        ),
      ],
    );
  }
}
