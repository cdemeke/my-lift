import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// 1RM calculation formulas
enum OneRmFormula {
  brzycki('Brzycki', 'Most accurate for 1-10 reps'),
  epley('Epley', 'Traditional formula'),
  lander('Lander', 'Good for moderate reps'),
  lombardi('Lombardi', 'Simple estimation'),
  oconner('O\'Conner', 'Conservative estimate');

  final String name;
  final String description;

  const OneRmFormula(this.name, this.description);
}

/// Provider for 1RM calculator state
final oneRmCalculatorProvider = StateNotifierProvider<OneRmCalculatorNotifier, OneRmCalculatorState>((ref) {
  return OneRmCalculatorNotifier();
});

/// 1RM calculator state
class OneRmCalculatorState {
  final double weight;
  final int reps;
  final String unit;
  final OneRmFormula formula;

  const OneRmCalculatorState({
    this.weight = 0,
    this.reps = 1,
    this.unit = 'lbs',
    this.formula = OneRmFormula.brzycki,
  });

  OneRmCalculatorState copyWith({
    double? weight,
    int? reps,
    String? unit,
    OneRmFormula? formula,
  }) {
    return OneRmCalculatorState(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      unit: unit ?? this.unit,
      formula: formula ?? this.formula,
    );
  }

  /// Calculate 1RM using the selected formula
  double calculateOneRm() {
    if (weight <= 0 || reps <= 0) return 0;
    if (reps == 1) return weight;

    switch (formula) {
      case OneRmFormula.brzycki:
        return weight * (36 / (37 - reps));
      case OneRmFormula.epley:
        return weight * (1 + reps / 30);
      case OneRmFormula.lander:
        return (100 * weight) / (101.3 - 2.67123 * reps);
      case OneRmFormula.lombardi:
        return weight * math.pow(reps, 0.10);
      case OneRmFormula.oconner:
        return weight * (1 + reps / 40);
    }
  }

  /// Calculate average 1RM across all formulas
  double calculateAverageOneRm() {
    if (weight <= 0 || reps <= 0) return 0;
    if (reps == 1) return weight;

    final values = OneRmFormula.values.map((f) {
      final state = OneRmCalculatorState(weight: weight, reps: reps, formula: f);
      return state.calculateOneRm();
    }).toList();

    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calculate weight for specific rep range
  double calculateWeightForReps(int targetReps) {
    final oneRm = calculateOneRm();
    if (oneRm <= 0 || targetReps <= 0) return 0;
    if (targetReps == 1) return oneRm;

    // Reverse Brzycki formula
    return oneRm * (37 - targetReps) / 36;
  }
}

/// 1RM calculator notifier
class OneRmCalculatorNotifier extends StateNotifier<OneRmCalculatorState> {
  OneRmCalculatorNotifier() : super(const OneRmCalculatorState());

  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void setReps(int reps) {
    state = state.copyWith(reps: reps.clamp(1, 30));
  }

  void setUnit(String unit) {
    state = state.copyWith(unit: unit);
  }

  void setFormula(OneRmFormula formula) {
    state = state.copyWith(formula: formula);
  }
}

/// 1RM Calculator screen
class OneRmCalculatorScreen extends ConsumerStatefulWidget {
  const OneRmCalculatorScreen({super.key});

  @override
  ConsumerState<OneRmCalculatorScreen> createState() => _OneRmCalculatorScreenState();
}

class _OneRmCalculatorScreenState extends ConsumerState<OneRmCalculatorScreen> {
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(oneRmCalculatorProvider);
    final oneRm = state.calculateOneRm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('1RM Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoSheet(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // Input card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Your Lift',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  // Weight input
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Weight',
                            suffixText: state.unit,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            ),
                          ),
                          onChanged: (value) {
                            final weight = double.tryParse(value) ?? 0;
                            ref.read(oneRmCalculatorProvider.notifier).setWeight(weight);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Unit toggle
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'lbs', label: Text('lbs')),
                          ButtonSegment(value: 'kg', label: Text('kg')),
                        ],
                        selected: {state.unit},
                        onSelectionChanged: (selection) {
                          ref.read(oneRmCalculatorProvider.notifier).setUnit(selection.first);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingMd),

                  // Reps selector
                  Text('Reps Completed', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: state.reps > 1
                            ? () {
                                ref.read(oneRmCalculatorProvider.notifier).setReps(state.reps - 1);
                                HapticFeedback.selectionClick();
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Expanded(
                        child: Slider(
                          value: state.reps.toDouble(),
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: '${state.reps} reps',
                          onChanged: (value) {
                            ref.read(oneRmCalculatorProvider.notifier).setReps(value.round());
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: state.reps < 20
                            ? () {
                                ref.read(oneRmCalculatorProvider.notifier).setReps(state.reps + 1);
                                HapticFeedback.selectionClick();
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${state.reps} reps',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Result card
          if (oneRm > 0)
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLg),
                child: Column(
                  children: [
                    Text(
                      'Estimated 1RM',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          oneRm.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            state.unit,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Using ${state.formula.name} formula',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Rep max table
          if (oneRm > 0) ...[
            Text(
              'Rep Max Table',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Column(
                  children: [
                    _RepMaxRow(reps: 1, weight: oneRm, unit: state.unit, isHighlighted: state.reps == 1),
                    const Divider(),
                    _RepMaxRow(reps: 3, weight: state.calculateWeightForReps(3), unit: state.unit, isHighlighted: state.reps == 3),
                    const Divider(),
                    _RepMaxRow(reps: 5, weight: state.calculateWeightForReps(5), unit: state.unit, isHighlighted: state.reps == 5),
                    const Divider(),
                    _RepMaxRow(reps: 8, weight: state.calculateWeightForReps(8), unit: state.unit, isHighlighted: state.reps == 8),
                    const Divider(),
                    _RepMaxRow(reps: 10, weight: state.calculateWeightForReps(10), unit: state.unit, isHighlighted: state.reps == 10),
                    const Divider(),
                    _RepMaxRow(reps: 12, weight: state.calculateWeightForReps(12), unit: state.unit, isHighlighted: state.reps == 12),
                    const Divider(),
                    _RepMaxRow(reps: 15, weight: state.calculateWeightForReps(15), unit: state.unit, isHighlighted: state.reps == 15),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: AppDimensions.spacingLg),

          // Formula selector
          Text(
            'Calculation Formula',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          ...OneRmFormula.values.map((formula) {
            final isSelected = state.formula == formula;
            return Card(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
              child: ListTile(
                leading: Radio<OneRmFormula>(
                  value: formula,
                  groupValue: state.formula,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(oneRmCalculatorProvider.notifier).setFormula(value);
                      HapticFeedback.selectionClick();
                    }
                  },
                ),
                title: Text(
                  formula.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                subtitle: Text(formula.description),
                onTap: () {
                  ref.read(oneRmCalculatorProvider.notifier).setFormula(formula);
                  HapticFeedback.selectionClick();
                },
              ),
            );
          }),

          const SizedBox(height: AppDimensions.spacingXl),
        ],
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'What is 1RM?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              '1RM (One-Rep Max) is the maximum weight you can lift for a single repetition with proper form. It\'s used to:',
            ),
            const SizedBox(height: 8),
            const Text('• Program training percentages'),
            const Text('• Track strength progress over time'),
            const Text('• Compare strength across different lifts'),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              'This calculator estimates your 1RM based on a submaximal lift. For accuracy, use sets of 1-10 reps - higher rep counts become less reliable.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
          ],
        ),
      ),
    );
  }
}

/// Rep max table row
class _RepMaxRow extends StatelessWidget {
  final int reps;
  final double weight;
  final String unit;
  final bool isHighlighted;

  const _RepMaxRow({
    required this.reps,
    required this.weight,
    required this.unit,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isHighlighted ? AppColors.primary : AppColors.grey200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$reps',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.white : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$reps rep${reps > 1 ? 's' : ''} max',
                style: TextStyle(
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  color: isHighlighted ? AppColors.primary : null,
                ),
              ),
            ],
          ),
          Text(
            '${weight.toStringAsFixed(1)} $unit',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? AppColors.primary : null,
                ),
          ),
        ],
      ),
    );
  }
}
