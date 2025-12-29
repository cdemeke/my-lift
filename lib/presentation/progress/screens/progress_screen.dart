import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../widgets/progress_chart.dart';
import '../widgets/stat_card.dart';

/// Progress and statistics screen showing workout analytics.
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'Week';

  // Mock data for charts
  final _weeklyWorkouts = [
    {'day': 'Mon', 'value': 1.0},
    {'day': 'Tue', 'value': 0.0},
    {'day': 'Wed', 'value': 1.0},
    {'day': 'Thu', 'value': 1.0},
    {'day': 'Fri', 'value': 0.0},
    {'day': 'Sat', 'value': 1.0},
    {'day': 'Sun', 'value': 0.0},
  ];

  final _volumeData = [
    {'label': 'W1', 'value': 12500.0},
    {'label': 'W2', 'value': 14200.0},
    {'label': 'W3', 'value': 13800.0},
    {'label': 'W4', 'value': 15600.0},
  ];

  final _exerciseProgress = [
    {'exercise': 'Bench Press', 'current': 185.0, 'previous': 175.0, 'unit': 'lbs'},
    {'exercise': 'Squat', 'current': 225.0, 'previous': 215.0, 'unit': 'lbs'},
    {'exercise': 'Deadlift', 'current': 275.0, 'previous': 265.0, 'unit': 'lbs'},
    {'exercise': 'Shoulder Press', 'current': 115.0, 'previous': 110.0, 'unit': 'lbs'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Strength'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildStrengthTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        // Quick stats row
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'This Week',
                value: '4',
                subtitle: 'workouts',
                icon: Icons.fitness_center,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: StatCard(
                title: 'Current Streak',
                value: '6',
                subtitle: 'days',
                icon: Icons.local_fire_department,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Volume',
                value: '56k',
                subtitle: 'lbs this week',
                icon: Icons.trending_up,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: StatCard(
                title: 'Avg Duration',
                value: '52',
                subtitle: 'min/workout',
                icon: Icons.timer,
                color: Colors.teal,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Weekly activity chart
        _buildSectionCard(
          title: 'Weekly Activity',
          child: SizedBox(
            height: 180,
            child: WeeklyActivityChart(data: _weeklyWorkouts),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Volume trend chart
        _buildSectionCard(
          title: 'Volume Trend',
          trailing: _buildTimeRangeSelector(),
          child: SizedBox(
            height: 200,
            child: VolumeTrendChart(data: _volumeData),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Muscle group distribution
        _buildSectionCard(
          title: 'Muscle Groups',
          child: SizedBox(
            height: 200,
            child: MuscleGroupChart(),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthTab() {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        // Personal records
        _buildSectionCard(
          title: 'Personal Records',
          child: Column(
            children: [
              _buildPRItem('Bench Press', '185 lbs', '1 week ago', Icons.emoji_events),
              const Divider(),
              _buildPRItem('Squat', '225 lbs', '2 weeks ago', Icons.emoji_events),
              const Divider(),
              _buildPRItem('Deadlift', '275 lbs', '3 days ago', Icons.emoji_events),
              const Divider(),
              _buildPRItem('Shoulder Press', '115 lbs', 'Today', Icons.emoji_events),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Exercise progress
        _buildSectionCard(
          title: 'Strength Progress',
          child: Column(
            children: _exerciseProgress.map((exercise) {
              final current = exercise['current'] as double;
              final previous = exercise['previous'] as double;
              final change = ((current - previous) / previous * 100).toStringAsFixed(1);
              final isPositive = current >= previous;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['exercise'] as String,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${current.toInt()} ${exercise['unit']}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: current / 300, // Max expected weight
                        backgroundColor: AppColors.grey200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isPositive ? AppColors.success : AppColors.error,
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isPositive ? AppColors.success : AppColors.error)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                            size: 12,
                            color: isPositive ? AppColors.success : AppColors.error,
                          ),
                          Text(
                            '$change%',
                            style: TextStyle(
                              color: isPositive ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Estimated 1RM
        _buildSectionCard(
          title: 'Estimated 1RM',
          subtitle: 'Based on recent performance',
          child: Column(
            children: [
              _buildEstimated1RM('Bench Press', 205),
              _buildEstimated1RM('Squat', 250),
              _buildEstimated1RM('Deadlift', 305),
              _buildEstimated1RM('Shoulder Press', 130),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: 10,
      itemBuilder: (context, index) {
        final daysAgo = index;
        final date = DateTime.now().subtract(Duration(days: daysAgo));
        final workoutTypes = ['Push Day', 'Pull Day', 'Leg Day', 'Upper Body', 'Lower Body'];
        final workoutType = workoutTypes[index % workoutTypes.length];

        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    _getMonthAbbr(date.month),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
            title: Text(workoutType),
            subtitle: Row(
              children: [
                Icon(Icons.timer, size: 14, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text('${45 + (index * 5) % 30} min'),
                const SizedBox(width: 16),
                Icon(Icons.fitness_center, size: 14, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text('${4 + index % 3} exercises'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${12000 + index * 1500} lbs',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                Text(
                  'volume',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            onTap: () {
              // Navigate to workout detail
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    Widget? trailing,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey500,
                            ),
                      ),
                  ],
                ),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Week', 'Month', 'Year'].map((range) {
          final isSelected = _selectedTimeRange == range;
          return GestureDetector(
            onTap: () => setState(() => _selectedTimeRange = range),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                range,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.grey600,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPRItem(String exercise, String weight, String date, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.amber, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey500,
                      ),
                ),
              ],
            ),
          ),
          Text(
            weight,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimated1RM(String exercise, int weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(exercise),
          Text(
            '$weight lbs',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
