import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Rest timer settings with auto-start and customizable durations per exercise type.
class RestTimerSettings {
  final bool autoStart;
  final int defaultRestSeconds;
  final int compoundRestSeconds;
  final int isolationRestSeconds;
  final int absRestSeconds;
  final bool vibrationEnabled;
  final bool soundEnabled;

  const RestTimerSettings({
    this.autoStart = true,
    this.defaultRestSeconds = 90,
    this.compoundRestSeconds = 120,
    this.isolationRestSeconds = 60,
    this.absRestSeconds = 45,
    this.vibrationEnabled = true,
    this.soundEnabled = true,
  });

  RestTimerSettings copyWith({
    bool? autoStart,
    int? defaultRestSeconds,
    int? compoundRestSeconds,
    int? isolationRestSeconds,
    int? absRestSeconds,
    bool? vibrationEnabled,
    bool? soundEnabled,
  }) {
    return RestTimerSettings(
      autoStart: autoStart ?? this.autoStart,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      compoundRestSeconds: compoundRestSeconds ?? this.compoundRestSeconds,
      isolationRestSeconds: isolationRestSeconds ?? this.isolationRestSeconds,
      absRestSeconds: absRestSeconds ?? this.absRestSeconds,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  /// Get rest time based on exercise type
  int getRestTimeForExercise(ExerciseType type) {
    switch (type) {
      case ExerciseType.compound:
        return compoundRestSeconds;
      case ExerciseType.isolation:
        return isolationRestSeconds;
      case ExerciseType.abs:
        return absRestSeconds;
      case ExerciseType.cardio:
        return 30;
      default:
        return defaultRestSeconds;
    }
  }

  Map<String, dynamic> toJson() => {
        'autoStart': autoStart,
        'defaultRestSeconds': defaultRestSeconds,
        'compoundRestSeconds': compoundRestSeconds,
        'isolationRestSeconds': isolationRestSeconds,
        'absRestSeconds': absRestSeconds,
        'vibrationEnabled': vibrationEnabled,
        'soundEnabled': soundEnabled,
      };

  factory RestTimerSettings.fromJson(Map<String, dynamic> json) {
    return RestTimerSettings(
      autoStart: json['autoStart'] ?? true,
      defaultRestSeconds: json['defaultRestSeconds'] ?? 90,
      compoundRestSeconds: json['compoundRestSeconds'] ?? 120,
      isolationRestSeconds: json['isolationRestSeconds'] ?? 60,
      absRestSeconds: json['absRestSeconds'] ?? 45,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
    );
  }
}

enum ExerciseType {
  compound,
  isolation,
  abs,
  cardio,
  other,
}

/// Service to persist rest timer settings
class RestTimerSettingsService {
  static const _key = 'rest_timer_settings';

  static Future<RestTimerSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json != null) {
      try {
        final map = Map<String, dynamic>.from(
          (json as dynamic) is String ? {} : {},
        );
        return RestTimerSettings.fromJson(map);
      } catch (_) {}
    }
    return const RestTimerSettings();
  }

  static Future<void> save(RestTimerSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, settings.toJson().toString());
  }
}

/// Widget to configure rest timer settings
class RestTimerSettingsSheet extends StatefulWidget {
  final RestTimerSettings initialSettings;
  final Function(RestTimerSettings) onSettingsChanged;

  const RestTimerSettingsSheet({
    super.key,
    required this.initialSettings,
    required this.onSettingsChanged,
  });

  @override
  State<RestTimerSettingsSheet> createState() => _RestTimerSettingsSheetState();
}

class _RestTimerSettingsSheetState extends State<RestTimerSettingsSheet> {
  late RestTimerSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

  void _updateSettings(RestTimerSettings newSettings) {
    setState(() => _settings = newSettings);
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.timer, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'Rest Timer Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Auto-start toggle
          SwitchListTile(
            title: const Text('Auto-start Timer'),
            subtitle: const Text('Start rest timer automatically after logging a set'),
            value: _settings.autoStart,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              _updateSettings(_settings.copyWith(autoStart: value));
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          const Divider(height: 32),

          // Rest times by exercise type
          Text(
            'Rest Duration by Exercise Type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),

          _buildRestTimeSlider(
            label: 'Compound Exercises',
            subtitle: 'Squat, Deadlift, Bench Press',
            icon: Icons.fitness_center,
            value: _settings.compoundRestSeconds,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(compoundRestSeconds: value));
            },
          ),

          _buildRestTimeSlider(
            label: 'Isolation Exercises',
            subtitle: 'Bicep Curls, Tricep Extensions',
            icon: Icons.accessibility_new,
            value: _settings.isolationRestSeconds,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(isolationRestSeconds: value));
            },
          ),

          _buildRestTimeSlider(
            label: 'Abs & Core',
            subtitle: 'Planks, Crunches, Leg Raises',
            icon: Icons.sports_martial_arts,
            value: _settings.absRestSeconds,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(absRestSeconds: value));
            },
          ),

          const Divider(height: 32),

          // Notification settings
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate when timer ends'),
            value: _settings.vibrationEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              _updateSettings(_settings.copyWith(vibrationEnabled: value));
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound when timer ends'),
            value: _settings.soundEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              _updateSettings(_settings.copyWith(soundEnabled: value));
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 16),

          // Preset buttons
          Text(
            'Quick Presets',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _PresetButton(
                  label: 'Strength',
                  description: '3-5 min rest',
                  onTap: () {
                    _updateSettings(_settings.copyWith(
                      compoundRestSeconds: 180,
                      isolationRestSeconds: 120,
                      absRestSeconds: 60,
                    ));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PresetButton(
                  label: 'Hypertrophy',
                  description: '60-90s rest',
                  onTap: () {
                    _updateSettings(_settings.copyWith(
                      compoundRestSeconds: 90,
                      isolationRestSeconds: 60,
                      absRestSeconds: 45,
                    ));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PresetButton(
                  label: 'Endurance',
                  description: '30-45s rest',
                  onTap: () {
                    _updateSettings(_settings.copyWith(
                      compoundRestSeconds: 45,
                      isolationRestSeconds: 30,
                      absRestSeconds: 20,
                    ));
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRestTimeSlider({
    required String label,
    required String subtitle,
    required IconData icon,
    required int value,
    required Function(int) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.grey600),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  _formatTime(value),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 15,
            max: 300,
            divisions: 57,
            activeColor: AppColors.primary,
            onChanged: (newValue) {
              HapticFeedback.selectionClick();
              onChanged(newValue.round());
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    }
    return '${secs}s';
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onTap;

  const _PresetButton({
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact auto-start toggle for inline use
class AutoStartToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const AutoStartToggle({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!enabled);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary.withOpacity(0.1) : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: enabled ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              enabled ? Icons.timer : Icons.timer_off_outlined,
              size: 16,
              color: enabled ? AppColors.primary : AppColors.grey500,
            ),
            const SizedBox(width: 6),
            Text(
              'Auto Rest',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: enabled ? AppColors.primary : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
