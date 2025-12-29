import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/route_names.dart';
import '../../../data/models/exercise_model.dart';

/// Exercise library screen for browsing exercises.
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  final _searchController = TextEditingController();
  String _selectedMuscleGroup = '';
  String _searchQuery = '';

  // Mock exercises
  final _exercises = [
    {'id': '1', 'name': 'Bench Press', 'muscle': 'Chest', 'type': 'Compound'},
    {'id': '2', 'name': 'Incline Dumbbell Press', 'muscle': 'Chest', 'type': 'Compound'},
    {'id': '3', 'name': 'Cable Flyes', 'muscle': 'Chest', 'type': 'Isolation'},
    {'id': '4', 'name': 'Barbell Row', 'muscle': 'Back', 'type': 'Compound'},
    {'id': '5', 'name': 'Lat Pulldown', 'muscle': 'Back', 'type': 'Compound'},
    {'id': '6', 'name': 'Seated Cable Row', 'muscle': 'Back', 'type': 'Compound'},
    {'id': '7', 'name': 'Shoulder Press', 'muscle': 'Shoulders', 'type': 'Compound'},
    {'id': '8', 'name': 'Lateral Raises', 'muscle': 'Shoulders', 'type': 'Isolation'},
    {'id': '9', 'name': 'Barbell Curl', 'muscle': 'Biceps', 'type': 'Isolation'},
    {'id': '10', 'name': 'Tricep Pushdown', 'muscle': 'Triceps', 'type': 'Isolation'},
    {'id': '11', 'name': 'Squat', 'muscle': 'Legs', 'type': 'Compound'},
    {'id': '12', 'name': 'Romanian Deadlift', 'muscle': 'Legs', 'type': 'Compound'},
    {'id': '13', 'name': 'Leg Press', 'muscle': 'Legs', 'type': 'Compound'},
    {'id': '14', 'name': 'Plank', 'muscle': 'Core', 'type': 'Isolation'},
    {'id': '15', 'name': 'Cable Crunch', 'muscle': 'Core', 'type': 'Isolation'},
  ];

  List<Map<String, String>> get _filteredExercises {
    return _exercises.where((exercise) {
      final matchesSearch = _searchQuery.isEmpty ||
          exercise['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesMuscle = _selectedMuscleGroup.isEmpty ||
          exercise['muscle'] == _selectedMuscleGroup;
      return matchesSearch && matchesMuscle;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Muscle group filters
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              children: [
                _buildFilterChip('All', ''),
                ...['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Core']
                    .map((muscle) => _buildFilterChip(muscle, muscle)),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingSm),

          // Exercise list
          Expanded(
            child: _filteredExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        Text(
                          'No exercises found',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.grey500,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    itemCount: _filteredExercises.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDimensions.spacingSm),
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getMuscleColor(exercise['muscle']!)
                                .withOpacity(0.2),
                            child: Icon(
                              Icons.fitness_center,
                              color: _getMuscleColor(exercise['muscle']!),
                            ),
                          ),
                          title: Text(exercise['name']!),
                          subtitle: Text(
                            '${exercise['muscle']} • ${exercise['type']}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.push(
                              RoutePaths.exerciseDetailPath(exercise['id']!),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedMuscleGroup == value;
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.spacingXs),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedMuscleGroup = selected ? value : '';
          });
        },
      ),
    );
  }

  Color _getMuscleColor(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest':
        return AppColors.chest;
      case 'back':
        return AppColors.back;
      case 'shoulders':
        return AppColors.shoulders;
      case 'biceps':
      case 'triceps':
        return AppColors.arms;
      case 'legs':
        return AppColors.legs;
      case 'core':
        return AppColors.core;
      default:
        return AppColors.primary;
    }
  }
}
