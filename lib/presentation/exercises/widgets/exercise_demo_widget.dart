import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Animated exercise demonstration widget with form tips.
class ExerciseDemoWidget extends StatefulWidget {
  final String exerciseName;
  final List<String> formTips;
  final List<String> commonMistakes;

  const ExerciseDemoWidget({
    super.key,
    required this.exerciseName,
    required this.formTips,
    required this.commonMistakes,
  });

  @override
  State<ExerciseDemoWidget> createState() => _ExerciseDemoWidgetState();
}

class _ExerciseDemoWidgetState extends State<ExerciseDemoWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _pulseController;
  late Animation<double> _breathAnimation;
  late Animation<double> _pulseAnimation;
  int _currentTipIndex = 0;

  @override
  void initState() {
    super.initState();

    // Breathing animation for the figure
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Pulse animation for highlights
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Cycle through tips
    Future.delayed(const Duration(seconds: 4), _cycleTips);
  }

  void _cycleTips() {
    if (!mounted) return;
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % widget.formTips.length;
    });
    Future.delayed(const Duration(seconds: 4), _cycleTips);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated figure area
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.05),
                AppColors.secondary.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background grid
              CustomPaint(
                size: const Size(double.infinity, 280),
                painter: _GridPainter(),
              ),

              // Animated figure
              AnimatedBuilder(
                animation: _breathAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _breathAnimation.value,
                    child: CustomPaint(
                      size: const Size(150, 200),
                      painter: _ExerciseFigurePainter(
                        exerciseType: widget.exerciseName,
                        pulseValue: _pulseAnimation.value,
                      ),
                    ),
                  );
                },
              ),

              // Current tip highlight
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    key: ValueKey(_currentTipIndex),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, _) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(_pulseAnimation.value * 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.formTips[_currentTipIndex],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Tip indicator dots
              Positioned(
                top: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.formTips.length, (index) {
                    return Container(
                      width: index == _currentTipIndex ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index == _currentTipIndex
                            ? AppColors.primary
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Form tips list
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Key Form Tips',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...widget.formTips.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: entry.key == _currentTipIndex
                                ? AppColors.primary
                                : AppColors.grey200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                color: entry.key == _currentTipIndex
                                    ? Colors.white
                                    : AppColors.grey600,
                                fontSize: 12,
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
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Common mistakes
        Card(
          color: AppColors.error.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Common Mistakes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...widget.commonMistakes.map((mistake) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.close, color: AppColors.error, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            mistake,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Grid background painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey200
      ..strokeWidth = 0.5;

    const spacing = 20.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simplified exercise figure painter
class _ExerciseFigurePainter extends CustomPainter {
  final String exerciseType;
  final double pulseValue;

  _ExerciseFigurePainter({
    required this.exerciseType,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Body paint
    final bodyPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Highlight paint for muscle groups
    final highlightPaint = Paint()
      ..color = AppColors.secondary.withOpacity(pulseValue * 0.6)
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(
      Offset(centerX, centerY - 60),
      18,
      bodyPaint,
    );

    // Body
    canvas.drawLine(
      Offset(centerX, centerY - 42),
      Offset(centerX, centerY + 20),
      bodyPaint,
    );

    // Arms (different positions based on exercise)
    if (exerciseType.toLowerCase().contains('bench') ||
        exerciseType.toLowerCase().contains('press')) {
      // Arms extended horizontally
      canvas.drawLine(
        Offset(centerX - 45, centerY - 30),
        Offset(centerX - 5, centerY - 30),
        bodyPaint,
      );
      canvas.drawLine(
        Offset(centerX + 5, centerY - 30),
        Offset(centerX + 45, centerY - 30),
        bodyPaint,
      );

      // Highlight chest
      canvas.drawCircle(
        Offset(centerX, centerY - 20),
        15,
        highlightPaint,
      );
    } else if (exerciseType.toLowerCase().contains('squat')) {
      // Arms forward
      canvas.drawLine(
        Offset(centerX, centerY - 35),
        Offset(centerX - 30, centerY - 15),
        bodyPaint,
      );
      canvas.drawLine(
        Offset(centerX, centerY - 35),
        Offset(centerX + 30, centerY - 15),
        bodyPaint,
      );

      // Highlight legs
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX - 15, centerY + 45),
          width: 20,
          height: 35,
        ),
        highlightPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX + 15, centerY + 45),
          width: 20,
          height: 35,
        ),
        highlightPaint,
      );
    } else {
      // Default arm position
      canvas.drawLine(
        Offset(centerX, centerY - 35),
        Offset(centerX - 30, centerY),
        bodyPaint,
      );
      canvas.drawLine(
        Offset(centerX, centerY - 35),
        Offset(centerX + 30, centerY),
        bodyPaint,
      );
    }

    // Legs
    canvas.drawLine(
      Offset(centerX, centerY + 20),
      Offset(centerX - 20, centerY + 70),
      bodyPaint,
    );
    canvas.drawLine(
      Offset(centerX, centerY + 20),
      Offset(centerX + 20, centerY + 70),
      bodyPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ExerciseFigurePainter oldDelegate) {
    return pulseValue != oldDelegate.pulseValue;
  }
}
