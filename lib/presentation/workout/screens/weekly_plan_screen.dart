import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/date_utils.dart';

/// Weekly plan screen showing the workout schedule.
class WeeklyPlanScreen extends ConsumerStatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  ConsumerState<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends ConsumerState<WeeklyPlanScreen> {
  DateTime _currentWeekStart = AppDateUtils.getStartOfWeek(DateTime.now());

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart =
          _currentWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = AppDateUtils.getWeekDates(_currentWeekStart);
    final isCurrentWeek =
        AppDateUtils.isSameDay(_currentWeekStart, AppDateUtils.getStartOfWeek(DateTime.now()));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.weeklyPlan),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // TODO: Open gym profile selector
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Week navigation
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMd,
              vertical: AppDimensions.paddingSm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goToPreviousWeek,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentWeekStart =
                          AppDateUtils.getStartOfWeek(DateTime.now());
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        '${AppDateUtils.formatShortDate(_currentWeekStart)} - ${AppDateUtils.formatShortDate(weekDates.last)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (isCurrentWeek)
                        Text(
                          'This Week',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                  ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _goToNextWeek,
                ),
              ],
            ),
          ),

          // Workout list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              itemCount: weekDates.length,
              itemBuilder: (context, index) {
                final date = weekDates[index];
                return _buildDayCard(context, date, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Generate new workout plan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Generating new workout plan...'),
            ),
          );
        },
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate Plan'),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, DateTime date, int index) {
    final isToday = AppDateUtils.isToday(date);
    final isPast = AppDateUtils.isPast(date);

    // Mock workout data
    final hasWorkout = index % 2 == 0 || index == 3;
    final workoutNames = ['Push Day', 'Pull Day', 'Leg Day', 'Upper Body'];
    final workoutName = workoutNames[index % workoutNames.length];
    final isCompleted = isPast && hasWorkout && index < 3;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: isToday
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: hasWorkout
            ? () => context.push(RoutePaths.workoutDetailPath('demo'))
            : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Row(
            children: [
              // Date column
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text(
                      AppStrings.weekDaysShort[index],
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isToday ? AppColors.primary : AppColors.grey500,
                          ),
                    ),
                    Text(
                      '${date.day}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: isToday ? AppColors.primary : null,
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppDimensions.spacingMd),

              // Workout info
              Expanded(
                child: hasWorkout
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                workoutName,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              if (isCompleted) ...[
                                const SizedBox(width: AppDimensions.spacingSm),
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingXs),
                          Text(
                            '6 exercises • 45 min',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.grey500),
                          ),
                        ],
                      )
                    : Text(
                        'Rest Day',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey400,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
              ),

              // Status indicator or arrow
              if (hasWorkout)
                Icon(
                  isCompleted ? Icons.check : Icons.chevron_right,
                  color: isCompleted ? AppColors.success : AppColors.grey400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
