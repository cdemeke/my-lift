import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Provider for plate calculator settings
final plateCalculatorProvider = StateNotifierProvider<PlateCalculatorNotifier, PlateCalculatorState>((ref) {
  return PlateCalculatorNotifier();
});

/// Plate calculator state
class PlateCalculatorState {
  final double targetWeight;
  final double barWeight;
  final String unit; // 'lbs' or 'kg'
  final Map<double, int> availablePlates; // plate weight -> count per side

  const PlateCalculatorState({
    this.targetWeight = 135,
    this.barWeight = 45,
    this.unit = 'lbs',
    this.availablePlates = const {
      45: 6,
      35: 4,
      25: 4,
      10: 4,
      5: 4,
      2.5: 4,
    },
  });

  PlateCalculatorState copyWith({
    double? targetWeight,
    double? barWeight,
    String? unit,
    Map<double, int>? availablePlates,
  }) {
    return PlateCalculatorState(
      targetWeight: targetWeight ?? this.targetWeight,
      barWeight: barWeight ?? this.barWeight,
      unit: unit ?? this.unit,
      availablePlates: availablePlates ?? this.availablePlates,
    );
  }

  /// Calculate plates needed per side
  Map<double, int> calculatePlatesNeeded() {
    final weightPerSide = (targetWeight - barWeight) / 2;
    if (weightPerSide <= 0) return {};

    final result = <double, int>{};
    var remaining = weightPerSide;

    // Sort plates from heaviest to lightest
    final sortedPlates = availablePlates.keys.toList()..sort((a, b) => b.compareTo(a));

    for (final plate in sortedPlates) {
      final maxAvailable = availablePlates[plate] ?? 0;
      if (maxAvailable > 0 && remaining >= plate) {
        final count = (remaining / plate).floor().clamp(0, maxAvailable);
        if (count > 0) {
          result[plate] = count;
          remaining -= plate * count;
        }
      }
    }

    return result;
  }

  /// Get actual weight achieved
  double get achievedWeight {
    final platesNeeded = calculatePlatesNeeded();
    var plateWeight = 0.0;
    platesNeeded.forEach((plate, count) {
      plateWeight += plate * count * 2; // Both sides
    });
    return barWeight + plateWeight;
  }
}

/// Plate calculator notifier
class PlateCalculatorNotifier extends StateNotifier<PlateCalculatorState> {
  PlateCalculatorNotifier() : super(const PlateCalculatorState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final unit = prefs.getString('plate_unit') ?? 'lbs';
    final barWeight = prefs.getDouble('bar_weight') ?? (unit == 'lbs' ? 45 : 20);

    state = state.copyWith(
      unit: unit,
      barWeight: barWeight,
      availablePlates: _getDefaultPlates(unit),
    );
  }

  Map<double, int> _getDefaultPlates(String unit) {
    if (unit == 'kg') {
      return {
        25: 6,
        20: 4,
        15: 4,
        10: 4,
        5: 4,
        2.5: 4,
        1.25: 4,
      };
    }
    return {
      45: 6,
      35: 4,
      25: 4,
      10: 4,
      5: 4,
      2.5: 4,
    };
  }

  void setTargetWeight(double weight) {
    state = state.copyWith(targetWeight: weight);
  }

  void setBarWeight(double weight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bar_weight', weight);
    state = state.copyWith(barWeight: weight);
  }

  void setUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('plate_unit', unit);

    final defaultBar = unit == 'lbs' ? 45.0 : 20.0;
    await prefs.setDouble('bar_weight', defaultBar);

    state = state.copyWith(
      unit: unit,
      barWeight: defaultBar,
      availablePlates: _getDefaultPlates(unit),
      targetWeight: unit == 'lbs' ? 135 : 60,
    );
  }

  void updatePlateCount(double plate, int count) {
    final newPlates = Map<double, int>.from(state.availablePlates);
    newPlates[plate] = count;
    state = state.copyWith(availablePlates: newPlates);
  }
}

/// Plate calculator screen
class PlateCalculatorScreen extends ConsumerStatefulWidget {
  const PlateCalculatorScreen({super.key});

  @override
  ConsumerState<PlateCalculatorScreen> createState() => _PlateCalculatorScreenState();
}

class _PlateCalculatorScreenState extends ConsumerState<PlateCalculatorScreen> {
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.text = '135';
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(plateCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plate Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsSheet(context, ref, state),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // Target weight input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Weight',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            suffixText: state.unit,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            ),
                          ),
                          onChanged: (value) {
                            final weight = double.tryParse(value);
                            if (weight != null) {
                              ref.read(plateCalculatorProvider.notifier).setTargetWeight(weight);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Quick add buttons
                      _QuickAddButton(
                        label: '+${state.unit == 'lbs' ? '5' : '2.5'}',
                        onTap: () {
                          final add = state.unit == 'lbs' ? 5.0 : 2.5;
                          final newWeight = state.targetWeight + add;
                          _weightController.text = newWeight.toStringAsFixed(state.unit == 'lbs' ? 0 : 1);
                          ref.read(plateCalculatorProvider.notifier).setTargetWeight(newWeight);
                        },
                      ),
                      const SizedBox(width: 8),
                      _QuickAddButton(
                        label: '-${state.unit == 'lbs' ? '5' : '2.5'}',
                        onTap: () {
                          final sub = state.unit == 'lbs' ? 5.0 : 2.5;
                          final newWeight = (state.targetWeight - sub).clamp(state.barWeight, 999.0);
                          _weightController.text = newWeight.toStringAsFixed(state.unit == 'lbs' ? 0 : 1);
                          ref.read(plateCalculatorProvider.notifier).setTargetWeight(newWeight);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bar: ${state.barWeight.toStringAsFixed(state.unit == 'lbs' ? 0 : 1)} ${state.unit}',
                    style: TextStyle(color: AppColors.grey500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Barbell visualization
          _BarbellVisualization(state: state),

          const SizedBox(height: AppDimensions.spacingLg),

          // Plates needed
          _PlatesNeededCard(state: state),

          const SizedBox(height: AppDimensions.spacingMd),

          // Common weights
          Text(
            'Common Weights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getCommonWeights(state.unit).map((weight) {
              return ActionChip(
                label: Text('$weight ${state.unit}'),
                onPressed: () {
                  _weightController.text = weight.toString();
                  ref.read(plateCalculatorProvider.notifier).setTargetWeight(weight.toDouble());
                  HapticFeedback.selectionClick();
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<int> _getCommonWeights(String unit) {
    if (unit == 'kg') {
      return [20, 40, 60, 80, 100, 120, 140, 160, 180, 200];
    }
    return [45, 95, 135, 185, 225, 275, 315, 365, 405, 495];
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref, PlateCalculatorState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SettingsSheet(state: state),
    );
  }
}

/// Quick add/subtract button
class _QuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        HapticFeedback.selectionClick();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Visual barbell representation
class _BarbellVisualization extends StatelessWidget {
  final PlateCalculatorState state;

  const _BarbellVisualization({required this.state});

  @override
  Widget build(BuildContext context) {
    final platesNeeded = state.calculatePlatesNeeded();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          children: [
            Text(
              'Plates Per Side',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            SizedBox(
              height: 100,
              child: CustomPaint(
                painter: _BarbellPainter(
                  platesNeeded: platesNeeded,
                  unit: state.unit,
                ),
                size: const Size(double.infinity, 100),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            if (state.achievedWeight != state.targetWeight)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  'Closest: ${state.achievedWeight.toStringAsFixed(1)} ${state.unit}',
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for barbell
class _BarbellPainter extends CustomPainter {
  final Map<double, int> platesNeeded;
  final String unit;

  _BarbellPainter({required this.platesNeeded, required this.unit});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final barHeight = 8.0;

    // Draw bar
    final barPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, centerY),
          width: size.width - 40,
          height: barHeight,
        ),
        const Radius.circular(2),
      ),
      barPaint,
    );

    // Draw collar
    final collarPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2 - 80, centerY),
        width: 12,
        height: 20,
      ),
      collarPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2 + 80, centerY),
        width: 12,
        height: 20,
      ),
      collarPaint,
    );

    // Draw plates (left side)
    var offsetLeft = size.width / 2 - 90;
    var offsetRight = size.width / 2 + 90;

    final sortedPlates = platesNeeded.keys.toList()..sort((a, b) => b.compareTo(a));

    for (final plate in sortedPlates) {
      final count = platesNeeded[plate] ?? 0;
      final height = _getPlateHeight(plate, unit);
      final color = _getPlateColor(plate, unit);

      for (int i = 0; i < count; i++) {
        // Left side
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(offsetLeft - 8, centerY),
              width: 12,
              height: height,
            ),
            const Radius.circular(2),
          ),
          Paint()..color = color,
        );
        offsetLeft -= 14;

        // Right side
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(offsetRight + 8, centerY),
              width: 12,
              height: height,
            ),
            const Radius.circular(2),
          ),
          Paint()..color = color,
        );
        offsetRight += 14;
      }
    }
  }

  double _getPlateHeight(double weight, String unit) {
    if (unit == 'kg') {
      if (weight >= 25) return 80;
      if (weight >= 20) return 75;
      if (weight >= 15) return 65;
      if (weight >= 10) return 55;
      if (weight >= 5) return 45;
      return 35;
    } else {
      if (weight >= 45) return 80;
      if (weight >= 35) return 70;
      if (weight >= 25) return 60;
      if (weight >= 10) return 50;
      if (weight >= 5) return 40;
      return 30;
    }
  }

  Color _getPlateColor(double weight, String unit) {
    if (unit == 'kg') {
      if (weight >= 25) return Colors.red;
      if (weight >= 20) return Colors.blue;
      if (weight >= 15) return Colors.yellow[700]!;
      if (weight >= 10) return Colors.green;
      if (weight >= 5) return Colors.white;
      return Colors.grey;
    } else {
      if (weight >= 45) return Colors.blue;
      if (weight >= 35) return Colors.yellow[700]!;
      if (weight >= 25) return Colors.green;
      if (weight >= 10) return Colors.white;
      if (weight >= 5) return Colors.red;
      return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Plates needed breakdown card
class _PlatesNeededCard extends StatelessWidget {
  final PlateCalculatorState state;

  const _PlatesNeededCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final platesNeeded = state.calculatePlatesNeeded();
    final sortedPlates = platesNeeded.keys.toList()..sort((a, b) => b.compareTo(a));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plates Needed (per side)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    '${state.achievedWeight.toStringAsFixed(state.unit == 'lbs' ? 0 : 1)} ${state.unit}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (platesNeeded.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fitness_center, color: AppColors.grey400),
                    const SizedBox(width: 8),
                    Text(
                      'Just the bar!',
                      style: TextStyle(color: AppColors.grey500),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: sortedPlates.map((plate) {
                  final count = platesNeeded[plate]!;
                  return _PlateChip(
                    weight: plate,
                    count: count,
                    unit: state.unit,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

/// Single plate chip
class _PlateChip extends StatelessWidget {
  final double weight;
  final int count;
  final String unit;

  const _PlateChip({
    required this.weight,
    required this.count,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        children: [
          Text(
            '${weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '$unit × $count',
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings bottom sheet
class _SettingsSheet extends ConsumerWidget {
  final PlateCalculatorState state;

  const _SettingsSheet({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
              children: [
                // Unit selector
                Text('Unit', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'lbs', label: Text('Pounds (lbs)')),
                    ButtonSegment(value: 'kg', label: Text('Kilograms (kg)')),
                  ],
                  selected: {state.unit},
                  onSelectionChanged: (selection) {
                    ref.read(plateCalculatorProvider.notifier).setUnit(selection.first);
                  },
                ),

                const SizedBox(height: AppDimensions.spacingLg),

                // Bar weight
                Text('Bar Weight', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _getBarOptions(state.unit).map((weight) {
                    final isSelected = state.barWeight == weight;
                    return ChoiceChip(
                      label: Text('${weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1)} ${state.unit}'),
                      selected: isSelected,
                      onSelected: (_) {
                        ref.read(plateCalculatorProvider.notifier).setBarWeight(weight);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppDimensions.spacingLg),

                // Available plates
                Text('Available Plates', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...state.availablePlates.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${entry.key.toStringAsFixed(entry.key % 1 == 0 ? 0 : 1)} ${state.unit}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: entry.value.toDouble(),
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: '${entry.value} per side',
                            onChanged: (value) {
                              ref.read(plateCalculatorProvider.notifier)
                                  .updatePlateCount(entry.key, value.round());
                            },
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text('×${entry.value}', textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<double> _getBarOptions(String unit) {
    if (unit == 'kg') {
      return [10, 15, 20];
    }
    return [15, 35, 45];
  }
}
