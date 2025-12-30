import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Rep tempo model using standard notation: Eccentric-Pause-Concentric-Pause
/// Example: 3-1-2-0 means 3s lowering, 1s pause at bottom, 2s lifting, 0s pause at top
class RepTempo {
  final int eccentric; // Lowering/negative phase (seconds)
  final int pauseBottom; // Pause at stretched position (seconds)
  final int concentric; // Lifting/positive phase (seconds)
  final int pauseTop; // Pause at contracted position (seconds)

  const RepTempo({
    this.eccentric = 2,
    this.pauseBottom = 0,
    this.concentric = 1,
    this.pauseTop = 0,
  });

  /// Standard tempo notation string (e.g., "3-1-2-0")
  String get notation => '$eccentric-$pauseBottom-$concentric-$pauseTop';

  /// Total time for one rep in seconds
  int get totalSeconds => eccentric + pauseBottom + concentric + pauseTop;

  /// Common preset tempos
  static const RepTempo controlled = RepTempo(
    eccentric: 3,
    pauseBottom: 1,
    concentric: 2,
    pauseTop: 0,
  );

  static const RepTempo explosive = RepTempo(
    eccentric: 2,
    pauseBottom: 0,
    concentric: 1,
    pauseTop: 0,
  );

  static const RepTempo slowEccentric = RepTempo(
    eccentric: 4,
    pauseBottom: 1,
    concentric: 1,
    pauseTop: 0,
  );

  static const RepTempo paused = RepTempo(
    eccentric: 2,
    pauseBottom: 2,
    concentric: 1,
    pauseTop: 1,
  );

  static const RepTempo timeUnderTension = RepTempo(
    eccentric: 4,
    pauseBottom: 2,
    concentric: 4,
    pauseTop: 2,
  );

  static const RepTempo standard = RepTempo(
    eccentric: 2,
    pauseBottom: 0,
    concentric: 1,
    pauseTop: 0,
  );

  RepTempo copyWith({
    int? eccentric,
    int? pauseBottom,
    int? concentric,
    int? pauseTop,
  }) {
    return RepTempo(
      eccentric: eccentric ?? this.eccentric,
      pauseBottom: pauseBottom ?? this.pauseBottom,
      concentric: concentric ?? this.concentric,
      pauseTop: pauseTop ?? this.pauseTop,
    );
  }

  Map<String, dynamic> toJson() => {
        'eccentric': eccentric,
        'pauseBottom': pauseBottom,
        'concentric': concentric,
        'pauseTop': pauseTop,
      };

  factory RepTempo.fromJson(Map<String, dynamic> json) {
    return RepTempo(
      eccentric: json['eccentric'] ?? 2,
      pauseBottom: json['pauseBottom'] ?? 0,
      concentric: json['concentric'] ?? 1,
      pauseTop: json['pauseTop'] ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepTempo &&
          eccentric == other.eccentric &&
          pauseBottom == other.pauseBottom &&
          concentric == other.concentric &&
          pauseTop == other.pauseTop;

  @override
  int get hashCode =>
      eccentric.hashCode ^
      pauseBottom.hashCode ^
      concentric.hashCode ^
      pauseTop.hashCode;
}

/// Compact tempo display chip
class TempoChip extends StatelessWidget {
  final RepTempo tempo;
  final VoidCallback? onTap;
  final bool showLabel;

  const TempoChip({
    super.key,
    required this.tempo,
    this.onTap,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.speed,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              tempo.notation,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.edit,
                size: 12,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full tempo selector widget with visual representation
class TempoSelector extends StatefulWidget {
  final RepTempo initialTempo;
  final Function(RepTempo) onTempoChanged;

  const TempoSelector({
    super.key,
    required this.initialTempo,
    required this.onTempoChanged,
  });

  @override
  State<TempoSelector> createState() => _TempoSelectorState();
}

class _TempoSelectorState extends State<TempoSelector> {
  late RepTempo _tempo;

  @override
  void initState() {
    super.initState();
    _tempo = widget.initialTempo;
  }

  void _updateTempo(RepTempo newTempo) {
    setState(() => _tempo = newTempo);
    widget.onTempoChanged(newTempo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with total time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rep Tempo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                '${_tempo.totalSeconds}s / rep',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Visual tempo display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TempoPhase(
                label: 'Down',
                value: _tempo.eccentric,
                color: Colors.blue,
                icon: Icons.arrow_downward,
              ),
              _TempoArrow(),
              _TempoPhase(
                label: 'Hold',
                value: _tempo.pauseBottom,
                color: Colors.orange,
                icon: Icons.pause,
              ),
              _TempoArrow(),
              _TempoPhase(
                label: 'Up',
                value: _tempo.concentric,
                color: Colors.green,
                icon: Icons.arrow_upward,
              ),
              _TempoArrow(),
              _TempoPhase(
                label: 'Hold',
                value: _tempo.pauseTop,
                color: Colors.purple,
                icon: Icons.pause,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tempo controls
        Row(
          children: [
            Expanded(
              child: _TempoControl(
                label: 'Eccentric',
                sublabel: 'Lowering',
                value: _tempo.eccentric,
                color: Colors.blue,
                onChanged: (v) => _updateTempo(_tempo.copyWith(eccentric: v)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TempoControl(
                label: 'Pause',
                sublabel: 'Bottom',
                value: _tempo.pauseBottom,
                color: Colors.orange,
                onChanged: (v) => _updateTempo(_tempo.copyWith(pauseBottom: v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _TempoControl(
                label: 'Concentric',
                sublabel: 'Lifting',
                value: _tempo.concentric,
                color: Colors.green,
                onChanged: (v) => _updateTempo(_tempo.copyWith(concentric: v)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TempoControl(
                label: 'Pause',
                sublabel: 'Top',
                value: _tempo.pauseTop,
                color: Colors.purple,
                onChanged: (v) => _updateTempo(_tempo.copyWith(pauseTop: v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Presets
        Text(
          'Presets',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TempoPresetChip(
                label: 'Standard',
                tempo: RepTempo.standard,
                isSelected: _tempo == RepTempo.standard,
                onTap: () => _updateTempo(RepTempo.standard),
              ),
              _TempoPresetChip(
                label: 'Controlled',
                tempo: RepTempo.controlled,
                isSelected: _tempo == RepTempo.controlled,
                onTap: () => _updateTempo(RepTempo.controlled),
              ),
              _TempoPresetChip(
                label: 'Explosive',
                tempo: RepTempo.explosive,
                isSelected: _tempo == RepTempo.explosive,
                onTap: () => _updateTempo(RepTempo.explosive),
              ),
              _TempoPresetChip(
                label: 'Slow Eccentric',
                tempo: RepTempo.slowEccentric,
                isSelected: _tempo == RepTempo.slowEccentric,
                onTap: () => _updateTempo(RepTempo.slowEccentric),
              ),
              _TempoPresetChip(
                label: 'Paused',
                tempo: RepTempo.paused,
                isSelected: _tempo == RepTempo.paused,
                onTap: () => _updateTempo(RepTempo.paused),
              ),
              _TempoPresetChip(
                label: 'TUT',
                tempo: RepTempo.timeUnderTension,
                isSelected: _tempo == RepTempo.timeUnderTension,
                onTap: () => _updateTempo(RepTempo.timeUnderTension),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TempoPhase extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _TempoPhase({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${value}s',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TempoArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right,
      color: AppColors.grey400,
      size: 20,
    );
  }
}

class _TempoControl extends StatelessWidget {
  final String label;
  final String sublabel;
  final int value;
  final Color color;
  final Function(int) onChanged;

  const _TempoControl({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${value}s',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(Icons.remove, () {
                if (value > 0) onChanged(value - 1);
              }),
              const SizedBox(width: 12),
              ...List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onChanged(index);
                  },
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= value ? color : AppColors.grey300,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              _buildButton(Icons.add, () {
                if (value < 10) onChanged(value + 1);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.grey700),
      ),
    );
  }
}

class _TempoPresetChip extends StatelessWidget {
  final String label;
  final RepTempo tempo;
  final bool isSelected;
  final VoidCallback onTap;

  const _TempoPresetChip({
    required this.label,
    required this.tempo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey300,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.grey700,
                ),
              ),
              Text(
                tempo.notation,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white70 : AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for tempo selection
class TempoSelectorSheet extends StatefulWidget {
  final RepTempo initialTempo;
  final Function(RepTempo) onTempoSelected;

  const TempoSelectorSheet({
    super.key,
    required this.initialTempo,
    required this.onTempoSelected,
  });

  static Future<RepTempo?> show(BuildContext context, RepTempo initialTempo) {
    return showModalBottomSheet<RepTempo>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusLg),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: TempoSelectorSheet(
              initialTempo: initialTempo,
              onTempoSelected: (tempo) {
                Navigator.pop(context, tempo);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<TempoSelectorSheet> createState() => _TempoSelectorSheetState();
}

class _TempoSelectorSheetState extends State<TempoSelectorSheet> {
  late RepTempo _tempo;

  @override
  void initState() {
    super.initState();
    _tempo = widget.initialTempo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.speed, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rep Tempo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Control the speed of each rep phase',
                  style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Tempo explanation
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tempo notation: Eccentric-Pause-Concentric-Pause\n'
                  'Example: 3-1-2-0 = 3s down, 1s hold, 2s up, 0s hold',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tempo selector
        TempoSelector(
          initialTempo: _tempo,
          onTempoChanged: (tempo) {
            setState(() => _tempo = tempo);
          },
        ),

        const SizedBox(height: 24),

        // Apply button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.onTempoSelected(_tempo);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Apply Tempo (${_tempo.notation})'),
          ),
        ),
      ],
    );
  }
}
