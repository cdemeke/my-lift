import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Exercise progress screen showing strength gains over time
class ExerciseProgressScreen extends StatefulWidget {
  final String? exerciseId;

  const ExerciseProgressScreen({super.key, this.exerciseId});

  @override
  State<ExerciseProgressScreen> createState() => _ExerciseProgressScreenState();
}

class _ExerciseProgressScreenState extends State<ExerciseProgressScreen> {
  String _selectedExercise = 'Bench Press';
  String _selectedMetric = 'Estimated 1RM';
  String _selectedTimeRange = '3 Months';

  final _exercises = [
    'Bench Press',
    'Squat',
    'Deadlift',
    'Overhead Press',
    'Barbell Row',
    'Pull-Up',
  ];

  final _metrics = ['Estimated 1RM', 'Max Weight', 'Max Reps', 'Total Volume'];
  final _timeRanges = ['1 Month', '3 Months', '6 Months', '1 Year', 'All Time'];

  List<ProgressDataPoint> _getProgressData() {
    // Generate mock data based on selected exercise and time range
    final random = math.Random(42); // Fixed seed for consistent demo data
    final now = DateTime.now();
    int days;

    switch (_selectedTimeRange) {
      case '1 Month':
        days = 30;
        break;
      case '3 Months':
        days = 90;
        break;
      case '6 Months':
        days = 180;
        break;
      case '1 Year':
        days = 365;
        break;
      default:
        days = 365;
    }

    // Base weights for different exercises
    final baseWeights = {
      'Bench Press': 135.0,
      'Squat': 185.0,
      'Deadlift': 225.0,
      'Overhead Press': 95.0,
      'Barbell Row': 135.0,
      'Pull-Up': 0.0,
    };

    final baseWeight = baseWeights[_selectedExercise] ?? 135.0;
    final dataPoints = <ProgressDataPoint>[];

    // Generate data points (roughly 2-3 times per week)
    for (int i = days; i >= 0; i -= random.nextInt(3) + 2) {
      final date = now.subtract(Duration(days: i));
      final progress = (days - i) / days; // 0 to 1 as time progresses
      final variation = (random.nextDouble() - 0.5) * 10;

      double value;
      switch (_selectedMetric) {
        case 'Estimated 1RM':
          value = baseWeight + (progress * 30) + variation;
          break;
        case 'Max Weight':
          value = baseWeight * 0.85 + (progress * 25) + variation;
          break;
        case 'Max Reps':
          value = 8 + (progress * 4) + (random.nextDouble() * 2);
          break;
        case 'Total Volume':
          value = (baseWeight * 3 * 10) + (progress * 2000) + (variation * 100);
          break;
        default:
          value = baseWeight;
      }

      dataPoints.add(ProgressDataPoint(
        date: date,
        value: value,
        weight: baseWeight + (progress * 20),
        reps: (8 + random.nextInt(4)).toDouble(),
      ));
    }

    return dataPoints;
  }

  @override
  Widget build(BuildContext context) {
    final data = _getProgressData();
    final improvement = data.length >= 2
        ? ((data.last.value - data.first.value) / data.first.value * 100)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Progress'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise selector
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: DropdownButtonFormField<String>(
                value: _selectedExercise,
                decoration: InputDecoration(
                  labelText: 'Exercise',
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _exercises.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedExercise = value);
                  }
                },
              ),
            ),

            // Metric and time range selectors
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildChipSelector(
                      label: 'Metric',
                      selected: _selectedMetric,
                      options: _metrics,
                      onSelected: (value) {
                        setState(() => _selectedMetric = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Time range chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                itemCount: _timeRanges.length,
                itemBuilder: (context, index) {
                  final range = _timeRanges[index];
                  final isSelected = range == _selectedTimeRange;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(range),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedTimeRange = range);
                        }
                      },
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Progress summary cards
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Current',
                      value: _formatValue(data.isNotEmpty ? data.last.value : 0),
                      subtitle: _selectedMetric,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Starting',
                      value: _formatValue(data.isNotEmpty ? data.first.value : 0),
                      subtitle: _selectedMetric,
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Change',
                      value: '${improvement >= 0 ? '+' : ''}${improvement.toStringAsFixed(1)}%',
                      subtitle: 'Improvement',
                      color: improvement >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Progress chart
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _ProgressChart(
                  data: data,
                  metric: _selectedMetric,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Personal records section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Text(
                'Personal Records',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: _PRCard(
                exercise: _selectedExercise,
                data: data,
              ),
            ),
            const SizedBox(height: 24),

            // Recent sessions
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Text(
                'Recent Sessions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),

            ...data.reversed.take(5).map((point) => _SessionCard(
              date: point.date,
              weight: point.weight,
              reps: point.reps.toInt(),
              estimated1RM: point.value,
            )),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatValue(double value) {
    if (_selectedMetric == 'Max Reps') {
      return value.toStringAsFixed(0);
    } else if (_selectedMetric == 'Total Volume') {
      if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}k';
      }
      return value.toStringAsFixed(0);
    }
    return '${value.toStringAsFixed(0)} lbs';
  }

  Widget _buildChipSelector({
    required String label,
    required String selected,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      initialValue: selected,
      onSelected: (value) {
        HapticFeedback.selectionClick();
        onSelected(value);
      },
      itemBuilder: (context) => options.map((option) => PopupMenuItem(
        value: option,
        child: Text(option),
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressChart extends StatelessWidget {
  final List<ProgressDataPoint> data;
  final String metric;

  const _ProgressChart({
    required this.data,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return CustomPaint(
      size: Size.infinite,
      painter: _ChartPainter(
        data: data,
        lineColor: AppColors.primary,
        fillColor: AppColors.primary.withOpacity(0.1),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<ProgressDataPoint> data;
  final Color lineColor;
  final Color fillColor;

  _ChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minValue = data.map((d) => d.value).reduce(math.min) * 0.95;
    final maxValue = data.map((d) => d.value).reduce(math.max) * 1.05;
    final valueRange = maxValue - minValue;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height - (size.height * i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Calculate points
    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final y = size.height - ((data[i].value - minValue) / valueRange * size.height);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, linePaint);

    // Draw dots on recent points
    for (int i = math.max(0, points.length - 5); i < points.length; i++) {
      canvas.drawCircle(points[i], 4, dotPaint);
      canvas.drawCircle(points[i], 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PRCard extends StatelessWidget {
  final String exercise;
  final List<ProgressDataPoint> data;

  const _PRCard({
    required this.exercise,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.isNotEmpty
        ? data.map((d) => d.value).reduce(math.max)
        : 0.0;
    final maxWeight = data.isNotEmpty
        ? data.map((d) => d.weight).reduce(math.max)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade600,
            Colors.orange.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All-Time Best',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${maxValue.toStringAsFixed(0)} lbs (est. 1RM)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Max lifted: ${maxWeight.toStringAsFixed(0)} lbs',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final DateTime date;
  final double weight;
  final int reps;
  final double estimated1RM;

  const _SessionCard({
    required this.date,
    required this.weight,
    required this.reps,
    required this.estimated1RM,
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                DateFormat('d').format(date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(date),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${weight.toStringAsFixed(0)} lbs × $reps reps',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${estimated1RM.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'est. 1RM',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Progress data point model
class ProgressDataPoint {
  final DateTime date;
  final double value;
  final double weight;
  final double reps;

  const ProgressDataPoint({
    required this.date,
    required this.value,
    required this.weight,
    required this.reps,
  });
}
