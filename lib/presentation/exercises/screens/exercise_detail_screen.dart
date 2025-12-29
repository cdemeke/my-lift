import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../widgets/exercise_demo_widget.dart';

/// Exercise detail screen with video and instructions.
class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock exercise data
    const exercise = {
      'name': 'Bench Press',
      'muscle': 'Chest',
      'type': 'Compound',
      'difficulty': 'Intermediate',
      'description':
          'The bench press is a compound exercise that primarily targets the chest muscles, but also works the shoulders and triceps.',
      'videoId': 'rT7DgCr-3pg', // YouTube video ID
      'formTips': [
        'Keep your feet flat on the floor',
        'Arch your back slightly',
        'Lower the bar to mid-chest',
        'Press up in a slight arc',
        'Keep wrists straight',
      ],
      'commonMistakes': [
        'Bouncing the bar off chest',
        'Flaring elbows too wide',
        'Lifting hips off bench',
        'Not using full range of motion',
      ],
      'equipment': ['Barbell', 'Bench'],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise['name'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Save to favorites
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise info chips
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: [
                  Chip(
                    label: Text(exercise['muscle'] as String),
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                  ),
                  Chip(
                    label: Text(exercise['type'] as String),
                  ),
                  Chip(
                    label: Text(exercise['difficulty'] as String),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // Animated exercise demonstration
              ExerciseDemoWidget(
                exerciseName: exercise['name'] as String,
                formTips: (exercise['formTips'] as List<String>),
                commonMistakes: (exercise['commonMistakes'] as List<String>),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // Description
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'About This Exercise',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      Text(
                        exercise['description'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              // Equipment needed
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.fitness_center, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Equipment Needed',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      Wrap(
                        spacing: AppDimensions.spacingSm,
                        children: (exercise['equipment'] as List<String>)
                            .map((e) => Chip(
                                  label: Text(e),
                                  avatar: const Icon(Icons.check, size: 16),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // Watch video button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(
                      'https://www.youtube.com/watch?v=${exercise['videoId']}',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Watch Video Tutorial'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              // Alternative exercises section
              Text(
                'Alternative Exercises',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildAlternativeCard(context, 'Dumbbell Bench Press'),
                    _buildAlternativeCard(context, 'Push-Ups'),
                    _buildAlternativeCard(context, 'Chest Press Machine'),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlternativeCard(BuildContext context, String name) {
    return Card(
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(AppDimensions.paddingSm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, color: AppColors.primary),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              name,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
