import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Weekly activity bar chart showing workout days.
class WeeklyActivityChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const WeeklyActivityChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((item) {
        final value = item['value'] as double;
        final isActive = value > 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              width: 32,
              height: isActive ? 100 : 20,
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: isActive ? null : AppColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isActive
                  ? const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 16),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              item['day'] as String,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.grey500,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Volume trend line chart.
class VolumeTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const VolumeTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final maxValue = data.map((d) => d['value'] as double).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((d) => d['value'] as double).reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    return CustomPaint(
      painter: _VolumeTrendPainter(
        data: data,
        maxValue: maxValue,
        minValue: minValue,
        range: range == 0 ? 1 : range,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: data.map((item) {
              return Text(
                item['label'] as String,
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 11,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _VolumeTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final double minValue;
  final double range;

  _VolumeTrendPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primary.withOpacity(0.3),
          AppColors.primary.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height - 20));

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final chartHeight = size.height - 30;
    final chartWidth = size.width;
    final pointSpacing = chartWidth / (data.length - 1);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final value = data[i]['value'] as double;
      final normalizedValue = (value - minValue) / range;
      final x = i * pointSpacing;
      final y = chartHeight - (normalizedValue * chartHeight * 0.8) - 20;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartHeight);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dot
      canvas.drawCircle(Offset(x, y), 6, dotPaint);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);

      // Draw value label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(value / 1000).toStringAsFixed(1)}k',
          style: TextStyle(
            color: AppColors.grey700,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - 20),
      );
    }

    // Complete fill path
    fillPath.lineTo(chartWidth - pointSpacing + pointSpacing, chartHeight);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Muscle group pie chart.
class MuscleGroupChart extends StatelessWidget {
  const MuscleGroupChart({super.key});

  @override
  Widget build(BuildContext context) {
    final muscleGroups = [
      {'name': 'Chest', 'value': 25.0, 'color': AppColors.primary},
      {'name': 'Back', 'value': 22.0, 'color': Colors.teal},
      {'name': 'Legs', 'value': 20.0, 'color': Colors.orange},
      {'name': 'Shoulders', 'value': 15.0, 'color': Colors.purple},
      {'name': 'Arms', 'value': 18.0, 'color': Colors.pink},
    ];

    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _PieChartPainter(muscleGroups),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: muscleGroups.map((group) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: group['color'] as Color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        group['name'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      '${(group['value'] as double).toInt()}%',
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final total = data.fold<double>(0, (sum, item) => sum + (item['value'] as double));

    double startAngle = -90 * 3.14159 / 180; // Start from top

    for (final item in data) {
      final sweepAngle = (item['value'] as double) / total * 2 * 3.14159;

      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + 0.02,
        sweepAngle - 0.04,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Progress line chart for tracking exercise progress over time.
class ExerciseProgressChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color color;

  const ExerciseProgressChart({
    super.key,
    required this.data,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    return CustomPaint(
      painter: _ExerciseProgressPainter(data: data, color: color),
      size: const Size(double.infinity, 100),
    );
  }
}

class _ExerciseProgressPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color color;

  _ExerciseProgressPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.map((d) => d['weight'] as double).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((d) => d['weight'] as double).reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final pointSpacing = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final value = data[i]['weight'] as double;
      final normalizedValue = range == 0 ? 0.5 : (value - minValue) / range;
      final x = i * pointSpacing;
      final y = size.height - (normalizedValue * size.height * 0.8) - 10;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
