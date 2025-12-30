import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Provider for measurements data
final measurementsProvider = StateNotifierProvider<MeasurementsNotifier, MeasurementsState>((ref) {
  return MeasurementsNotifier();
});

/// Measurements state
class MeasurementsState {
  final List<MeasurementEntry> entries;
  final bool isLoading;
  final String unit; // 'in' or 'cm'

  const MeasurementsState({
    this.entries = const [],
    this.isLoading = true,
    this.unit = 'in',
  });

  MeasurementsState copyWith({
    List<MeasurementEntry>? entries,
    bool? isLoading,
    String? unit,
  }) {
    return MeasurementsState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      unit: unit ?? this.unit,
    );
  }
}

/// Single measurement entry with all body parts
class MeasurementEntry {
  final String id;
  final DateTime date;
  final Map<String, double> measurements;
  final String? notes;

  MeasurementEntry({
    required this.id,
    required this.date,
    required this.measurements,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'measurements': measurements,
    'notes': notes,
  };

  factory MeasurementEntry.fromJson(Map<String, dynamic> json) {
    return MeasurementEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      measurements: Map<String, double>.from(json['measurements'] as Map),
      notes: json['notes'] as String?,
    );
  }
}

/// Measurements state notifier
class MeasurementsNotifier extends StateNotifier<MeasurementsState> {
  MeasurementsNotifier() : super(const MeasurementsState()) {
    _loadMeasurements();
  }

  static const _storageKey = 'body_measurements';
  static const _unitKey = 'measurement_unit';

  Future<void> _loadMeasurements() async {
    final prefs = await SharedPreferences.getInstance();
    final unit = prefs.getString(_unitKey) ?? 'in';
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      final entries = jsonList.map((e) => MeasurementEntry.fromJson(e)).toList();
      entries.sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(entries: entries, isLoading: false, unit: unit);
    } else {
      state = state.copyWith(isLoading: false, unit: unit);
    }
  }

  Future<void> addEntry(MeasurementEntry entry) async {
    final newEntries = [entry, ...state.entries];
    state = state.copyWith(entries: newEntries);
    await _save();
  }

  Future<void> updateEntry(MeasurementEntry entry) async {
    final index = state.entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      final newEntries = [...state.entries];
      newEntries[index] = entry;
      state = state.copyWith(entries: newEntries);
      await _save();
    }
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

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.entries.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}

/// Body measurement parts
class MeasurementPart {
  final String id;
  final String name;
  final String icon;
  final String description;

  const MeasurementPart({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

const measurementParts = [
  MeasurementPart(id: 'neck', name: 'Neck', icon: '🎯', description: 'Around middle of neck'),
  MeasurementPart(id: 'shoulders', name: 'Shoulders', icon: '💪', description: 'Widest point across'),
  MeasurementPart(id: 'chest', name: 'Chest', icon: '🫁', description: 'At nipple level'),
  MeasurementPart(id: 'left_arm', name: 'Left Arm', icon: '💪', description: 'Flexed bicep peak'),
  MeasurementPart(id: 'right_arm', name: 'Right Arm', icon: '💪', description: 'Flexed bicep peak'),
  MeasurementPart(id: 'waist', name: 'Waist', icon: '📏', description: 'At navel level'),
  MeasurementPart(id: 'hips', name: 'Hips', icon: '🦴', description: 'Widest point'),
  MeasurementPart(id: 'left_thigh', name: 'Left Thigh', icon: '🦵', description: 'Midway between hip and knee'),
  MeasurementPart(id: 'right_thigh', name: 'Right Thigh', icon: '🦵', description: 'Midway between hip and knee'),
  MeasurementPart(id: 'left_calf', name: 'Left Calf', icon: '🦶', description: 'Widest point'),
  MeasurementPart(id: 'right_calf', name: 'Right Calf', icon: '🦶', description: 'Widest point'),
];

/// Measurements tracking screen
class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Measurements'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.straighten),
            onSelected: (unit) {
              ref.read(measurementsProvider.notifier).setUnit(unit);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'in',
                child: Row(
                  children: [
                    if (state.unit == 'in') const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Inches'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'cm',
                child: Row(
                  children: [
                    if (state.unit == 'cm') const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Centimeters'),
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
              : _MeasurementsList(
                  entries: state.entries,
                  unit: state.unit,
                  onAdd: () => _showAddSheet(context, ref, state.unit),
                ),
      floatingActionButton: state.entries.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSheet(context, ref, state.unit),
              icon: const Icon(Icons.add),
              label: const Text('New Entry'),
            )
          : null,
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref, String unit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMeasurementSheet(
        unit: unit,
        onSave: (entry) {
          ref.read(measurementsProvider.notifier).addEntry(entry);
        },
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
                Icons.straighten,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'Track Your Progress',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Log body measurements over time to see your transformation. Track arms, chest, waist, and more.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add First Measurement'),
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

/// Measurements list widget
class _MeasurementsList extends StatelessWidget {
  final List<MeasurementEntry> entries;
  final String unit;
  final VoidCallback onAdd;

  const _MeasurementsList({
    required this.entries,
    required this.unit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Get latest entry for summary
    final latest = entries.isNotEmpty ? entries.first : null;
    final previous = entries.length > 1 ? entries[1] : null;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        // Progress summary card
        if (latest != null) _ProgressSummaryCard(latest: latest, previous: previous, unit: unit),

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
              '${entries.length} entries',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Entry cards
        ...entries.map((entry) => _MeasurementEntryCard(entry: entry, unit: unit)),
      ],
    );
  }
}

/// Progress summary showing latest vs previous
class _ProgressSummaryCard extends StatelessWidget {
  final MeasurementEntry latest;
  final MeasurementEntry? previous;
  final String unit;

  const _ProgressSummaryCard({
    required this.latest,
    required this.previous,
    required this.unit,
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
                const Icon(Icons.trending_up, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Latest Measurements',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: measurementParts.where((part) {
                return latest.measurements.containsKey(part.id);
              }).map((part) {
                final value = latest.measurements[part.id]!;
                final prevValue = previous?.measurements[part.id];
                final diff = prevValue != null ? value - prevValue : null;

                return _MeasurementChip(
                  label: part.name,
                  value: value,
                  diff: diff,
                  unit: unit,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single measurement chip with value and diff
class _MeasurementChip extends StatelessWidget {
  final String label;
  final double value;
  final double? diff;
  final String unit;

  const _MeasurementChip({
    required this.label,
    required this.value,
    this.diff,
    required this.unit,
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${value.toStringAsFixed(1)} $unit',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (diff != null && diff != 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${diff! > 0 ? '+' : ''}${diff!.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: diffColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Entry card in history list
class _MeasurementEntryCard extends ConsumerWidget {
  final MeasurementEntry entry;
  final String unit;

  const _MeasurementEntryCard({required this.entry, required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementCount = entry.measurements.length;

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
        title: Text(
          _formatDate(entry.date),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$measurementCount measurements'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'view') {
              _showDetailSheet(context, entry, unit);
            } else if (value == 'delete') {
              _confirmDelete(context, ref, entry);
            }
          },
        ),
        onTap: () => _showDetailSheet(context, entry, unit),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDetailSheet(BuildContext context, MeasurementEntry entry, String unit) {
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
              _formatDate(entry.date),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            ...measurementParts.where((p) => entry.measurements.containsKey(p.id)).map((part) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(part.name),
                    Text(
                      '${entry.measurements[part.id]!.toStringAsFixed(1)} $unit',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              const Divider(),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(entry.notes!, style: TextStyle(color: AppColors.grey600)),
            ],
            const SizedBox(height: AppDimensions.spacingLg),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MeasurementEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This measurement entry will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(measurementsProvider.notifier).deleteEntry(entry.id);
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

/// Add measurement bottom sheet
class AddMeasurementSheet extends StatefulWidget {
  final String unit;
  final Function(MeasurementEntry) onSave;
  final MeasurementEntry? existingEntry;

  const AddMeasurementSheet({
    super.key,
    required this.unit,
    required this.onSave,
    this.existingEntry,
  });

  @override
  State<AddMeasurementSheet> createState() => _AddMeasurementSheetState();
}

class _AddMeasurementSheetState extends State<AddMeasurementSheet> {
  late DateTime _selectedDate;
  final Map<String, TextEditingController> _controllers = {};
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.existingEntry?.date ?? DateTime.now();

    for (final part in measurementParts) {
      final existingValue = widget.existingEntry?.measurements[part.id];
      _controllers[part.id] = TextEditingController(
        text: existingValue?.toStringAsFixed(1) ?? '',
      );
    }

    _notesController.text = widget.existingEntry?.notes ?? '';
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final measurements = <String, double>{};

    for (final part in measurementParts) {
      final text = _controllers[part.id]!.text.trim();
      if (text.isNotEmpty) {
        final value = double.tryParse(text);
        if (value != null && value > 0) {
          measurements[part.id] = value;
        }
      }
    }

    if (measurements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one measurement')),
      );
      return;
    }

    final entry = MeasurementEntry(
      id: widget.existingEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      measurements: measurements,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    widget.onSave(entry);
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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

          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingEntry != null ? 'Edit Measurements' : 'New Measurements',
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

          // Date picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
            child: InkWell(
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
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Measurement inputs
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
              children: [
                Text(
                  'Enter measurements (${widget.unit})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.grey500,
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                ...measurementParts.map((part) => _MeasurementInput(
                  part: part,
                  controller: _controllers[part.id]!,
                  unit: widget.unit,
                )),
                const SizedBox(height: AppDimensions.spacingMd),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'e.g., Measured in morning after workout',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppDimensions.spacingXl),
              ],
            ),
          ),

          // Save button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('Save Measurements'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single measurement input row
class _MeasurementInput extends StatelessWidget {
  final MeasurementPart part;
  final TextEditingController controller;
  final String unit;

  const _MeasurementInput({
    required this.part,
    required this.controller,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  part.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey500,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                suffixText: unit,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
