import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../data/models/fitness_goals_model.dart';
import '../../../data/models/equipment_model.dart';
import '../../../data/models/gym_profile_model.dart';

/// Onboarding flow screen with multiple steps.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Collected data
  String _selectedGoal = FitnessGoalType.generalFitness;
  String _experienceLevel = ExperienceLevel.beginner;
  int _workoutDaysPerWeek = 4;
  final Set<String> _selectedEquipment = {};
  String _gymProfileType = GymProfileType.home;
  String _gymProfileName = 'Home Gym';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // TODO: Save user data and complete onboarding
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / _totalPages,
                      backgroundColor: AppColors.grey200,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildGoalsPage(),
                  _buildExperiencePage(),
                  _buildEquipmentPage(),
                  _buildCompletePage(),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage < _totalPages - 1
                      ? AppStrings.next
                      : AppStrings.getStarted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.whatsYourGoal,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Goal options
          ...FitnessGoalType.all.map((goal) {
            final isSelected = _selectedGoal == goal;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: Card(
                color: isSelected ? AppColors.primaryLight.withOpacity(0.1) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.grey200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  title: Text(FitnessGoalType.getDisplayName(goal)),
                  subtitle: Text(FitnessGoalType.getDescription(goal)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => setState(() => _selectedGoal = goal),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExperiencePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s your experience level?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Experience options
          ...ExperienceLevel.all.map((level) {
            final isSelected = _experienceLevel == level;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: Card(
                color: isSelected ? AppColors.primaryLight.withOpacity(0.1) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.grey200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  title: Text(ExperienceLevel.getDisplayName(level)),
                  subtitle: Text(ExperienceLevel.getDescription(level)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => setState(() => _experienceLevel = level),
                ),
              ),
            );
          }),

          const SizedBox(height: AppDimensions.spacingXl),

          // Workout days slider
          Text(
            'How many days per week can you workout?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              Text(
                '$_workoutDaysPerWeek',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                'days/week',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Slider(
            value: _workoutDaysPerWeek.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _workoutDaysPerWeek = value.toInt());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentPage() {
    final equipmentByCategory = <String, List<Equipment>>{};
    for (final equipment in DefaultEquipment.all) {
      equipmentByCategory.putIfAbsent(equipment.category, () => []);
      equipmentByCategory[equipment.category]!.add(equipment);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.selectEquipment,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            'Select the equipment you have access to',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Equipment categories
          ...equipmentByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  EquipmentCategory.getDisplayName(entry.key),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Wrap(
                  spacing: AppDimensions.spacingSm,
                  runSpacing: AppDimensions.spacingSm,
                  children: entry.value.map((equipment) {
                    final isSelected =
                        _selectedEquipment.contains(equipment.id);
                    return FilterChip(
                      label: Text(equipment.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedEquipment.add(equipment.id);
                          } else {
                            _selectedEquipment.remove(equipment.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCompletePage() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 100,
            color: AppColors.success,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            AppStrings.youreAllSet,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            'Your personalized workout plan is ready. Let\'s start your fitness journey!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
