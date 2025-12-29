import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';

/// Workout history screen.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _selectedMonth = DateTime.now();

  // Mock workout history
  final List<Map<String, dynamic>> _workoutHistory = [
    {
      'id': '1',
      'name': 'Push Day',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'duration': 48,
      'exercises': 6,
      'volume': 12500,
    },
    {
      'id': '2',
      'name': 'Pull Day',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'duration': 52,
      'exercises': 6,
      'volume': 14200,
    },
    {
      'id': '3',
      'name': 'Leg Day',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'duration': 55,
      'exercises': 5,
      'volume': 18500,
    },
    {
      'id': '4',
      'name': 'Upper Body',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'duration': 45,
      'exercises': 7,
      'volume': 11200,
    },
    {
      'id': '5',
      'name': 'Push Day',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'duration': 50,
      'exercises': 6,
      'volume': 12800,
    },
  ];

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthWorkouts = _workoutHistory.where((workout) {
      final date = workout['date'] as DateTime;
      return date.year == _selectedMonth.year &&
          date.month == _selectedMonth.month;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.workoutHistory),
      ),
      body: Column(
        children: [
          // Month stats summary
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '${monthWorkouts.length}',
                  'Workouts',
                  Icons.fitness_center,
                ),
                _buildStatItem(
                  '${monthWorkouts.fold<int>(0, (sum, w) => sum + (w['duration'] as int))}',
                  'Minutes',
                  Icons.timer,
                ),
                _buildStatItem(
                  '${(monthWorkouts.fold<int>(0, (sum, w) => sum + (w['volume'] as int)) / 1000).toStringAsFixed(1)}k',
                  'Total lbs',
                  Icons.scale,
                ),
              ],
            ),
          ),

          // Month navigation
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMonth = DateTime.now();
                    });
                  },
                  child: Text(
                    '${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _selectedMonth.isBefore(DateTime.now())
                      ? _nextMonth
                      : null,
                ),
              ],
            ),
          ),

          // Workout list
          Expanded(
            child: monthWorkouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 64,
                          color: AppColors.grey300,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        Text(
                          'No workouts this month',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.grey500,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMd,
                    ),
                    itemCount: monthWorkouts.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDimensions.spacingSm),
                    itemBuilder: (context, index) {
                      final workout = monthWorkouts[index];
                      return _buildWorkoutCard(workout);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    final date = workout['date'] as DateTime;

    return Card(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                AppStrings.weekDaysShort[date.weekday - 1],
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        title: Text(workout['name'] as String),
        subtitle: Text(
          '${workout['duration']} min • ${workout['exercises']} exercises',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(workout['volume'] as int).toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (match) => '${match[1]},',
                  )}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'lbs',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to workout detail
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
