import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Warm-up set
class WarmupSet {
  final int setNumber;
  final double weight;
  final int reps;
  final String purpose;

  const WarmupSet({
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.purpose,
  });
}

/// Generate warm-up sets based on working weight
List<WarmupSet> generateWarmupSets(double workingWeight, {String? unit}) {
  final sets = <WarmupSet>[];

  if (workingWeight <= 0) return sets;

  // Empty bar warm-up
  final barWeight = unit == 'kg' ? 20.0 : 45.0;
  if (workingWeight > barWeight * 1.5) {
    sets.add(WarmupSet(
      setNumber: 1,
      weight: barWeight,
      reps: 10,
      purpose: 'Get blood flowing, practice movement',
    ));
  }

  // Progressive warm-ups
  if (workingWeight > barWeight * 2) {
    sets.add(WarmupSet(
      setNumber: sets.length + 1,
      weight: (workingWeight * 0.4).roundToNearest(unit == 'kg' ? 2.5 : 5),
      reps: 8,
      purpose: 'Build motor pattern',
    ));
  }

  if (workingWeight > barWeight * 1.5) {
    sets.add(WarmupSet(
      setNumber: sets.length + 1,
      weight: (workingWeight * 0.6).roundToNearest(unit == 'kg' ? 2.5 : 5),
      reps: 5,
      purpose: 'Increase intensity',
    ));
  }

  if (workingWeight > barWeight) {
    sets.add(WarmupSet(
      setNumber: sets.length + 1,
      weight: (workingWeight * 0.8).roundToNearest(unit == 'kg' ? 2.5 : 5),
      reps: 3,
      purpose: 'Prime nervous system',
    ));
  }

  // Final prep set close to working weight
  if (workingWeight > barWeight * 1.3) {
    sets.add(WarmupSet(
      setNumber: sets.length + 1,
      weight: (workingWeight * 0.9).roundToNearest(unit == 'kg' ? 2.5 : 5),
      reps: 1,
      purpose: 'Final prep, build confidence',
    ));
  }

  return sets;
}

extension on double {
  double roundToNearest(double value) {
    return (this / value).round() * value;
  }
}

/// Warm-up generator widget
class WarmupGenerator extends StatefulWidget {
  final double? workingWeight;
  final String unit;
  final Function(List<WarmupSet>)? onWarmupSelected;

  const WarmupGenerator({
    super.key,
    this.workingWeight,
    this.unit = 'lbs',
    this.onWarmupSelected,
  });

  @override
  State<WarmupGenerator> createState() => _WarmupGeneratorState();
}

class _WarmupGeneratorState extends State<WarmupGenerator> {
  late TextEditingController _weightController;
  List<WarmupSet> _warmupSets = [];

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.workingWeight?.toStringAsFixed(0) ?? '',
    );
    if (widget.workingWeight != null) {
      _generateWarmup();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _generateWarmup() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _warmupSets = generateWarmupSets(weight, unit: widget.unit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.whatshot, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            Text(
              'Warm-up Generator',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Working weight input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Working Weight',
                  suffixText: widget.unit,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                onChanged: (_) => _generateWarmup(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _generateWarmup,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate'),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Warm-up sets
        if (_warmupSets.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: AppColors.grey500),
                const SizedBox(width: 8),
                Text(
                  'Enter your working weight to generate warm-up sets',
                  style: TextStyle(color: AppColors.grey500),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              // Warm-up card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_warmupSets.length} Warm-up Sets',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '~${_warmupSets.length * 2} min',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Sets
                      ..._warmupSets.map((set) => _WarmupSetRow(
                        set: set,
                        unit: widget.unit,
                        isLast: set == _warmupSets.last,
                      )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Use warm-up button
              if (widget.onWarmupSelected != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      widget.onWarmupSelected!(_warmupSets);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Warm-up to Workout'),
                  ),
                ),
            ],
          ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Tips
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Warm-up Tips',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Rest 30-60 seconds between warm-up sets\n'
                '• Focus on form, not speed\n'
                '• Skip sets if already warm from prior exercises',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Single warm-up set row
class _WarmupSetRow extends StatelessWidget {
  final WarmupSet set;
  final String unit;
  final bool isLast;

  const _WarmupSetRow({
    required this.set,
    required this.unit,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: isLast ? 0 : 8,
      ),
      child: Row(
        children: [
          // Set number
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${set.setNumber}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Weight and reps
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${set.weight.toStringAsFixed(set.weight % 1 == 0 ? 0 : 1)} $unit × ${set.reps} reps',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  set.purpose,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey500,
                      ),
                ),
              ],
            ),
          ),

          // Percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${((set.weight / (double.tryParse(set.weight.toString()) ?? 1)) * 100).round()}%',
              style: const TextStyle(
                color: AppColors.grey600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Warm-up bottom sheet
class WarmupBottomSheet extends StatelessWidget {
  final double? workingWeight;
  final String unit;
  final Function(List<WarmupSet>)? onWarmupSelected;

  const WarmupBottomSheet({
    super.key,
    this.workingWeight,
    this.unit = 'lbs',
    this.onWarmupSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: AppDimensions.spacingMd),
          WarmupGenerator(
            workingWeight: workingWeight,
            unit: unit,
            onWarmupSelected: (sets) {
              onWarmupSelected?.call(sets);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppDimensions.spacingLg),
        ],
      ),
    );
  }
}
