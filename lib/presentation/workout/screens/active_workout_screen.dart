import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../widgets/rest_timer_overlay.dart';

/// Active workout screen for real-time exercise logging.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final String workoutId;

  const ActiveWorkoutScreen({
    super.key,
    required this.workoutId,
  });

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  int _currentExerciseIndex = 0;
  final List<List<Map<String, dynamic>>> _loggedSets = [];
  bool _isResting = false;
  int _restSeconds = 90;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Workout duration tracking
  final Stopwatch _workoutStopwatch = Stopwatch();
  Timer? _durationTimer;
  String _workoutDuration = '00:00';

  // Mock exercises
  final _exercises = [
    {
      'name': 'Bench Press',
      'sets': 4,
      'reps': '8-10',
      'restSeconds': 90,
      'muscle': 'Chest',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Incline Dumbbell Press',
      'sets': 3,
      'reps': '10-12',
      'restSeconds': 60,
      'muscle': 'Upper Chest',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Shoulder Press',
      'sets': 4,
      'reps': '8-10',
      'restSeconds': 90,
      'muscle': 'Shoulders',
      'icon': Icons.accessibility_new,
    },
    {
      'name': 'Lateral Raises',
      'sets': 3,
      'reps': '12-15',
      'restSeconds': 45,
      'muscle': 'Side Delts',
      'icon': Icons.accessibility_new,
    },
    {
      'name': 'Tricep Pushdowns',
      'sets': 3,
      'reps': '12-15',
      'restSeconds': 45,
      'muscle': 'Triceps',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Overhead Tricep Extension',
      'sets': 3,
      'reps': '10-12',
      'restSeconds': 60,
      'muscle': 'Triceps',
      'icon': Icons.fitness_center,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loggedSets.addAll(List.generate(_exercises.length, (_) => []));

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    // Start workout duration timer
    _workoutStopwatch.start();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _workoutDuration = _formatDuration(_workoutStopwatch.elapsed);
      });
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _slideController.dispose();
    _durationTimer?.cancel();
    _workoutStopwatch.stop();
    super.dispose();
  }

  void _logSet(int reps, double weight) {
    HapticFeedback.mediumImpact();
    setState(() {
      _loggedSets[_currentExerciseIndex].add({
        'setNumber': _loggedSets[_currentExerciseIndex].length + 1,
        'reps': reps,
        'weight': weight,
        'timestamp': DateTime.now(),
      });
    });

    // Check if all sets are complete
    final targetSets = _exercises[_currentExerciseIndex]['sets'] as int;
    if (_loggedSets[_currentExerciseIndex].length >= targetSets) {
      // Auto-advance to next exercise after a brief delay
      if (_currentExerciseIndex < _exercises.length - 1) {
        _restSeconds = _exercises[_currentExerciseIndex]['restSeconds'] as int;
        _showRestTimer();
      }
    } else {
      // Show rest timer between sets
      _restSeconds = _exercises[_currentExerciseIndex]['restSeconds'] as int;
      _showRestTimer();
    }
  }

  void _showRestTimer() {
    setState(() {
      _isResting = true;
    });
  }

  void _onRestComplete() {
    setState(() {
      _isResting = false;
      // Auto-advance if current exercise is complete
      final targetSets = _exercises[_currentExerciseIndex]['sets'] as int;
      if (_loggedSets[_currentExerciseIndex].length >= targetSets &&
          _currentExerciseIndex < _exercises.length - 1) {
        _currentExerciseIndex++;
      }
    });
    HapticFeedback.heavyImpact();
  }

  void _skipRest() {
    setState(() {
      _isResting = false;
    });
    HapticFeedback.selectionClick();
  }

  void _navigateExercise(int direction) {
    HapticFeedback.selectionClick();
    final newIndex = _currentExerciseIndex + direction;
    if (newIndex >= 0 && newIndex < _exercises.length) {
      _slideController.forward().then((_) {
        setState(() {
          _currentExerciseIndex = newIndex;
        });
        _slideController.reverse();
      });
    }
  }

  void _finishWorkout() {
    _workoutStopwatch.stop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flag, color: AppColors.success),
            ),
            const SizedBox(width: 12),
            const Text('Finish Workout?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: $_workoutDuration'),
            const SizedBox(height: 8),
            Text('Exercises completed: ${_loggedSets.where((s) => s.isNotEmpty).length}/${_exercises.length}'),
            const SizedBox(height: 8),
            Text('Total sets: ${_loggedSets.fold(0, (sum, sets) => sum + sets.length)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _workoutStopwatch.start();
            },
            child: const Text('Continue'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.go(RoutePaths.workoutCompletePath(widget.workoutId));
            },
            icon: const Icon(Icons.check),
            label: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  int get _totalSetsCompleted =>
      _loggedSets.fold(0, (sum, sets) => sum + sets.length);

  int get _totalSetsTarget =>
      _exercises.fold(0, (sum, ex) => sum + (ex['sets'] as int));

  @override
  Widget build(BuildContext context) {
    final currentExercise = _exercises[_currentExerciseIndex];
    final currentSets = _loggedSets[_currentExerciseIndex];
    final targetSets = currentExercise['sets'] as int;
    final nextExercise = _currentExerciseIndex < _exercises.length - 1
        ? _exercises[_currentExerciseIndex + 1]['name'] as String
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Push Day',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              _workoutDuration,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _finishWorkout,
            icon: const Icon(Icons.flag, size: 18),
            label: const Text('Finish'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Progress bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                  vertical: AppDimensions.paddingSm,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercise ${_currentExerciseIndex + 1} of ${_exercises.length}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '$_totalSetsCompleted / $_totalSetsTarget sets',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _totalSetsCompleted / _totalSetsTarget,
                        backgroundColor: AppColors.grey200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              // Exercise navigation
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSm),
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final isActive = index == _currentExerciseIndex;
                    final isCompleted = _loggedSets[index].length >=
                        (_exercises[index]['sets'] as int);
                    final hasStarted = _loggedSets[index].isNotEmpty;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _currentExerciseIndex = index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : isCompleted
                                  ? AppColors.success.withOpacity(0.1)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          border: Border.all(
                            color: isActive
                                ? AppColors.primary
                                : isCompleted
                                    ? AppColors.success
                                    : hasStarted
                                        ? AppColors.warning
                                        : AppColors.grey300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isCompleted)
                              const Icon(Icons.check, size: 16, color: AppColors.success)
                            else
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : AppColors.grey600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              (_exercises[index]['name'] as String).split(' ').first,
                              style: TextStyle(
                                color: isActive ? Colors.white : AppColors.grey700,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Current exercise card
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.all(AppDimensions.paddingMd),
                  padding: const EdgeInsets.all(AppDimensions.paddingLg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withBlue(200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              currentExercise['icon'] as IconData,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentExercise['name'] as String,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  currentExercise['muscle'] as String,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildExerciseStat('Sets', '${currentSets.length}/$targetSets'),
                          _buildExerciseStat('Target', '${currentExercise['reps']}'),
                          _buildExerciseStat('Rest', '${currentExercise['restSeconds']}s'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Sets list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  children: [
                    ...currentSets.asMap().entries.map((entry) {
                      final index = entry.key;
                      final set = entry.value;
                      return _buildCompletedSetCard(index + 1, set);
                    }),

                    // Input for next set
                    if (currentSets.length < targetSets)
                      _SetInputCard(
                        setNumber: currentSets.length + 1,
                        onComplete: _logSet,
                        previousWeight: currentSets.isNotEmpty
                            ? currentSets.last['weight'] as double
                            : 135.0,
                        previousReps: currentSets.isNotEmpty
                            ? currentSets.last['reps'] as int
                            : 10,
                      ),

                    if (currentSets.length >= targetSets)
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingLg),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                            const SizedBox(height: 8),
                            Text(
                              'Exercise Complete!',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (_currentExerciseIndex < _exercises.length - 1) ...[
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _navigateExercise(1),
                                child: const Text('Next Exercise'),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom navigation
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _currentExerciseIndex > 0
                            ? () => _navigateExercise(-1)
                            : null,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_exercises.length, (index) {
                                return Container(
                                  width: index == _currentExerciseIndex ? 20 : 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: index == _currentExerciseIndex
                                        ? AppColors.primary
                                        : index < _currentExerciseIndex
                                            ? AppColors.success
                                            : AppColors.grey300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _currentExerciseIndex < _exercises.length - 1
                            ? () => _navigateExercise(1)
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Rest timer overlay
          if (_isResting)
            RestTimerOverlay(
              totalSeconds: _restSeconds,
              onComplete: _onRestComplete,
              onSkip: _skipRest,
              nextExercise: nextExercise,
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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

  Widget _buildCompletedSetCard(int setNumber, Map<String, dynamic> set) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.success,
          child: Text(
            '$setNumber',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${set['weight']} lbs',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${set['reps']} reps'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, color: AppColors.success),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _editSet(setNumber - 1),
            ),
          ],
        ),
      ),
    );
  }

  void _editSet(int index) {
    final set = _loggedSets[_currentExerciseIndex][index];
    final weightController = TextEditingController(text: set['weight'].toString());
    final repsController = TextEditingController(text: set['reps'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Set ${index + 1}'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _loggedSets[_currentExerciseIndex][index] = {
                  ...set,
                  'weight': double.tryParse(weightController.text) ?? set['weight'],
                  'reps': int.tryParse(repsController.text) ?? set['reps'],
                };
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Widget for inputting a set with enhanced UI.
class _SetInputCard extends StatefulWidget {
  final int setNumber;
  final void Function(int reps, double weight) onComplete;
  final double previousWeight;
  final int previousReps;

  const _SetInputCard({
    required this.setNumber,
    required this.onComplete,
    this.previousWeight = 135.0,
    this.previousReps = 10,
  });

  @override
  State<_SetInputCard> createState() => _SetInputCardState();
}

class _SetInputCardState extends State<_SetInputCard> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: widget.previousWeight.toStringAsFixed(0));
    _repsController = TextEditingController(text: widget.previousReps.toString());
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    final current = double.tryParse(_weightController.text) ?? 0;
    _weightController.text = (current + delta).clamp(0, 1000).toStringAsFixed(0);
  }

  void _adjustReps(int delta) {
    HapticFeedback.selectionClick();
    final current = int.tryParse(_repsController.text) ?? 0;
    _repsController.text = (current + delta).clamp(0, 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    'Set ${widget.setNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                // Weight input
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Weight (lbs)',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.grey500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _adjustWeight(-5),
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _adjustWeight(5),
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 1,
                  color: AppColors.grey200,
                ),
                // Reps input
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Reps',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.grey500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _adjustReps(-1),
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _repsController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _adjustReps(1),
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final weight = double.tryParse(_weightController.text) ?? 0;
                  final reps = int.tryParse(_repsController.text) ?? 0;
                  if (reps > 0) {
                    widget.onComplete(reps, weight);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Complete Set'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
