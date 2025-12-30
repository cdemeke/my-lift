import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Muscle group heatmap showing training frequency and volume
class MuscleHeatmapScreen extends StatefulWidget {
  const MuscleHeatmapScreen({super.key});

  @override
  State<MuscleHeatmapScreen> createState() => _MuscleHeatmapScreenState();
}

class _MuscleHeatmapScreenState extends State<MuscleHeatmapScreen> {
  String _selectedPeriod = 'This Week';
  final _periods = ['This Week', 'Last 7 Days', 'Last 14 Days', 'This Month'];

  // Mock muscle training data
  final Map<String, MuscleTrainingData> _muscleData = {
    'Chest': MuscleTrainingData(sets: 16, exercises: 4, lastTrained: DateTime.now().subtract(const Duration(days: 1))),
    'Back': MuscleTrainingData(sets: 18, exercises: 5, lastTrained: DateTime.now().subtract(const Duration(days: 2))),
    'Shoulders': MuscleTrainingData(sets: 12, exercises: 3, lastTrained: DateTime.now().subtract(const Duration(days: 1))),
    'Biceps': MuscleTrainingData(sets: 9, exercises: 3, lastTrained: DateTime.now().subtract(const Duration(days: 2))),
    'Triceps': MuscleTrainingData(sets: 9, exercises: 3, lastTrained: DateTime.now().subtract(const Duration(days: 1))),
    'Quadriceps': MuscleTrainingData(sets: 12, exercises: 3, lastTrained: DateTime.now().subtract(const Duration(days: 3))),
    'Hamstrings': MuscleTrainingData(sets: 9, exercises: 2, lastTrained: DateTime.now().subtract(const Duration(days: 3))),
    'Glutes': MuscleTrainingData(sets: 8, exercises: 2, lastTrained: DateTime.now().subtract(const Duration(days: 3))),
    'Calves': MuscleTrainingData(sets: 6, exercises: 2, lastTrained: DateTime.now().subtract(const Duration(days: 5))),
    'Core': MuscleTrainingData(sets: 6, exercises: 2, lastTrained: DateTime.now().subtract(const Duration(days: 4))),
    'Forearms': MuscleTrainingData(sets: 4, exercises: 1, lastTrained: DateTime.now().subtract(const Duration(days: 6))),
    'Traps': MuscleTrainingData(sets: 6, exercises: 2, lastTrained: DateTime.now().subtract(const Duration(days: 2))),
  };

  Color _getIntensityColor(int sets) {
    if (sets >= 15) return Colors.red.shade600;
    if (sets >= 12) return Colors.orange.shade600;
    if (sets >= 9) return Colors.yellow.shade700;
    if (sets >= 6) return Colors.green.shade500;
    if (sets >= 3) return Colors.green.shade300;
    if (sets > 0) return Colors.green.shade100;
    return AppColors.grey200;
  }

  String _getRecoveryStatus(DateTime lastTrained) {
    final daysSince = DateTime.now().difference(lastTrained).inDays;
    if (daysSince >= 4) return 'Fully Recovered';
    if (daysSince >= 2) return 'Recovered';
    if (daysSince >= 1) return 'Recovering';
    return 'Recently Trained';
  }

  Color _getRecoveryColor(DateTime lastTrained) {
    final daysSince = DateTime.now().difference(lastTrained).inDays;
    if (daysSince >= 4) return Colors.green;
    if (daysSince >= 2) return Colors.lightGreen;
    if (daysSince >= 1) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final totalSets = _muscleData.values.fold(0, (sum, data) => sum + data.sets);
    final totalExercises = _muscleData.values.fold(0, (sum, data) => sum + data.exercises);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscle Heatmap'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _periods.map((period) {
                    final isSelected = period == _selectedPeriod;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(period),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedPeriod = period);
                          }
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Summary cards
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Total Sets',
                      value: '$totalSets',
                      icon: Icons.repeat,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Exercises',
                      value: '$totalExercises',
                      icon: Icons.fitness_center,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Muscles Hit',
                      value: '${_muscleData.entries.where((e) => e.value.sets > 0).length}',
                      icon: Icons.accessibility_new,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Body visualization
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Text(
                'Training Distribution',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Body heatmap
            _BodyHeatmap(muscleData: _muscleData),
            const SizedBox(height: 24),

            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: _buildLegend(),
            ),
            const SizedBox(height: 24),

            // Muscle list
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Text(
                'Muscle Breakdown',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),

            ..._muscleData.entries.map((entry) => _MuscleRow(
              muscle: entry.key,
              data: entry.value,
              color: _getIntensityColor(entry.value.sets),
              recoveryStatus: _getRecoveryStatus(entry.value.lastTrained),
              recoveryColor: _getRecoveryColor(entry.value.lastTrained),
              maxSets: _muscleData.values.map((d) => d.sets).reduce((a, b) => a > b ? a : b),
            )),

            const SizedBox(height: 24),

            // Recommendations
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: _RecommendationCard(muscleData: _muscleData),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Intensity (Sets per week)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendItem(color: Colors.green.shade100, label: '1-3'),
              _LegendItem(color: Colors.green.shade300, label: '3-6'),
              _LegendItem(color: Colors.green.shade500, label: '6-9'),
              _LegendItem(color: Colors.yellow.shade700, label: '9-12'),
              _LegendItem(color: Colors.orange.shade600, label: '12-15'),
              _LegendItem(color: Colors.red.shade600, label: '15+'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
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
              fontSize: 22,
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

class _BodyHeatmap extends StatelessWidget {
  final Map<String, MuscleTrainingData> muscleData;

  const _BodyHeatmap({required this.muscleData});

  Color _getColor(String muscle) {
    final data = muscleData[muscle];
    if (data == null || data.sets == 0) return AppColors.grey200;

    final sets = data.sets;
    if (sets >= 15) return Colors.red.shade600;
    if (sets >= 12) return Colors.orange.shade600;
    if (sets >= 9) return Colors.yellow.shade700;
    if (sets >= 6) return Colors.green.shade500;
    if (sets >= 3) return Colors.green.shade300;
    return Colors.green.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Front view
          Expanded(
            child: Column(
              children: [
                Text(
                  'Front',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _BodyFront(getColor: _getColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Back view
          Expanded(
            child: Column(
              children: [
                Text(
                  'Back',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _BodyBack(getColor: _getColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyFront extends StatelessWidget {
  final Color Function(String) getColor;

  const _BodyFront({required this.getColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BodyFrontPainter(getColor: getColor),
      size: Size.infinite,
    );
  }
}

class _BodyFrontPainter extends CustomPainter {
  final Color Function(String) getColor;

  _BodyFrontPainter({required this.getColor});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Draw simplified body outline with colored muscle groups

    // Head (outline only)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, 25), width: 35, height: 40),
      Paint()..color = AppColors.grey300..style = PaintingStyle.stroke..strokeWidth = 2,
    );

    // Shoulders/Traps
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 50, 50, 100, 25),
        const Radius.circular(8),
      ),
      Paint()..color = getColor('Shoulders'),
    );

    // Chest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 40, 75, 80, 50),
        const Radius.circular(8),
      ),
      Paint()..color = getColor('Chest'),
    );

    // Core
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 30, 125, 60, 50),
        const Radius.circular(8),
      ),
      Paint()..color = getColor('Core'),
    );

    // Left Bicep
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 65, 75, 20, 45),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Biceps'),
    );

    // Right Bicep
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 45, 75, 20, 45),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Biceps'),
    );

    // Left Forearm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 65, 125, 18, 40),
        const Radius.circular(4),
      ),
      Paint()..color = getColor('Forearms'),
    );

    // Right Forearm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 47, 125, 18, 40),
        const Radius.circular(4),
      ),
      Paint()..color = getColor('Forearms'),
    );

    // Left Quad
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 35, 180, 30, 70),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Quadriceps'),
    );

    // Right Quad
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 5, 180, 30, 70),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Quadriceps'),
    );

    // Left Calf
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 30, 260, 22, 40),
        const Radius.circular(4),
      ),
      Paint()..color = getColor('Calves'),
    );

    // Right Calf
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 8, 260, 22, 40),
        const Radius.circular(4),
      ),
      Paint()..color = getColor('Calves'),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BodyBack extends StatelessWidget {
  final Color Function(String) getColor;

  const _BodyBack({required this.getColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BodyBackPainter(getColor: getColor),
      size: Size.infinite,
    );
  }
}

class _BodyBackPainter extends CustomPainter {
  final Color Function(String) getColor;

  _BodyBackPainter({required this.getColor});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, 25), width: 35, height: 40),
      Paint()..color = AppColors.grey300..style = PaintingStyle.stroke..strokeWidth = 2,
    );

    // Traps
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 30, 50, 60, 25),
        const Radius.circular(8),
      ),
      Paint()..color = getColor('Traps'),
    );

    // Back (Lats)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 40, 75, 80, 60),
        const Radius.circular(8),
      ),
      Paint()..color = getColor('Back'),
    );

    // Lower Back
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 25, 135, 50, 35),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Back'),
    );

    // Left Tricep
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 65, 75, 20, 45),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Triceps'),
    );

    // Right Tricep
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 45, 75, 20, 45),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Triceps'),
    );

    // Glutes
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 35, 170, 70, 35),
        const Radius.circular(8),
      ),
      Paint()..color = getColor('Glutes'),
    );

    // Left Hamstring
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 35, 210, 30, 55),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Hamstrings'),
    );

    // Right Hamstring
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 5, 210, 30, 55),
        const Radius.circular(6),
      ),
      Paint()..color = getColor('Hamstrings'),
    );

    // Calves
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 30, 270, 22, 35),
        const Radius.circular(4),
      ),
      Paint()..color = getColor('Calves'),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 8, 270, 22, 35),
        const Radius.circular(4),
      ),
      Paint()..color = getColor('Calves'),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _MuscleRow extends StatelessWidget {
  final String muscle;
  final MuscleTrainingData data;
  final Color color;
  final String recoveryStatus;
  final Color recoveryColor;
  final int maxSets;

  const _MuscleRow({
    required this.muscle,
    required this.data,
    required this.color,
    required this.recoveryStatus,
    required this.recoveryColor,
    required this.maxSets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: 4,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  muscle,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: data.sets / maxSets,
                  backgroundColor: AppColors.grey200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.sets} sets',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: recoveryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  recoveryStatus,
                  style: TextStyle(
                    fontSize: 10,
                    color: recoveryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Map<String, MuscleTrainingData> muscleData;

  const _RecommendationCard({required this.muscleData});

  @override
  Widget build(BuildContext context) {
    // Find undertrained muscles
    final undertrained = muscleData.entries
        .where((e) => e.value.sets < 6)
        .map((e) => e.key)
        .take(3)
        .toList();

    // Find muscles ready for training
    final ready = muscleData.entries
        .where((e) => DateTime.now().difference(e.value.lastTrained).inDays >= 2)
        .map((e) => e.key)
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Training Recommendations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (undertrained.isNotEmpty) ...[
            Text(
              'Consider more volume for: ${undertrained.join(", ")}',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
          ],
          if (ready.isNotEmpty)
            Text(
              'Ready to train: ${ready.join(", ")}',
              style: const TextStyle(fontSize: 13),
            ),
        ],
      ),
    );
  }
}

/// Muscle training data model
class MuscleTrainingData {
  final int sets;
  final int exercises;
  final DateTime lastTrained;

  const MuscleTrainingData({
    required this.sets,
    required this.exercises,
    required this.lastTrained,
  });
}
