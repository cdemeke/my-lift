import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Types of sets
enum SetType {
  normal('Normal', 'Standard set with rest between'),
  warmup('Warm-up', 'Light weight preparation set'),
  dropSet('Drop Set', 'Reduce weight, continue reps'),
  superSet('Superset', 'Paired with another exercise'),
  giantSet('Giant Set', 'Multiple exercises back-to-back'),
  restPause('Rest-Pause', 'Short rest mid-set'),
  cluster('Cluster', 'Brief pauses during set'),
  amrap('AMRAP', 'As many reps as possible');

  final String label;
  final String description;

  const SetType(this.label, this.description);
}

/// Get color for set type
Color getSetTypeColor(SetType type) {
  switch (type) {
    case SetType.normal:
      return AppColors.grey600;
    case SetType.warmup:
      return Colors.blue;
    case SetType.dropSet:
      return Colors.orange;
    case SetType.superSet:
      return Colors.purple;
    case SetType.giantSet:
      return Colors.pink;
    case SetType.restPause:
      return Colors.teal;
    case SetType.cluster:
      return Colors.indigo;
    case SetType.amrap:
      return Colors.red;
  }
}

/// Get icon for set type
IconData getSetTypeIcon(SetType type) {
  switch (type) {
    case SetType.normal:
      return Icons.fitness_center;
    case SetType.warmup:
      return Icons.whatshot;
    case SetType.dropSet:
      return Icons.trending_down;
    case SetType.superSet:
      return Icons.link;
    case SetType.giantSet:
      return Icons.all_inclusive;
    case SetType.restPause:
      return Icons.pause_circle;
    case SetType.cluster:
      return Icons.grain;
    case SetType.amrap:
      return Icons.flash_on;
  }
}

/// Set type selector widget
class SetTypeSelector extends StatelessWidget {
  final SetType value;
  final ValueChanged<SetType> onChanged;
  final bool expanded;

  const SetTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return _ExpandedSetTypeSelector(value: value, onChanged: onChanged);
    }
    return _CompactSetTypeSelector(value: value, onChanged: onChanged);
  }
}

/// Compact dropdown selector
class _CompactSetTypeSelector extends StatelessWidget {
  final SetType value;
  final ValueChanged<SetType> onChanged;

  const _CompactSetTypeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SetType>(
      initialValue: value,
      onSelected: (type) {
        HapticFeedback.selectionClick();
        onChanged(type);
      },
      itemBuilder: (context) => SetType.values.map((type) {
        return PopupMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(
                getSetTypeIcon(type),
                color: getSetTypeColor(type),
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.label),
                  Text(
                    type.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: getSetTypeColor(value).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: getSetTypeColor(value)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              getSetTypeIcon(value),
              size: 16,
              color: getSetTypeColor(value),
            ),
            const SizedBox(width: 4),
            Text(
              value.label,
              style: TextStyle(
                color: getSetTypeColor(value),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: getSetTypeColor(value),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expanded grid selector
class _ExpandedSetTypeSelector extends StatelessWidget {
  final SetType value;
  final ValueChanged<SetType> onChanged;

  const _ExpandedSetTypeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: SetType.values.map((type) {
        final isSelected = value == type;
        final color = getSetTypeColor(type);

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(type);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : AppColors.grey100,
              border: Border.all(
                color: isSelected ? color : AppColors.grey300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  getSetTypeIcon(type),
                  size: 18,
                  color: isSelected ? color : AppColors.grey500,
                ),
                const SizedBox(width: 8),
                Text(
                  type.label,
                  style: TextStyle(
                    color: isSelected ? color : AppColors.grey600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Set type badge for display
class SetTypeBadge extends StatelessWidget {
  final SetType type;
  final bool mini;

  const SetTypeBadge({
    super.key,
    required this.type,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    if (type == SetType.normal) {
      return const SizedBox.shrink(); // Don't show badge for normal sets
    }

    final color = getSetTypeColor(type);

    if (mini) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          getSetTypeIcon(type),
          size: 12,
          color: color,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getSetTypeIcon(type),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Superset group indicator
class SupersetGroupIndicator extends StatelessWidget {
  final int groupNumber;
  final bool isFirst;
  final bool isLast;

  const SupersetGroupIndicator({
    super.key,
    required this.groupNumber,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = [
      Colors.purple,
      Colors.blue,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ][groupNumber % 5];

    return Row(
      children: [
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? const Radius.circular(4) : Radius.zero,
              topRight: isFirst ? const Radius.circular(4) : Radius.zero,
              bottomLeft: isLast ? const Radius.circular(4) : Radius.zero,
              bottomRight: isLast ? const Radius.circular(4) : Radius.zero,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (isFirst)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Superset ${groupNumber + 1}',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

/// Drop set configuration widget
class DropSetConfig extends StatelessWidget {
  final int drops;
  final List<int> percentages;
  final ValueChanged<int> onDropsChanged;
  final ValueChanged<List<int>> onPercentagesChanged;

  const DropSetConfig({
    super.key,
    required this.drops,
    required this.percentages,
    required this.onDropsChanged,
    required this.onPercentagesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_down, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Drop Set Configuration',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                const Text('Number of drops:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: drops > 1
                      ? () => onDropsChanged(drops - 1)
                      : null,
                ),
                Text(
                  '$drops',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: drops < 4
                      ? () => onDropsChanged(drops + 1)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Weight reduction per drop:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(drops, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < drops - 1 ? 8 : 0),
                    child: Column(
                      children: [
                        Text(
                          'Drop ${index + 1}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${percentages.length > index ? percentages[index] : 20}%',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              'Typical: 20-25% weight reduction per drop',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
