import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// A modern rest timer overlay with animations and haptic feedback.
class RestTimerOverlay extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback onComplete;
  final VoidCallback onSkip;
  final String? nextExercise;

  const RestTimerOverlay({
    super.key,
    required this.totalSeconds,
    required this.onComplete,
    required this.onSkip,
    this.nextExercise,
  });

  @override
  State<RestTimerOverlay> createState() => _RestTimerOverlayState();
}

class _RestTimerOverlayState extends State<RestTimerOverlay>
    with TickerProviderStateMixin {
  late int _secondsRemaining;
  Timer? _timer;
  late AnimationController _pulseController;
  late AnimationController _countdownController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.totalSeconds;

    // Pulse animation for the timer circle
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Scale animation for countdown
    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.2, end: 1.0).animate(
      CurvedAnimation(parent: _countdownController, curve: Curves.elasticOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });

        // Trigger scale animation on each tick
        _countdownController.forward(from: 0);

        // Haptic feedback at certain points
        if (_secondsRemaining <= 5 && _secondsRemaining > 0) {
          HapticFeedback.lightImpact();
        }

        // Strong feedback when timer ends
        if (_secondsRemaining == 0) {
          HapticFeedback.heavyImpact();
          _timer?.cancel();
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.onComplete();
          });
        }
      }
    });
  }

  void _addTime(int seconds) {
    HapticFeedback.selectionClick();
    setState(() {
      _secondsRemaining = (_secondsRemaining + seconds).clamp(0, 999);
    });
  }

  void _skipRest() {
    HapticFeedback.mediumImpact();
    _timer?.cancel();
    widget.onSkip();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return remainingSeconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / widget.totalSeconds;
    final isAlmostDone = _secondsRemaining <= 5;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.95),
            AppColors.primary.withOpacity(0.3),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Column(
                    children: [
                      Text(
                        'REST TIME',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 4,
                            ),
                      ),
                      if (widget.nextExercise != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Next: ${widget.nextExercise}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    onPressed: _skipRest,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Main timer
            AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: isAlmostDone ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isAlmostDone ? Colors.orange : AppColors.primary)
                              .withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 12,
                            ),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isAlmostDone ? Colors.orange : AppColors.primary,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Timer text
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(_secondsRemaining),
                                style: TextStyle(
                                  fontSize: _secondsRemaining < 60 ? 80 : 64,
                                  fontWeight: FontWeight.bold,
                                  color: isAlmostDone ? Colors.orange : Colors.white,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                              if (_secondsRemaining >= 60)
                                Text(
                                  'seconds',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            // Time adjustment buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeButton('-30s', () => _addTime(-30), Icons.remove),
                  _buildTimeButton('-15s', () => _addTime(-15), Icons.remove),
                  _buildTimeButton('+15s', () => _addTime(15), Icons.add),
                  _buildTimeButton('+30s', () => _addTime(30), Icons.add),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // Skip button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _skipRest,
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Skip Rest'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(String label, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A compact timer widget that can be embedded in other screens.
class CompactRestTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback? onComplete;
  final double size;

  const CompactRestTimer({
    super.key,
    required this.seconds,
    this.onComplete,
    this.size = 60,
  });

  @override
  State<CompactRestTimer> createState() => _CompactRestTimerState();
}

class _CompactRestTimerState extends State<CompactRestTimer> {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / widget.seconds;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          Text(
            '$_secondsRemaining',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
