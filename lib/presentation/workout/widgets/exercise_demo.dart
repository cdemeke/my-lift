import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Exercise with demo video information
class ExerciseDemo {
  final String id;
  final String name;
  final String muscle;
  final String description;
  final List<String> instructions;
  final List<String> tips;
  final String? youtubeVideoId;
  final String? thumbnailUrl;
  final ExerciseDifficulty difficulty;
  final List<String> equipment;
  final List<String> musclesWorked;

  const ExerciseDemo({
    required this.id,
    required this.name,
    required this.muscle,
    required this.description,
    this.instructions = const [],
    this.tips = const [],
    this.youtubeVideoId,
    this.thumbnailUrl,
    this.difficulty = ExerciseDifficulty.intermediate,
    this.equipment = const [],
    this.musclesWorked = const [],
  });
}

enum ExerciseDifficulty { beginner, intermediate, advanced }

/// Exercise demo library with common exercises
class ExerciseDemoLibrary {
  static const List<ExerciseDemo> exercises = [
    // Chest
    ExerciseDemo(
      id: 'bench_press',
      name: 'Barbell Bench Press',
      muscle: 'Chest',
      description: 'The king of chest exercises. A compound movement that builds overall upper body strength.',
      instructions: [
        'Lie flat on the bench with feet planted on the floor',
        'Grip the bar slightly wider than shoulder width',
        'Unrack the bar and position it over your chest',
        'Lower the bar to your mid-chest with control',
        'Press the bar back up to the starting position',
      ],
      tips: [
        'Keep your shoulder blades retracted and squeezed together',
        'Maintain a slight arch in your lower back',
        'Don\'t bounce the bar off your chest',
        'Exhale as you press up',
      ],
      youtubeVideoId: 'SCVCLChPQFY',
      difficulty: ExerciseDifficulty.intermediate,
      equipment: ['Barbell', 'Bench'],
      musclesWorked: ['Chest', 'Triceps', 'Front Deltoids'],
    ),
    ExerciseDemo(
      id: 'incline_dumbbell_press',
      name: 'Incline Dumbbell Press',
      muscle: 'Upper Chest',
      description: 'Targets the upper chest fibers for a fuller chest development.',
      instructions: [
        'Set the bench to 30-45 degree incline',
        'Hold dumbbells at shoulder height',
        'Press the weights up and slightly together',
        'Lower with control to shoulder level',
      ],
      tips: [
        'Don\'t set the incline too high (limits chest activation)',
        'Keep elbows at 45-60 degree angle',
        'Squeeze chest at the top',
      ],
      youtubeVideoId: '8iPEnn-ltC8',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Dumbbells', 'Incline Bench'],
      musclesWorked: ['Upper Chest', 'Front Deltoids', 'Triceps'],
    ),
    ExerciseDemo(
      id: 'dumbbell_fly',
      name: 'Dumbbell Fly',
      muscle: 'Chest',
      description: 'An isolation exercise that stretches and contracts the chest muscles.',
      instructions: [
        'Lie flat on a bench holding dumbbells above chest',
        'With a slight bend in elbows, lower arms out to sides',
        'Lower until you feel a stretch in your chest',
        'Bring the weights back together in an arc motion',
      ],
      tips: [
        'Keep a slight bend in your elbows throughout',
        'Focus on the stretch at the bottom',
        'Use lighter weight than pressing exercises',
      ],
      youtubeVideoId: 'eozdVDA78K0',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Dumbbells', 'Flat Bench'],
      musclesWorked: ['Chest'],
    ),

    // Back
    ExerciseDemo(
      id: 'deadlift',
      name: 'Conventional Deadlift',
      muscle: 'Back',
      description: 'The ultimate full-body strength builder. Works the entire posterior chain.',
      instructions: [
        'Stand with feet hip-width apart, bar over mid-foot',
        'Bend at hips and knees to grip the bar',
        'Keep your back flat and chest up',
        'Drive through your heels to lift the bar',
        'Stand tall, then lower with control',
      ],
      tips: [
        'Keep the bar close to your body throughout',
        'Don\'t round your lower back',
        'Engage your lats before lifting',
        'Lock out with hips, not by leaning back',
      ],
      youtubeVideoId: 'op9kVnSso6Q',
      difficulty: ExerciseDifficulty.advanced,
      equipment: ['Barbell'],
      musclesWorked: ['Lower Back', 'Glutes', 'Hamstrings', 'Traps', 'Forearms'],
    ),
    ExerciseDemo(
      id: 'barbell_row',
      name: 'Barbell Bent-Over Row',
      muscle: 'Back',
      description: 'A compound pulling movement for building a thick, wide back.',
      instructions: [
        'Hinge at the hips with knees slightly bent',
        'Keep your back parallel to the floor',
        'Pull the bar to your lower chest/upper abs',
        'Squeeze your shoulder blades together at the top',
        'Lower with control',
      ],
      tips: [
        'Don\'t use momentum to swing the weight',
        'Keep your core tight throughout',
        'Pull your elbows back, not just up',
      ],
      youtubeVideoId: 'FWJR5Ve8bnQ',
      difficulty: ExerciseDifficulty.intermediate,
      equipment: ['Barbell'],
      musclesWorked: ['Lats', 'Rhomboids', 'Rear Deltoids', 'Biceps'],
    ),
    ExerciseDemo(
      id: 'pull_up',
      name: 'Pull-Up',
      muscle: 'Back',
      description: 'The ultimate bodyweight back exercise for lat development.',
      instructions: [
        'Grip the bar slightly wider than shoulder width',
        'Hang with arms fully extended',
        'Pull yourself up until chin is over the bar',
        'Lower with control to full extension',
      ],
      tips: [
        'Initiate the pull by depressing your shoulder blades',
        'Keep your core engaged to prevent swinging',
        'Use assisted variations if needed',
      ],
      youtubeVideoId: 'eGo4IYlbE5g',
      difficulty: ExerciseDifficulty.intermediate,
      equipment: ['Pull-up Bar'],
      musclesWorked: ['Lats', 'Biceps', 'Rear Deltoids', 'Core'],
    ),
    ExerciseDemo(
      id: 'lat_pulldown',
      name: 'Lat Pulldown',
      muscle: 'Back',
      description: 'Machine variation of the pull-up, great for all levels.',
      instructions: [
        'Sit with thighs secured under the pads',
        'Grip the bar wider than shoulder width',
        'Pull the bar down to upper chest',
        'Squeeze your lats at the bottom',
        'Return with control',
      ],
      tips: [
        'Lean back slightly (about 15-20 degrees)',
        'Don\'t pull behind your neck',
        'Focus on pulling with your elbows',
      ],
      youtubeVideoId: 'CAwf7n6Luuc',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Cable Machine'],
      musclesWorked: ['Lats', 'Biceps', 'Rear Deltoids'],
    ),

    // Shoulders
    ExerciseDemo(
      id: 'overhead_press',
      name: 'Overhead Press',
      muscle: 'Shoulders',
      description: 'The primary compound movement for building shoulder strength and size.',
      instructions: [
        'Stand with feet shoulder-width apart',
        'Hold the bar at collar bone height',
        'Press the bar overhead in a straight line',
        'Lock out arms at the top',
        'Lower with control to starting position',
      ],
      tips: [
        'Keep your core tight to protect your lower back',
        'Move your head back slightly as the bar passes',
        'Squeeze your glutes for stability',
      ],
      youtubeVideoId: '_RlRDWO2jfg',
      difficulty: ExerciseDifficulty.intermediate,
      equipment: ['Barbell'],
      musclesWorked: ['Front Deltoids', 'Side Deltoids', 'Triceps', 'Upper Chest'],
    ),
    ExerciseDemo(
      id: 'lateral_raise',
      name: 'Lateral Raise',
      muscle: 'Side Deltoids',
      description: 'Isolation exercise for building wider shoulders.',
      instructions: [
        'Stand with dumbbells at your sides',
        'Raise arms out to the sides until parallel to floor',
        'Keep a slight bend in your elbows',
        'Lower with control',
      ],
      tips: [
        'Don\'t swing the weight - use controlled motion',
        'Lead with your elbows, not your hands',
        'Stop at shoulder height',
      ],
      youtubeVideoId: '3VcKaXpzqRo',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Dumbbells'],
      musclesWorked: ['Side Deltoids'],
    ),
    ExerciseDemo(
      id: 'face_pull',
      name: 'Face Pull',
      muscle: 'Rear Deltoids',
      description: 'Essential exercise for shoulder health and rear delt development.',
      instructions: [
        'Set cable at face height with rope attachment',
        'Pull the rope toward your face',
        'Separate the rope ends as you pull back',
        'Squeeze shoulder blades together',
        'Return with control',
      ],
      tips: [
        'Keep your elbows high throughout',
        'Focus on external rotation at the end',
        'Use lighter weight for better form',
      ],
      youtubeVideoId: 'rep-qVOkqgk',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Cable Machine', 'Rope Attachment'],
      musclesWorked: ['Rear Deltoids', 'Rhomboids', 'External Rotators'],
    ),

    // Legs
    ExerciseDemo(
      id: 'squat',
      name: 'Barbell Back Squat',
      muscle: 'Legs',
      description: 'The king of leg exercises. Builds overall lower body strength and mass.',
      instructions: [
        'Position bar on upper back (high bar) or rear delts (low bar)',
        'Stand with feet shoulder-width apart, toes slightly out',
        'Break at hips and knees simultaneously',
        'Descend until thighs are at least parallel',
        'Drive through your feet to stand back up',
      ],
      tips: [
        'Keep your chest up throughout the movement',
        'Push your knees out in line with toes',
        'Don\'t let your lower back round at the bottom',
        'Take a deep breath before descending',
      ],
      youtubeVideoId: 'bEv6CCg2BC8',
      difficulty: ExerciseDifficulty.advanced,
      equipment: ['Barbell', 'Squat Rack'],
      musclesWorked: ['Quadriceps', 'Glutes', 'Hamstrings', 'Core'],
    ),
    ExerciseDemo(
      id: 'leg_press',
      name: 'Leg Press',
      muscle: 'Legs',
      description: 'Machine-based quad builder with reduced spinal load.',
      instructions: [
        'Sit in the leg press with back flat against pad',
        'Place feet shoulder-width apart on platform',
        'Release the safety and lower the weight',
        'Lower until knees reach 90 degrees',
        'Press through your heels to extend',
      ],
      tips: [
        'Don\'t lock out your knees at the top',
        'Keep your lower back pressed into the seat',
        'Adjust foot position to target different muscles',
      ],
      youtubeVideoId: 'IZxyjW7MPJQ',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Leg Press Machine'],
      musclesWorked: ['Quadriceps', 'Glutes', 'Hamstrings'],
    ),
    ExerciseDemo(
      id: 'romanian_deadlift',
      name: 'Romanian Deadlift',
      muscle: 'Hamstrings',
      description: 'The best exercise for hamstring development and hip hinge pattern.',
      instructions: [
        'Hold the bar at hip level with straight arms',
        'Push your hips back while keeping legs nearly straight',
        'Lower the bar along your legs',
        'Feel the stretch in your hamstrings',
        'Drive hips forward to return to start',
      ],
      tips: [
        'Keep the bar close to your body',
        'Maintain a neutral spine - don\'t round your back',
        'Only go as low as your flexibility allows',
      ],
      youtubeVideoId: 'JCXUYuzwNrM',
      difficulty: ExerciseDifficulty.intermediate,
      equipment: ['Barbell'],
      musclesWorked: ['Hamstrings', 'Glutes', 'Lower Back'],
    ),
    ExerciseDemo(
      id: 'leg_curl',
      name: 'Lying Leg Curl',
      muscle: 'Hamstrings',
      description: 'Isolation exercise for direct hamstring work.',
      instructions: [
        'Lie face down on the machine',
        'Position the pad just above your heels',
        'Curl your legs up toward your glutes',
        'Squeeze at the top',
        'Lower with control',
      ],
      tips: [
        'Don\'t lift your hips off the pad',
        'Control the negative portion',
        'Point your toes for more hamstring activation',
      ],
      youtubeVideoId: '1Tq3QdYUuHs',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Leg Curl Machine'],
      musclesWorked: ['Hamstrings'],
    ),

    // Arms
    ExerciseDemo(
      id: 'barbell_curl',
      name: 'Barbell Curl',
      muscle: 'Biceps',
      description: 'Classic bicep builder for overall arm mass.',
      instructions: [
        'Stand holding a barbell with underhand grip',
        'Keep your elbows at your sides',
        'Curl the weight up toward your shoulders',
        'Squeeze at the top',
        'Lower with control',
      ],
      tips: [
        'Don\'t swing the weight - keep it strict',
        'Keep your elbows stationary',
        'Use a full range of motion',
      ],
      youtubeVideoId: 'kwG2ipFRgfo',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Barbell'],
      musclesWorked: ['Biceps', 'Forearms'],
    ),
    ExerciseDemo(
      id: 'tricep_pushdown',
      name: 'Tricep Pushdown',
      muscle: 'Triceps',
      description: 'Essential isolation movement for tricep development.',
      instructions: [
        'Stand at cable machine with rope or bar attachment',
        'Keep elbows pinned to your sides',
        'Push the weight down until arms are straight',
        'Squeeze triceps at the bottom',
        'Return with control',
      ],
      tips: [
        'Keep your torso upright - don\'t lean over',
        'Only move your forearms, not your upper arms',
        'Try different attachments for variety',
      ],
      youtubeVideoId: '2-LAMcpzODU',
      difficulty: ExerciseDifficulty.beginner,
      equipment: ['Cable Machine'],
      musclesWorked: ['Triceps'],
    ),
    ExerciseDemo(
      id: 'skull_crusher',
      name: 'Skull Crusher',
      muscle: 'Triceps',
      description: 'Excellent tricep builder that targets the long head.',
      instructions: [
        'Lie on a bench holding an EZ bar or dumbbells',
        'Start with arms extended above your chest',
        'Bend elbows to lower weight toward your forehead',
        'Keep upper arms stationary',
        'Extend arms back to start',
      ],
      tips: [
        'Control the weight - don\'t actually crush your skull!',
        'Keep elbows pointed up, not flaring out',
        'Lower to forehead or just behind for more stretch',
      ],
      youtubeVideoId: 'd_KZxkY_0cM',
      difficulty: ExerciseDifficulty.intermediate,
      equipment: ['EZ Bar', 'Bench'],
      musclesWorked: ['Triceps'],
    ),
  ];

  static ExerciseDemo? findByName(String name) {
    final nameLower = name.toLowerCase();
    return exercises.cast<ExerciseDemo?>().firstWhere(
          (e) => e!.name.toLowerCase().contains(nameLower) ||
              nameLower.contains(e.name.toLowerCase()),
          orElse: () => null,
        );
  }

  static List<ExerciseDemo> filterByMuscle(String muscle) {
    return exercises.where((e) =>
      e.muscle.toLowerCase() == muscle.toLowerCase() ||
      e.musclesWorked.any((m) => m.toLowerCase() == muscle.toLowerCase())
    ).toList();
  }
}

/// Compact exercise demo button
class ExerciseDemoButton extends StatelessWidget {
  final String exerciseName;
  final VoidCallback? onTap;

  const ExerciseDemoButton({
    super.key,
    required this.exerciseName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDemo = ExerciseDemoLibrary.findByName(exerciseName) != null;

    return GestureDetector(
      onTap: hasDemo ? () {
        HapticFeedback.selectionClick();
        final demo = ExerciseDemoLibrary.findByName(exerciseName);
        if (demo != null) {
          ExerciseDemoSheet.show(context, demo);
        }
        onTap?.call();
      } : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: hasDemo
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.grey100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_circle_outline,
          size: 20,
          color: hasDemo ? AppColors.primary : AppColors.grey400,
        ),
      ),
    );
  }
}

/// Full exercise demo sheet with video and instructions
class ExerciseDemoSheet extends StatefulWidget {
  final ExerciseDemo exercise;

  const ExerciseDemoSheet({
    super.key,
    required this.exercise,
  });

  static Future<void> show(BuildContext context, ExerciseDemo exercise) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusLg),
            ),
          ),
          child: ExerciseDemoSheet(exercise: exercise),
        ),
      ),
    );
  }

  @override
  State<ExerciseDemoSheet> createState() => _ExerciseDemoSheetState();
}

class _ExerciseDemoSheetState extends State<ExerciseDemoSheet> {
  YoutubePlayerController? _controller;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.exercise.youtubeVideoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: widget.exercise.youtubeVideoId!,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
        ),
      );
      _isVideoLoaded = true;
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildTag(widget.exercise.muscle, AppColors.primary),
                            const SizedBox(width: 8),
                            _buildDifficultyTag(widget.exercise.difficulty),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Video player
              if (_isVideoLoaded && _controller != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(controller: _controller!),
                  ),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off_outlined,
                          size: 48,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No video available',
                          style: TextStyle(color: AppColors.grey500),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Description
              Text(
                widget.exercise.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Muscles worked
              if (widget.exercise.musclesWorked.isNotEmpty) ...[
                _buildSectionHeader('Muscles Worked', Icons.accessibility_new),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.exercise.musclesWorked.map((m) =>
                    _buildTag(m, AppColors.success)
                  ).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Equipment
              if (widget.exercise.equipment.isNotEmpty) ...[
                _buildSectionHeader('Equipment Needed', Icons.fitness_center),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.exercise.equipment.map((e) =>
                    _buildTag(e, AppColors.grey600)
                  ).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Instructions
              if (widget.exercise.instructions.isNotEmpty) ...[
                _buildSectionHeader('How To Perform', Icons.format_list_numbered),
                const SizedBox(height: 12),
                ...widget.exercise.instructions.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Tips
              if (widget.exercise.tips.isNotEmpty) ...[
                _buildSectionHeader('Pro Tips', Icons.lightbulb_outline),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: widget.exercise.tips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDifficultyTag(ExerciseDifficulty difficulty) {
    Color color;
    String text;
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        color = Colors.green;
        text = 'Beginner';
        break;
      case ExerciseDifficulty.intermediate:
        color = Colors.orange;
        text = 'Intermediate';
        break;
      case ExerciseDifficulty.advanced:
        color = Colors.red;
        text = 'Advanced';
        break;
    }
    return _buildTag(text, color);
  }
}

/// Exercise library browser
class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _searchQuery = '';
  String? _selectedMuscle;

  final _muscleGroups = ['All', 'Chest', 'Back', 'Shoulders', 'Legs', 'Biceps', 'Triceps'];

  List<ExerciseDemo> get _filteredExercises {
    return ExerciseDemoLibrary.exercises.where((e) {
      final matchesSearch = _searchQuery.isEmpty ||
          e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.muscle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesMuscle = _selectedMuscle == null ||
          _selectedMuscle == 'All' ||
          e.muscle.toLowerCase().contains(_selectedMuscle!.toLowerCase()) ||
          e.musclesWorked.any((m) => m.toLowerCase().contains(_selectedMuscle!.toLowerCase()));
      return matchesSearch && matchesMuscle;
    }).toList();
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
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.grey100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Muscle filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
              itemCount: _muscleGroups.length,
              itemBuilder: (context, index) {
                final muscle = _muscleGroups[index];
                final isSelected = (_selectedMuscle ?? 'All') == muscle;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(muscle),
                    selected: isSelected,
                    onSelected: (selected) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedMuscle = selected ? muscle : 'All');
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return _ExerciseCard(
                  exercise: exercise,
                  onTap: () => ExerciseDemoSheet.show(context, exercise),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseDemo exercise;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  exercise.youtubeVideoId != null
                      ? Icons.play_circle_filled
                      : Icons.fitness_center,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            exercise.muscle,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.grey600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (exercise.youtubeVideoId != null)
                          Row(
                            children: [
                              Icon(
                                Icons.videocam,
                                size: 14,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Video',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.grey400),
            ],
          ),
        ),
      ),
    );
  }
}
