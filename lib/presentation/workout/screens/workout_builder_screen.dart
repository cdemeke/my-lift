import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/route_names.dart';

/// Custom workout builder screen for creating personalized workouts.
class WorkoutBuilderScreen extends ConsumerStatefulWidget {
  final String? workoutId; // null for new, id for editing

  const WorkoutBuilderScreen({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends ConsumerState<WorkoutBuilderScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMuscleGroup = 'Full Body';
  final List<WorkoutExercise> _exercises = [];
  bool _isTemplate = false;

  final _muscleGroups = [
    'Full Body',
    'Push',
    'Pull',
    'Legs',
    'Upper Body',
    'Lower Body',
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Core',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.workoutId != null) {
      _loadExistingWorkout();
    }
  }

  void _loadExistingWorkout() {
    // TODO: Load from storage
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addExercise() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ExercisePickerSheet(),
    );

    if (result != null) {
      setState(() {
        _exercises.add(WorkoutExercise(
          id: const Uuid().v4(),
          name: result['name'] as String,
          muscleGroup: result['muscle'] as String,
          sets: 3,
          targetReps: '8-12',
          restSeconds: 90,
        ));
      });
    }
  }

  void _removeExercise(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    HapticFeedback.selectionClick();
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final exercise = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, exercise);
    });
  }

  void _editExercise(int index) async {
    final exercise = _exercises[index];
    final result = await showModalBottomSheet<WorkoutExercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseEditSheet(exercise: exercise),
    );

    if (result != null) {
      setState(() {
        _exercises[index] = result;
      });
    }
  }

  void _saveWorkout() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workout name')),
      );
      return;
    }

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise')),
      );
      return;
    }

    // TODO: Save to storage
    final workout = {
      'id': widget.workoutId ?? const Uuid().v4(),
      'name': _nameController.text.trim(),
      'muscleGroup': _selectedMuscleGroup,
      'notes': _notesController.text.trim(),
      'isTemplate': _isTemplate,
      'exercises': _exercises.map((e) => e.toMap()).toList(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isTemplate ? 'Template saved!' : 'Workout saved!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop(workout);
  }

  @override
  Widget build(BuildContext context) {
    final totalSets = _exercises.fold<int>(0, (sum, e) => sum + e.sets);
    final estDuration = _exercises.fold<int>(
      0,
      (sum, e) => sum + (e.sets * 45) + (e.sets * e.restSeconds),
    ) ~/ 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutId == null ? 'Create Workout' : 'Edit Workout'),
        actions: [
          TextButton.icon(
            onPressed: _saveWorkout,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              children: [
                // Workout name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Workout Name',
                    hintText: 'e.g., Push Day A',
                    prefixIcon: const Icon(Icons.fitness_center),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: AppDimensions.spacingMd),

                // Muscle group selector
                DropdownButtonFormField<String>(
                  value: _selectedMuscleGroup,
                  decoration: InputDecoration(
                    labelText: 'Target Muscle Group',
                    prefixIcon: const Icon(Icons.accessibility_new),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  items: _muscleGroups.map((group) {
                    return DropdownMenuItem(value: group, child: Text(group));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedMuscleGroup = value!);
                  },
                ),

                const SizedBox(height: AppDimensions.spacingMd),

                // Save as template toggle
                Card(
                  child: SwitchListTile(
                    title: const Text('Save as Template'),
                    subtitle: const Text('Reuse this workout anytime'),
                    secondary: Icon(
                      Icons.bookmark,
                      color: _isTemplate ? AppColors.primary : AppColors.grey400,
                    ),
                    value: _isTemplate,
                    onChanged: (value) => setState(() => _isTemplate = value),
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingLg),

                // Stats summary
                if (_exercises.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.format_list_numbered, '${_exercises.length}', 'Exercises'),
                        _buildStatItem(Icons.repeat, '$totalSets', 'Total Sets'),
                        _buildStatItem(Icons.timer, '~$estDuration min', 'Duration'),
                      ],
                    ),
                  ),

                const SizedBox(height: AppDimensions.spacingLg),

                // Exercises header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercises',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: _addExercise,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacingSm),

                // Exercises list
                if (_exercises.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingXl),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      border: Border.all(
                        color: AppColors.grey300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.fitness_center, size: 48, color: AppColors.grey400),
                        const SizedBox(height: AppDimensions.spacingMd),
                        Text(
                          'No exercises yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.grey500,
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          'Tap "Add" to build your workout',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.grey400,
                              ),
                        ),
                      ],
                    ),
                  )
                else
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _exercises.length,
                    onReorder: _reorderExercises,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return _ExerciseCard(
                        key: ValueKey(exercise.id),
                        exercise: exercise,
                        index: index,
                        onEdit: () => _editExercise(index),
                        onRemove: () => _removeExercise(index),
                      );
                    },
                  ),

                const SizedBox(height: AppDimensions.spacingMd),

                // Notes
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Add any notes about this workout...',
                    prefixIcon: const Icon(Icons.note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: AppDimensions.spacingXl),
              ],
            ),
          ),

          // Bottom action bar
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
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addExercise,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _exercises.isNotEmpty ? _saveWorkout : null,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Workout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
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

/// Exercise card widget
class _ExerciseCard extends StatelessWidget {
  final WorkoutExercise exercise;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.index,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${exercise.sets} sets × ${exercise.targetReps} reps • ${exercise.restSeconds}s rest',
          style: TextStyle(color: AppColors.grey500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
              onPressed: onRemove,
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle, color: AppColors.grey400),
            ),
          ],
        ),
      ),
    );
  }
}

/// Exercise model for workout builder
class WorkoutExercise {
  final String id;
  final String name;
  final String muscleGroup;
  int sets;
  String targetReps;
  int restSeconds;
  String? notes;

  WorkoutExercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.targetReps,
    required this.restSeconds,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'muscleGroup': muscleGroup,
        'sets': sets,
        'targetReps': targetReps,
        'restSeconds': restSeconds,
        'notes': notes,
      };

  WorkoutExercise copyWith({
    String? id,
    String? name,
    String? muscleGroup,
    int? sets,
    String? targetReps,
    int? restSeconds,
    String? notes,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      sets: sets ?? this.sets,
      targetReps: targetReps ?? this.targetReps,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
    );
  }
}

/// Exercise picker bottom sheet
class ExercisePickerSheet extends StatefulWidget {
  const ExercisePickerSheet({super.key});

  @override
  State<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<ExercisePickerSheet> {
  final _searchController = TextEditingController();
  String _selectedMuscle = 'All';
  String _searchQuery = '';

  final _muscles = ['All', 'Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Core'];

  final _exercises = [
    {'name': 'Bench Press', 'muscle': 'Chest'},
    {'name': 'Incline Bench Press', 'muscle': 'Chest'},
    {'name': 'Dumbbell Flyes', 'muscle': 'Chest'},
    {'name': 'Cable Crossover', 'muscle': 'Chest'},
    {'name': 'Push-Ups', 'muscle': 'Chest'},
    {'name': 'Dips', 'muscle': 'Chest'},
    {'name': 'Deadlift', 'muscle': 'Back'},
    {'name': 'Pull-Ups', 'muscle': 'Back'},
    {'name': 'Barbell Row', 'muscle': 'Back'},
    {'name': 'Lat Pulldown', 'muscle': 'Back'},
    {'name': 'Seated Cable Row', 'muscle': 'Back'},
    {'name': 'Face Pulls', 'muscle': 'Back'},
    {'name': 'Shoulder Press', 'muscle': 'Shoulders'},
    {'name': 'Lateral Raises', 'muscle': 'Shoulders'},
    {'name': 'Front Raises', 'muscle': 'Shoulders'},
    {'name': 'Reverse Flyes', 'muscle': 'Shoulders'},
    {'name': 'Shrugs', 'muscle': 'Shoulders'},
    {'name': 'Barbell Curl', 'muscle': 'Biceps'},
    {'name': 'Dumbbell Curl', 'muscle': 'Biceps'},
    {'name': 'Hammer Curl', 'muscle': 'Biceps'},
    {'name': 'Preacher Curl', 'muscle': 'Biceps'},
    {'name': 'Tricep Pushdown', 'muscle': 'Triceps'},
    {'name': 'Skull Crushers', 'muscle': 'Triceps'},
    {'name': 'Overhead Extension', 'muscle': 'Triceps'},
    {'name': 'Close Grip Bench', 'muscle': 'Triceps'},
    {'name': 'Squat', 'muscle': 'Legs'},
    {'name': 'Leg Press', 'muscle': 'Legs'},
    {'name': 'Lunges', 'muscle': 'Legs'},
    {'name': 'Leg Extension', 'muscle': 'Legs'},
    {'name': 'Leg Curl', 'muscle': 'Legs'},
    {'name': 'Calf Raises', 'muscle': 'Legs'},
    {'name': 'Romanian Deadlift', 'muscle': 'Legs'},
    {'name': 'Hip Thrust', 'muscle': 'Legs'},
    {'name': 'Plank', 'muscle': 'Core'},
    {'name': 'Crunches', 'muscle': 'Core'},
    {'name': 'Leg Raises', 'muscle': 'Core'},
    {'name': 'Russian Twist', 'muscle': 'Core'},
    {'name': 'Ab Wheel', 'muscle': 'Core'},
    {'name': 'Cable Crunch', 'muscle': 'Core'},
  ];

  List<Map<String, String>> get _filteredExercises {
    return _exercises.where((e) {
      final matchesMuscle = _selectedMuscle == 'All' || e['muscle'] == _selectedMuscle;
      final matchesSearch = _searchQuery.isEmpty ||
          e['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesMuscle && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Exercise',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Muscle filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
              itemCount: _muscles.length,
              itemBuilder: (context, index) {
                final muscle = _muscles[index];
                final isSelected = _selectedMuscle == muscle;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(muscle),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedMuscle = muscle),
                    backgroundColor: AppColors.grey100,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 20),
                  ),
                  title: Text(exercise['name']!),
                  subtitle: Text(exercise['muscle']!),
                  trailing: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                  onTap: () => Navigator.pop(context, exercise),
                );
              },
            ),
          ),

          // Custom exercise button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: OutlinedButton.icon(
                onPressed: () => _showCustomExerciseDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Exercise'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedMuscle = 'Chest';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g., Cable Flyes',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMuscle,
              decoration: const InputDecoration(labelText: 'Muscle Group'),
              items: _muscles.skip(1).map((m) {
                return DropdownMenuItem(value: m, child: Text(m));
              }).toList(),
              onChanged: (value) => selectedMuscle = value!,
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
              if (nameController.text.isNotEmpty) {
                Navigator.pop(context);
                Navigator.pop(this.context, {
                  'name': nameController.text,
                  'muscle': selectedMuscle,
                });
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Exercise edit bottom sheet
class ExerciseEditSheet extends StatefulWidget {
  final WorkoutExercise exercise;

  const ExerciseEditSheet({super.key, required this.exercise});

  @override
  State<ExerciseEditSheet> createState() => _ExerciseEditSheetState();
}

class _ExerciseEditSheetState extends State<ExerciseEditSheet> {
  late int _sets;
  late String _reps;
  late int _restSeconds;
  final _notesController = TextEditingController();

  final _repOptions = ['3-5', '5-8', '6-10', '8-12', '10-15', '12-20', '15-25', 'AMRAP'];
  final _restOptions = [30, 45, 60, 90, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    _sets = widget.exercise.sets;
    _reps = widget.exercise.targetReps;
    _restSeconds = widget.exercise.restSeconds;
    _notesController.text = widget.exercise.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            widget.exercise.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            widget.exercise.muscleGroup,
            style: TextStyle(color: AppColors.grey500),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Sets
          Text('Sets', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: _sets > 1 ? () => setState(() => _sets--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '$_sets',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _sets++),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Reps
          Text('Target Reps', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _repOptions.map((rep) {
              final isSelected = _reps == rep;
              return ChoiceChip(
                label: Text(rep),
                selected: isSelected,
                onSelected: (_) => setState(() => _reps = rep),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Rest
          Text('Rest Time', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _restOptions.map((rest) {
              final isSelected = _restSeconds == rest;
              return ChoiceChip(
                label: Text('${rest}s'),
                selected: isSelected,
                onSelected: (_) => setState(() => _restSeconds = rest),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Notes
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'e.g., Focus on squeeze at top',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Save button
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    widget.exercise.copyWith(
                      sets: _sets,
                      targetReps: _reps,
                      restSeconds: _restSeconds,
                      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
