import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Workout calendar screen showing workout history in a calendar view
class WorkoutCalendarScreen extends StatefulWidget {
  const WorkoutCalendarScreen({super.key});

  @override
  State<WorkoutCalendarScreen> createState() => _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState extends State<WorkoutCalendarScreen> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  // Mock workout data - in production this would come from a provider
  final Map<DateTime, List<WorkoutEntry>> _workoutHistory = {};

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
    _selectedDate = DateTime.now();
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();
    // Generate some mock workout data for the last 30 days
    final mockWorkouts = [
      ('Push Day', 'Chest, Shoulders, Triceps', 65, AppColors.primary),
      ('Pull Day', 'Back, Biceps', 55, Colors.green),
      ('Leg Day', 'Quads, Hamstrings, Glutes', 70, Colors.orange),
      ('Upper Body', 'Chest, Back, Arms', 60, Colors.purple),
      ('Lower Body', 'Legs, Glutes', 50, Colors.teal),
    ];

    for (int i = 0; i < 30; i++) {
      if (i % 2 == 0 || i % 3 == 0) {
        final date = DateTime(now.year, now.month, now.day - i);
        final normalizedDate = DateTime(date.year, date.month, date.day);
        final workout = mockWorkouts[i % mockWorkouts.length];
        _workoutHistory[normalizedDate] = [
          WorkoutEntry(
            id: 'workout_$i',
            name: workout.$1,
            muscleGroups: workout.$2,
            duration: workout.$3,
            color: workout.$4,
            date: normalizedDate,
            exercises: (i % 5) + 4,
            sets: (i % 10) + 15,
            volume: (i * 1000) + 5000,
          ),
        ];
      }
    }
  }

  List<WorkoutEntry> _getWorkoutsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _workoutHistory[normalizedDay] ?? [];
  }

  void _onMonthChanged(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() {
                _focusedMonth = DateTime.now();
                _selectedDate = DateTime.now();
              });
            },
            tooltip: 'Go to today',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats summary
          _buildStatsSummary(),

          // Month navigation
          _buildMonthNavigation(),

          // Day of week headers
          _buildDayHeaders(),

          // Calendar grid
          Expanded(
            child: _buildCalendarGrid(),
          ),

          // Selected day workouts
          if (_selectedDate != null)
            _buildSelectedDayWorkouts(),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    final now = DateTime.now();
    final thisMonth = _workoutHistory.entries
        .where((e) => e.key.month == now.month && e.key.year == now.year)
        .length;
    final currentStreak = _calculateStreak();
    final thisWeek = _workoutHistory.entries
        .where((e) => now.difference(e.key).inDays < 7)
        .length;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'This Month',
              value: '$thisMonth',
              icon: Icons.calendar_month,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'This Week',
              value: '$thisWeek',
              icon: Icons.date_range,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Streak',
              value: '$currentStreak',
              icon: Icons.local_fire_department,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateStreak() {
    int streak = 0;
    var checkDate = DateTime.now();

    while (true) {
      final normalizedDate = DateTime(checkDate.year, checkDate.month, checkDate.day);
      if (_workoutHistory.containsKey(normalizedDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (streak == 0) {
        // Check if we worked out yesterday (allow for today not being done yet)
        checkDate = checkDate.subtract(const Duration(days: 1));
        final yesterday = DateTime(checkDate.year, checkDate.month, checkDate.day);
        if (_workoutHistory.containsKey(yesterday)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      } else {
        break;
      }
    }
    return streak;
  }

  Widget _buildMonthNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _onMonthChanged(-1),
          ),
          Text(
            DateFormat('MMMM yyyy').format(_focusedMonth),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _onMonthChanged(1),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeaders() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSm),
      child: Row(
        children: days.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    // Adjust for Monday start (1 = Monday, 7 = Sunday)
    int startWeekday = firstDayOfMonth.weekday - 1;
    if (startWeekday < 0) startWeekday = 6;

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: rows * 7,
      itemBuilder: (context, index) {
        final dayNumber = index - startWeekday + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
        final workouts = _getWorkoutsForDay(date);
        final isToday = _isToday(date);
        final isSelected = _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedDate = date);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : workouts.isNotEmpty
                      ? workouts.first.color.withOpacity(0.15)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontWeight: isToday || isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? AppColors.primary
                              : null,
                    ),
                  ),
                ),
                if (workouts.isNotEmpty)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : workouts.first.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildSelectedDayWorkouts() {
    final workouts = _getWorkoutsForDay(_selectedDate!);

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Row(
              children: [
                Text(
                  DateFormat('EEEE, MMMM d').format(_selectedDate!),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (workouts.isEmpty)
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to start workout
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Workout'),
                  ),
              ],
            ),
          ),
          if (workouts.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingLg),
              child: Column(
                children: [
                  Icon(Icons.fitness_center, size: 32, color: AppColors.grey300),
                  const SizedBox(height: 8),
                  Text(
                    'Rest day',
                    style: TextStyle(color: AppColors.grey500),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return _WorkoutCard(workout: workout);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutEntry workout;

  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: workout.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.fitness_center,
            color: workout.color,
          ),
        ),
        title: Text(
          workout.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${workout.exercises} exercises · ${workout.sets} sets · ${workout.duration}min',
          style: TextStyle(fontSize: 12, color: AppColors.grey500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to workout detail
        },
      ),
    );
  }
}

/// Workout entry model
class WorkoutEntry {
  final String id;
  final String name;
  final String muscleGroups;
  final int duration;
  final Color color;
  final DateTime date;
  final int exercises;
  final int sets;
  final int volume;

  const WorkoutEntry({
    required this.id,
    required this.name,
    required this.muscleGroups,
    required this.duration,
    required this.color,
    required this.date,
    required this.exercises,
    required this.sets,
    required this.volume,
  });
}
