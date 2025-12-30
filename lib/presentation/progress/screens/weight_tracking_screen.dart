import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Provider for weight tracking data
final weightTrackingProvider = StateNotifierProvider<WeightTrackingNotifier, WeightTrackingState>((ref) {
  return WeightTrackingNotifier();
});

/// Weight tracking state
class WeightTrackingState {
  final List<WeightEntry> entries;
  final bool isLoading;
  final String unit; // 'lbs' or 'kg'
  final double? goalWeight;

  const WeightTrackingState({
    this.entries = const [],
    this.isLoading = true,
    this.unit = 'lbs',
    this.goalWeight,
  });

  WeightTrackingState copyWith({
    List<WeightEntry>? entries,
    bool? isLoading,
    String? unit,
    double? goalWeight,
  }) {
    return WeightTrackingState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      unit: unit ?? this.unit,
      goalWeight: goalWeight ?? this.goalWeight,
    );
  }
}

/// Single weight entry
class WeightEntry {
  final String id;
  final DateTime date;
  final double weight;
  final String? notes;

  WeightEntry({
    required this.id,
    required this.date,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'weight': weight,
    'notes': notes,
  };

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

/// Weight tracking state notifier
class WeightTrackingNotifier extends StateNotifier<WeightTrackingState> {
  WeightTrackingNotifier() : super(const WeightTrackingState()) {
    _loadData();
  }

  static const _storageKey = 'weight_entries';
  static const _unitKey = 'weight_unit';
  static const _goalKey = 'weight_goal';

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final unit = prefs.getString(_unitKey) ?? 'lbs';
    final goal = prefs.getDouble(_goalKey);
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      final entries = jsonList.map((e) => WeightEntry.fromJson(e)).toList();
      entries.sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(entries: entries, isLoading: false, unit: unit, goalWeight: goal);
    } else {
      state = state.copyWith(isLoading: false, unit: unit, goalWeight: goal);
    }
  }

  Future<void> addEntry(WeightEntry entry) async {
    final newEntries = [entry, ...state.entries];
    newEntries.sort((a, b) => b.date.compareTo(a.date));
    state = state.copyWith(entries: newEntries);
    await _save();
  }

  Future<void> deleteEntry(String id) async {
    final newEntries = state.entries.where((e) => e.id != id).toList();
    state = state.copyWith(entries: newEntries);
    await _save();
  }

  Future<void> setUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
    state = state.copyWith(unit: unit);
  }

  Future<void> setGoal(double? goal) async {
    final prefs = await SharedPreferences.getInstance();
    if (goal != null) {
      await prefs.setDouble(_goalKey, goal);
    } else {
      await prefs.remove(_goalKey);
    }
    state = state.copyWith(goalWeight: goal);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.entries.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Calculate exponential moving average for trend smoothing
  List<double> calculateTrend(int days) {
    if (state.entries.isEmpty) return [];

    final sortedEntries = [...state.entries]..sort((a, b) => a.date.compareTo(b.date));
    final weights = sortedEntries.map((e) => e.weight).toList();

    // Simple exponential smoothing with alpha = 0.3
    const alpha = 0.3;
    final trend = <double>[weights.first];

    for (int i = 1; i < weights.length; i++) {
      trend.add(alpha * weights[i] + (1 - alpha) * trend[i - 1]);
    }

    return trend;
  }
}

/// Weight tracking screen
class WeightTrackingScreen extends ConsumerWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weightTrackingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Tracker'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'lbs' || value == 'kg') {
                ref.read(weightTrackingProvider.notifier).setUnit(value);
              } else if (value == 'goal') {
                _showGoalDialog(context, ref, state);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'goal',
                child: Row(
                  children: [
                    const Icon(Icons.flag, size: 20),
                    const SizedBox(width: 8),
                    Text(state.goalWeight != null ? 'Edit Goal' : 'Set Goal'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'lbs',
                child: Row(
                  children: [
                    if (state.unit == 'lbs') const Icon(Icons.check, size: 18),
                    SizedBox(width: state.unit == 'lbs' ? 8 : 26),
                    const Text('Pounds (lbs)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'kg',
                child: Row(
                  children: [
                    if (state.unit == 'kg') const Icon(Icons.check, size: 18),
                    SizedBox(width: state.unit == 'kg' ? 8 : 26),
                    const Text('Kilograms (kg)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.entries.isEmpty
              ? _EmptyState(onAdd: () => _showAddSheet(context, ref, state.unit))
              : _WeightContent(
                  state: state,
                  onAdd: () => _showAddSheet(context, ref, state.unit),
                ),
      floatingActionButton: state.entries.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSheet(context, ref, state.unit),
              icon: const Icon(Icons.add),
              label: const Text('Log Weight'),
            )
          : null,
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref, String unit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddWeightSheet(
        unit: unit,
        onSave: (entry) {
          ref.read(weightTrackingProvider.notifier).addEntry(entry);
        },
      ),
    );
  }

  void _showGoalDialog(BuildContext context, WidgetRef ref, WeightTrackingState state) {
    final controller = TextEditingController(
      text: state.goalWeight?.toStringAsFixed(1) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weight Goal'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Target Weight',
            suffixText: state.unit,
          ),
          autofocus: true,
        ),
        actions: [
          if (state.goalWeight != null)
            TextButton(
              onPressed: () {
                ref.read(weightTrackingProvider.notifier).setGoal(null);
                Navigator.pop(context);
              },
              child: const Text('Remove Goal'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                ref.read(weightTrackingProvider.notifier).setGoal(value);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monitor_weight,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'Track Your Weight',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Log your weight regularly to see trends over time. Daily fluctuations are normal - the trend line shows your true progress.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Log First Weight'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Weight content with chart and history
class _WeightContent extends ConsumerWidget {
  final WeightTrackingState state;
  final VoidCallback onAdd;

  const _WeightContent({required this.state, required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = state.entries.first;
    final oldest = state.entries.length > 1 ? state.entries.last : null;
    final change = oldest != null ? latest.weight - oldest.weight : null;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        // Current weight card
        _CurrentWeightCard(
          weight: latest.weight,
          unit: state.unit,
          change: change,
          goalWeight: state.goalWeight,
        ),

        const SizedBox(height: AppDimensions.spacingLg),

        // Weight chart
        if (state.entries.length >= 2)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weight Trend',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.grey400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Actual', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 12),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Trend', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  SizedBox(
                    height: 200,
                    child: _WeightChart(
                      entries: state.entries,
                      unit: state.unit,
                      goalWeight: state.goalWeight,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: AppDimensions.spacingLg),

        // History header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${state.entries.length} entries',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Entry list
        ...state.entries.asMap().entries.map((mapEntry) {
          final index = mapEntry.key;
          final entry = mapEntry.value;
          final prevEntry = index < state.entries.length - 1 ? state.entries[index + 1] : null;
          final diff = prevEntry != null ? entry.weight - prevEntry.weight : null;

          return _WeightEntryCard(
            entry: entry,
            unit: state.unit,
            diff: diff,
            onDelete: () {
              ref.read(weightTrackingProvider.notifier).deleteEntry(entry.id);
            },
          );
        }),
      ],
    );
  }
}

/// Current weight display card
class _CurrentWeightCard extends StatelessWidget {
  final double weight;
  final String unit;
  final double? change;
  final double? goalWeight;

  const _CurrentWeightCard({
    required this.weight,
    required this.unit,
    this.change,
    this.goalWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          children: [
            Text(
              'Current Weight',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weight.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    unit,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                ),
              ],
            ),
            if (change != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    change! > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: change! > 0 ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${change! > 0 ? '+' : ''}${change!.toStringAsFixed(1)} $unit total',
                    style: TextStyle(
                      color: change! > 0 ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (goalWeight != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flag, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Goal: ${goalWeight!.toStringAsFixed(1)} $unit',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${(goalWeight! - weight).abs().toStringAsFixed(1)} $unit ${goalWeight! > weight ? 'to go' : 'below'})',
                    style: TextStyle(color: AppColors.grey500),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Weight chart with trend line
class _WeightChart extends ConsumerWidget {
  final List<WeightEntry> entries;
  final String unit;
  final double? goalWeight;

  const _WeightChart({
    required this.entries,
    required this.unit,
    this.goalWeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(weightTrackingProvider.notifier);
    final trend = notifier.calculateTrend(30);

    return CustomPaint(
      painter: _WeightChartPainter(
        entries: entries.reversed.toList(), // Oldest first for chart
        trend: trend,
        goalWeight: goalWeight,
        primaryColor: AppColors.primary,
        gridColor: AppColors.grey300,
      ),
      size: const Size(double.infinity, 200),
    );
  }
}

/// Custom painter for weight chart
class _WeightChartPainter extends CustomPainter {
  final List<WeightEntry> entries;
  final List<double> trend;
  final double? goalWeight;
  final Color primaryColor;
  final Color gridColor;

  _WeightChartPainter({
    required this.entries,
    required this.trend,
    this.goalWeight,
    required this.primaryColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final weights = entries.map((e) => e.weight).toList();
    final allValues = [...weights, ...trend];
    if (goalWeight != null) allValues.add(goalWeight!);

    final minWeight = allValues.reduce(math.min) - 2;
    final maxWeight = allValues.reduce(math.max) + 2;
    final range = maxWeight - minWeight;

    final padding = 40.0;
    final chartWidth = size.width - padding;
    final chartHeight = size.height - 20;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(Offset(padding, y), Offset(size.width, y), gridPaint);

      final weight = maxWeight - (range * (i / 4));
      final textPainter = TextPainter(
        text: TextSpan(
          text: weight.toStringAsFixed(0),
          style: TextStyle(color: gridColor, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    // Draw goal line
    if (goalWeight != null) {
      final goalY = chartHeight * (1 - (goalWeight! - minWeight) / range);
      final goalPaint = Paint()
        ..color = AppColors.success.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      const dashWidth = 5.0;
      const dashSpace = 3.0;
      var startX = padding;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, goalY),
          Offset(math.min(startX + dashWidth, size.width), goalY),
          goalPaint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    // Draw data points
    final pointPaint = Paint()
      ..color = AppColors.grey400
      ..style = PaintingStyle.fill;

    final xStep = chartWidth / (entries.length - 1).clamp(1, double.infinity);

    for (int i = 0; i < entries.length; i++) {
      final x = padding + (i * xStep);
      final y = chartHeight * (1 - (weights[i] - minWeight) / range);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }

    // Draw trend line
    if (trend.length >= 2) {
      final trendPath = Path();
      final trendPaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < trend.length; i++) {
        final x = padding + (i * xStep);
        final y = chartHeight * (1 - (trend[i] - minWeight) / range);
        if (i == 0) {
          trendPath.moveTo(x, y);
        } else {
          trendPath.lineTo(x, y);
        }
      }

      canvas.drawPath(trendPath, trendPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Weight entry card
class _WeightEntryCard extends StatelessWidget {
  final WeightEntry entry;
  final String unit;
  final double? diff;
  final VoidCallback onDelete;

  const _WeightEntryCard({
    required this.entry,
    required this.unit,
    this.diff,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final diffColor = diff == null
        ? AppColors.grey500
        : diff! > 0
            ? AppColors.success
            : diff! < 0
                ? AppColors.error
                : AppColors.grey500;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            '${entry.date.day}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              '${entry.weight.toStringAsFixed(1)} $unit',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (diff != null && diff != 0) ...[
              const SizedBox(width: 8),
              Text(
                '${diff! > 0 ? '+' : ''}${diff!.toStringAsFixed(1)}',
                style: TextStyle(
                  color: diffColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(_formatDate(entry.date)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => _confirmDelete(context),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This weight entry will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Add weight bottom sheet
class AddWeightSheet extends StatefulWidget {
  final String unit;
  final Function(WeightEntry) onSave;

  const AddWeightSheet({
    super.key,
    required this.unit,
    required this.onSave,
  });

  @override
  State<AddWeightSheet> createState() => _AddWeightSheetState();
}

class _AddWeightSheetState extends State<AddWeightSheet> {
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid weight')),
      );
      return;
    }

    final entry = WeightEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      weight: weight,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    widget.onSave(entry);
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            'Log Weight',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Date picker
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey300),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Weight input
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Weight',
              suffixText: widget.unit,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Notes input
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'e.g., Morning weight, after workout',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Save button
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
