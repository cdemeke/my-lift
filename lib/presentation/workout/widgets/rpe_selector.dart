import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// RPE (Rate of Perceived Exertion) descriptions
const rpeDescriptions = {
  6.0: 'Very light - warmup weight',
  6.5: 'Light warmup',
  7.0: 'Light - 4+ reps in reserve',
  7.5: 'Moderate - 3 reps in reserve',
  8.0: 'Hard - 2 reps in reserve',
  8.5: 'Very hard - 1-2 reps in reserve',
  9.0: 'Near max - 1 rep in reserve',
  9.5: 'Almost failure - maybe 1 more',
  10.0: 'Maximum - true failure',
};

/// Get color for RPE value
Color getRpeColor(double rpe) {
  if (rpe <= 7) return Colors.green;
  if (rpe <= 8) return Colors.yellow[700]!;
  if (rpe <= 9) return Colors.orange;
  return Colors.red;
}

/// RPE selector widget
class RpeSelector extends StatelessWidget {
  final double? value;
  final ValueChanged<double> onChanged;
  final bool compact;

  const RpeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactRpeSelector(value: value, onChanged: onChanged);
    }
    return _FullRpeSelector(value: value, onChanged: onChanged);
  }
}

/// Full RPE selector with slider
class _FullRpeSelector extends StatelessWidget {
  final double? value;
  final ValueChanged<double> onChanged;

  const _FullRpeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentRpe = value ?? 8.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RPE (Rate of Perceived Exertion)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: getRpeColor(currentRpe).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                currentRpe.toString(),
                style: TextStyle(
                  color: getRpeColor(currentRpe),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: getRpeColor(currentRpe),
            thumbColor: getRpeColor(currentRpe),
            overlayColor: getRpeColor(currentRpe).withOpacity(0.2),
            inactiveTrackColor: AppColors.grey200,
          ),
          child: Slider(
            value: currentRpe,
            min: 6,
            max: 10,
            divisions: 8,
            label: currentRpe.toString(),
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onChanged(val);
            },
          ),
        ),
        Text(
          rpeDescriptions[currentRpe] ?? 'Select RPE',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
        ),
      ],
    );
  }
}

/// Compact RPE selector chips
class _CompactRpeSelector extends StatelessWidget {
  final double? value;
  final ValueChanged<double> onChanged;

  const _CompactRpeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final rpeValues = [7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RPE',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (value != null)
              Text(
                rpeDescriptions[value] ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey500,
                    ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: rpeValues.map((rpe) {
            final isSelected = value == rpe;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(rpe);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? getRpeColor(rpe).withOpacity(0.2)
                      : AppColors.grey100,
                  border: Border.all(
                    color: isSelected ? getRpeColor(rpe) : AppColors.grey300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  rpe.toString(),
                  style: TextStyle(
                    color: isSelected ? getRpeColor(rpe) : AppColors.grey600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// RIR (Reps In Reserve) selector - alternative to RPE
class RirSelector extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;

  const RirSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final rirValues = [0, 1, 2, 3, 4];
    final rirLabels = {
      0: 'Failure',
      1: '1 left',
      2: '2 left',
      3: '3 left',
      4: '4+ left',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reps In Reserve (RIR)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rirValues.map((rir) {
            final isSelected = value == rir;
            final color = rir == 0
                ? Colors.red
                : rir <= 1
                    ? Colors.orange
                    : rir <= 2
                        ? Colors.yellow[700]!
                        : Colors.green;

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(rir);
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.2) : AppColors.grey100,
                      border: Border.all(
                        color: isSelected ? color : AppColors.grey300,
                        width: isSelected ? 2 : 1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$rir',
                        style: TextStyle(
                          color: isSelected ? color : AppColors.grey600,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rirLabels[rir]!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? color : AppColors.grey500,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Combined effort selector with toggle between RPE and RIR
class EffortSelector extends StatefulWidget {
  final double? rpe;
  final int? rir;
  final bool useRpe;
  final ValueChanged<double>? onRpeChanged;
  final ValueChanged<int>? onRirChanged;
  final ValueChanged<bool>? onModeChanged;

  const EffortSelector({
    super.key,
    this.rpe,
    this.rir,
    this.useRpe = true,
    this.onRpeChanged,
    this.onRirChanged,
    this.onModeChanged,
  });

  @override
  State<EffortSelector> createState() => _EffortSelectorState();
}

class _EffortSelectorState extends State<EffortSelector> {
  late bool _useRpe;

  @override
  void initState() {
    super.initState();
    _useRpe = widget.useRpe;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle between RPE and RIR
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Use: '),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('RPE')),
                ButtonSegment(value: false, label: Text('RIR')),
              ],
              selected: {_useRpe},
              onSelectionChanged: (selection) {
                setState(() => _useRpe = selection.first);
                widget.onModeChanged?.call(selection.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (_useRpe)
          RpeSelector(
            value: widget.rpe,
            onChanged: (val) => widget.onRpeChanged?.call(val),
            compact: true,
          )
        else
          RirSelector(
            value: widget.rir,
            onChanged: (val) => widget.onRirChanged?.call(val),
          ),
      ],
    );
  }
}

/// Quick RPE button for inline logging
class QuickRpeButton extends StatelessWidget {
  final double? value;
  final VoidCallback onTap;

  const QuickRpeButton({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: value != null
              ? getRpeColor(value!).withOpacity(0.2)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: value != null ? getRpeColor(value!) : AppColors.grey300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.speed,
              size: 14,
              color: value != null ? getRpeColor(value!) : AppColors.grey500,
            ),
            const SizedBox(width: 4),
            Text(
              value != null ? 'RPE ${value!.toStringAsFixed(1)}' : 'RPE',
              style: TextStyle(
                fontSize: 12,
                color: value != null ? getRpeColor(value!) : AppColors.grey500,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
