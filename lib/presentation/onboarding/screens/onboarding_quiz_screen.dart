import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/route_names.dart';

/// Provider for onboarding state
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// Onboarding state
class OnboardingState {
  final int currentStep;
  final Map<String, dynamic> answers;
  final bool isComplete;

  const OnboardingState({
    this.currentStep = 0,
    this.answers = const {},
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    Map<String, dynamic>? answers,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      answers: answers ?? this.answers,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// Onboarding notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setAnswer(String key, dynamic value) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers[key] = value;
    state = state.copyWith(answers: newAnswers);
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_answers', jsonEncode(state.answers));
    await prefs.setBool('onboarding_complete', true);
    state = state.copyWith(isComplete: true);
  }
}

/// Quiz questions
class QuizQuestion {
  final String id;
  final String question;
  final String subtitle;
  final List<QuizOption> options;
  final bool multiSelect;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.subtitle,
    required this.options,
    this.multiSelect = false,
  });
}

class QuizOption {
  final String value;
  final String label;
  final String? description;
  final IconData? icon;

  const QuizOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });
}

/// All quiz questions
const quizQuestions = [
  QuizQuestion(
    id: 'experience',
    question: 'What\'s your lifting experience?',
    subtitle: 'This helps us recommend the right programs',
    options: [
      QuizOption(
        value: 'beginner',
        label: 'Beginner',
        description: 'Less than 6 months',
        icon: Icons.emoji_nature,
      ),
      QuizOption(
        value: 'intermediate',
        label: 'Intermediate',
        description: '6 months - 2 years',
        icon: Icons.fitness_center,
      ),
      QuizOption(
        value: 'advanced',
        label: 'Advanced',
        description: '2+ years consistent training',
        icon: Icons.military_tech,
      ),
    ],
  ),
  QuizQuestion(
    id: 'goal',
    question: 'What\'s your primary goal?',
    subtitle: 'We\'ll tailor recommendations to help you get there',
    options: [
      QuizOption(
        value: 'strength',
        label: 'Build Strength',
        description: 'Increase 1RM and overall power',
        icon: Icons.flash_on,
      ),
      QuizOption(
        value: 'muscle',
        label: 'Build Muscle',
        description: 'Hypertrophy and aesthetics',
        icon: Icons.sports_gymnastics,
      ),
      QuizOption(
        value: 'lose_fat',
        label: 'Lose Fat',
        description: 'Maintain muscle while cutting',
        icon: Icons.local_fire_department,
      ),
      QuizOption(
        value: 'general',
        label: 'General Fitness',
        description: 'Overall health and wellness',
        icon: Icons.favorite,
      ),
    ],
  ),
  QuizQuestion(
    id: 'frequency',
    question: 'How often can you train?',
    subtitle: 'We\'ll suggest programs that fit your schedule',
    options: [
      QuizOption(
        value: '2-3',
        label: '2-3 days/week',
        description: 'Perfect for full body workouts',
        icon: Icons.calendar_today,
      ),
      QuizOption(
        value: '4',
        label: '4 days/week',
        description: 'Great for upper/lower splits',
        icon: Icons.calendar_view_week,
      ),
      QuizOption(
        value: '5-6',
        label: '5-6 days/week',
        description: 'Ideal for PPL or bro splits',
        icon: Icons.calendar_month,
      ),
    ],
  ),
  QuizQuestion(
    id: 'equipment',
    question: 'What equipment do you have?',
    subtitle: 'Select all that apply',
    multiSelect: true,
    options: [
      QuizOption(
        value: 'full_gym',
        label: 'Full Gym',
        description: 'Barbells, machines, cables',
        icon: Icons.store,
      ),
      QuizOption(
        value: 'home_gym',
        label: 'Home Gym',
        description: 'Rack, barbell, dumbbells',
        icon: Icons.home,
      ),
      QuizOption(
        value: 'dumbbells',
        label: 'Dumbbells Only',
        description: 'Adjustable or fixed',
        icon: Icons.fitness_center,
      ),
      QuizOption(
        value: 'bodyweight',
        label: 'Bodyweight',
        description: 'Minimal equipment',
        icon: Icons.accessibility_new,
      ),
    ],
  ),
  QuizQuestion(
    id: 'session_length',
    question: 'How long are your workouts?',
    subtitle: 'This affects exercise selection and volume',
    options: [
      QuizOption(
        value: '30-45',
        label: '30-45 minutes',
        description: 'Quick and efficient',
        icon: Icons.timer,
      ),
      QuizOption(
        value: '45-60',
        label: '45-60 minutes',
        description: 'Standard session',
        icon: Icons.schedule,
      ),
      QuizOption(
        value: '60-90',
        label: '60-90 minutes',
        description: 'Comprehensive training',
        icon: Icons.hourglass_full,
      ),
    ],
  ),
  QuizQuestion(
    id: 'tracking_style',
    question: 'How do you prefer to track?',
    subtitle: 'We\'ll optimize the interface for your style',
    options: [
      QuizOption(
        value: 'detailed',
        label: 'Detailed',
        description: 'Every set, rep, and weight',
        icon: Icons.analytics,
      ),
      QuizOption(
        value: 'simple',
        label: 'Simple',
        description: 'Just the essentials',
        icon: Icons.check_circle,
      ),
      QuizOption(
        value: 'flexible',
        label: 'Flexible',
        description: 'Mix of both',
        icon: Icons.tune,
      ),
    ],
  ),
];

/// Onboarding quiz screen
class OnboardingQuizScreen extends ConsumerWidget {
  const OnboardingQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final totalSteps = quizQuestions.length;
    final currentQuestion = state.currentStep < totalSteps
        ? quizQuestions[state.currentStep]
        : null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.currentStep > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            ref.read(onboardingProvider.notifier).previousStep();
                            HapticFeedback.selectionClick();
                          },
                        )
                      else
                        const SizedBox(width: 48),
                      Text(
                        '${state.currentStep + 1} of $totalSteps',
                        style: TextStyle(color: AppColors.grey500),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref.read(onboardingProvider.notifier).complete();
                          if (context.mounted) {
                            context.go(RoutePaths.home);
                          }
                        },
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    child: LinearProgressIndicator(
                      value: (state.currentStep + 1) / totalSteps,
                      backgroundColor: AppColors.grey200,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Question content
            Expanded(
              child: state.currentStep < totalSteps
                  ? _QuestionCard(
                      question: currentQuestion!,
                      answer: state.answers[currentQuestion.id],
                      onSelect: (value) {
                        ref.read(onboardingProvider.notifier).setAnswer(
                          currentQuestion.id,
                          value,
                        );
                      },
                    )
                  : _CompletionCard(
                      answers: state.answers,
                      onComplete: () async {
                        await ref.read(onboardingProvider.notifier).complete();
                        if (context.mounted) {
                          context.go(RoutePaths.home);
                        }
                      },
                    ),
            ),

            // Continue button
            if (state.currentStep < totalSteps)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.answers.containsKey(currentQuestion!.id)
                          ? () {
                              ref.read(onboardingProvider.notifier).nextStep();
                              HapticFeedback.mediumImpact();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        state.currentStep < totalSteps - 1 ? 'Continue' : 'Finish',
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Question card widget
class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final dynamic answer;
  final Function(dynamic) onSelect;

  const _QuestionCard({
    required this.question,
    required this.answer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        const SizedBox(height: AppDimensions.spacingLg),
        Text(
          question.question,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          question.subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ...question.options.map((option) {
          final isSelected = question.multiSelect
              ? (answer as List<String>?)?.contains(option.value) ?? false
              : answer == option.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              option: option,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                if (question.multiSelect) {
                  final currentList = List<String>.from(answer ?? []);
                  if (currentList.contains(option.value)) {
                    currentList.remove(option.value);
                  } else {
                    currentList.add(option.value);
                  }
                  onSelect(currentList);
                } else {
                  onSelect(option.value);
                }
              },
            ),
          );
        }),
      ],
    );
  }
}

/// Option card widget
class _OptionCard extends StatelessWidget {
  final QuizOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            if (option.icon != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  option.icon,
                  color: isSelected ? AppColors.primary : AppColors.grey500,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.primary : null,
                        ),
                  ),
                  if (option.description != null)
                    Text(
                      option.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey500,
                          ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary)
            else
              Icon(Icons.circle_outlined, color: AppColors.grey300),
          ],
        ),
      ),
    );
  }
}

/// Completion card with recommendations
class _CompletionCard extends StatelessWidget {
  final Map<String, dynamic> answers;
  final VoidCallback onComplete;

  const _CompletionCard({
    required this.answers,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final recommendation = _getRecommendation();

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        const SizedBox(height: AppDimensions.spacingLg),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 64,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Text(
          'You\'re All Set!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Based on your answers, here\'s what we recommend:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingLg),

        // Recommendation card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.star, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Program',
                            style: TextStyle(color: AppColors.grey500, fontSize: 12),
                          ),
                          Text(
                            recommendation['program']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _RecommendationItem(
                  icon: Icons.calendar_today,
                  label: 'Training Frequency',
                  value: recommendation['frequency']!,
                ),
                const SizedBox(height: 8),
                _RecommendationItem(
                  icon: Icons.timer,
                  label: 'Session Length',
                  value: recommendation['duration']!,
                ),
                const SizedBox(height: 8),
                _RecommendationItem(
                  icon: Icons.trending_up,
                  label: 'Focus Area',
                  value: recommendation['focus']!,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Get started button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onComplete,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Get Started'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, String> _getRecommendation() {
    final goal = answers['goal'] as String?;
    final frequency = answers['frequency'] as String?;
    final experience = answers['experience'] as String?;

    String program;
    String focus;

    // Determine program based on goal and frequency
    if (goal == 'strength') {
      program = frequency == '2-3' ? '5x5 Strength' : 'Power Building';
      focus = 'Compound lifts, progressive overload';
    } else if (goal == 'muscle') {
      if (frequency == '5-6') {
        program = 'Push/Pull/Legs (PPL)';
      } else if (frequency == '4') {
        program = 'Upper/Lower Split';
      } else {
        program = 'Full Body Hypertrophy';
      }
      focus = 'Volume, time under tension';
    } else if (goal == 'lose_fat') {
      program = 'Full Body Metabolic';
      focus = 'High intensity, calorie burn';
    } else {
      program = 'Balanced Full Body';
      focus = 'Functional fitness, consistency';
    }

    // Adjust for beginners
    if (experience == 'beginner') {
      program = 'Full Body Starter';
      focus = 'Form, fundamentals, building habits';
    }

    return {
      'program': program,
      'frequency': '${frequency ?? '3-4'} days per week',
      'duration': '${answers['session_length'] ?? '45-60'} minutes',
      'focus': focus,
    };
  }
}

/// Recommendation item widget
class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RecommendationItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.grey500),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: AppColors.grey500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
