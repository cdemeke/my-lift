import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../data/services/auth_service.dart';

/// User profile screen with settings and stats.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? 'Fitness User';
    final email = user?.email ?? 'No email';
    final photoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // User info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey500,
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingSm,
                            vertical: AppDimensions.paddingXs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Text(
                            'General Fitness',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.success,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Stats overview
          Text(
            'Your Stats',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          GestureDetector(
            onTap: () => context.push(RoutePaths.achievements),
            child: Row(
              children: [
                _buildStatCard(context, '24', 'Workouts', Icons.fitness_center),
                const SizedBox(width: AppDimensions.spacingSm),
                _buildStatCard(context, '6', 'Week Streak', Icons.local_fire_department),
                const SizedBox(width: AppDimensions.spacingSm),
                _buildStatCard(context, '8', 'Badges', Icons.military_tech),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Menu items
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          _buildMenuItem(
            context,
            icon: Icons.flag_outlined,
            title: AppStrings.fitnessGoals,
            subtitle: 'Update your fitness goals',
            onTap: () {
              // TODO: Navigate to edit goals
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.location_on_outlined,
            title: AppStrings.gymProfiles,
            subtitle: 'Manage your gym setups',
            onTap: () => context.push(RoutePaths.gymProfiles),
          ),

          _buildMenuItem(
            context,
            icon: Icons.history,
            title: AppStrings.workoutHistory,
            subtitle: 'View past workouts',
            onTap: () => context.push(RoutePaths.workoutHistory),
          ),

          _buildMenuItem(
            context,
            icon: Icons.notifications_outlined,
            title: AppStrings.notifications,
            subtitle: 'Manage notification preferences',
            onTap: () {
              // TODO: Navigate to notifications settings
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.straighten,
            title: AppStrings.units,
            subtitle: 'Weight units: lbs',
            onTap: () {
              // TODO: Show unit picker
            },
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Sign out button
          OutlinedButton.icon(
            onPressed: () async {
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
              if (context.mounted) {
                context.go(RoutePaths.login);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text(AppStrings.signOut),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // App version
          Center(
            child: Text(
              'MyLift v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey400,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
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
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
