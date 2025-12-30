import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Provider for progress photos data
final progressPhotosProvider = StateNotifierProvider<ProgressPhotosNotifier, ProgressPhotosState>((ref) {
  return ProgressPhotosNotifier();
});

/// Progress photos state
class ProgressPhotosState {
  final List<ProgressPhotoEntry> entries;
  final bool isLoading;

  const ProgressPhotosState({
    this.entries = const [],
    this.isLoading = true,
  });

  ProgressPhotosState copyWith({
    List<ProgressPhotoEntry>? entries,
    bool? isLoading,
  }) {
    return ProgressPhotosState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Single photo entry
class ProgressPhotoEntry {
  final String id;
  final DateTime date;
  final String frontPath;
  final String? sidePath;
  final String? backPath;
  final double? weight;
  final String? notes;

  ProgressPhotoEntry({
    required this.id,
    required this.date,
    required this.frontPath,
    this.sidePath,
    this.backPath,
    this.weight,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'frontPath': frontPath,
    'sidePath': sidePath,
    'backPath': backPath,
    'weight': weight,
    'notes': notes,
  };

  factory ProgressPhotoEntry.fromJson(Map<String, dynamic> json) {
    return ProgressPhotoEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      frontPath: json['frontPath'] as String,
      sidePath: json['sidePath'] as String?,
      backPath: json['backPath'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

/// Progress photos state notifier
class ProgressPhotosNotifier extends StateNotifier<ProgressPhotosState> {
  ProgressPhotosNotifier() : super(const ProgressPhotosState()) {
    _loadPhotos();
  }

  static const _storageKey = 'progress_photos';

  Future<void> _loadPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      final entries = jsonList.map((e) => ProgressPhotoEntry.fromJson(e)).toList();
      entries.sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(entries: entries, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addEntry(ProgressPhotoEntry entry) async {
    final newEntries = [entry, ...state.entries];
    state = state.copyWith(entries: newEntries);
    await _save();
  }

  Future<void> deleteEntry(String id) async {
    final entry = state.entries.firstWhere((e) => e.id == id);

    // Delete image files
    final files = [entry.frontPath, entry.sidePath, entry.backPath];
    for (final path in files) {
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    final newEntries = state.entries.where((e) => e.id != id).toList();
    state = state.copyWith(entries: newEntries);
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.entries.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}

/// Progress photos screen
class ProgressPhotosScreen extends ConsumerWidget {
  const ProgressPhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressPhotosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Photos'),
        actions: [
          if (state.entries.length >= 2)
            IconButton(
              icon: const Icon(Icons.compare),
              tooltip: 'Compare photos',
              onPressed: () => _showCompareSheet(context, state.entries),
            ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.entries.isEmpty
              ? _EmptyState(onAdd: () => _showAddSheet(context, ref))
              : _PhotosGrid(
                  entries: state.entries,
                  onAdd: () => _showAddSheet(context, ref),
                ),
      floatingActionButton: state.entries.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSheet(context, ref),
              icon: const Icon(Icons.add_a_photo),
              label: const Text('New Photo'),
            )
          : null,
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPhotoSheet(
        onSave: (entry) {
          ref.read(progressPhotosProvider.notifier).addEntry(entry);
        },
      ),
    );
  }

  void _showCompareSheet(BuildContext context, List<ProgressPhotoEntry> entries) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PhotoCompareSheet(entries: entries),
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
                Icons.photo_camera,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'Document Your Journey',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Take progress photos to visually track your transformation. Compare side-by-side to see how far you\'ve come.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Take First Photo'),
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

/// Photos grid view
class _PhotosGrid extends ConsumerWidget {
  final List<ProgressPhotoEntry> entries;
  final VoidCallback onAdd;

  const _PhotosGrid({required this.entries, required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      children: [
        // Timeline view
        ...entries.map((entry) => _PhotoEntryCard(entry: entry)),
      ],
    );
  }
}

/// Photo entry card
class _PhotoEntryCard extends ConsumerWidget {
  final ProgressPhotoEntry entry;

  const _PhotoEntryCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(entry.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (entry.weight != null)
                  Text(
                    '${entry.weight!.toStringAsFixed(1)} lbs',
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                PopupMenuButton(
                  itemBuilder: (context) => [
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
                    if (value == 'delete') {
                      _confirmDelete(context, ref);
                    }
                  },
                ),
              ],
            ),
          ),

          // Photos row
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(child: _PhotoTile(path: entry.frontPath, label: 'Front')),
                if (entry.sidePath != null)
                  Expanded(child: _PhotoTile(path: entry.sidePath!, label: 'Side')),
                if (entry.backPath != null)
                  Expanded(child: _PhotoTile(path: entry.backPath!, label: 'Back')),
              ],
            ),
          ),

          // Notes
          if (entry.notes != null && entry.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                entry.notes!,
                style: TextStyle(color: AppColors.grey600),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photos?'),
        content: const Text('This progress photo entry will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(progressPhotosProvider.notifier).deleteEntry(entry.id);
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

/// Single photo tile
class _PhotoTile extends StatelessWidget {
  final String path;
  final String label;

  const _PhotoTile({required this.path, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreen(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: AppColors.grey200,
              child: const Icon(Icons.broken_image, size: 40, color: AppColors.grey400),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(path)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Add photo bottom sheet
class AddPhotoSheet extends StatefulWidget {
  final Function(ProgressPhotoEntry) onSave;

  const AddPhotoSheet({super.key, required this.onSave});

  @override
  State<AddPhotoSheet> createState() => _AddPhotoSheetState();
}

class _AddPhotoSheetState extends State<AddPhotoSheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _frontPhoto;
  XFile? _sidePhoto;
  XFile? _backPhoto;
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(String type) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final photo = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (photo != null) {
      setState(() {
        switch (type) {
          case 'front':
            _frontPhoto = photo;
            break;
          case 'side':
            _sidePhoto = photo;
            break;
          case 'back':
            _backPhoto = photo;
            break;
        }
      });
    }
  }

  Future<void> _save() async {
    if (_frontPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Front photo is required')),
      );
      return;
    }

    // Save photos to app directory
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${dir.path}/progress_photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final frontPath = '${photosDir.path}/${id}_front.jpg';
    await File(_frontPhoto!.path).copy(frontPath);

    String? sidePath;
    if (_sidePhoto != null) {
      sidePath = '${photosDir.path}/${id}_side.jpg';
      await File(_sidePhoto!.path).copy(sidePath);
    }

    String? backPath;
    if (_backPhoto != null) {
      backPath = '${photosDir.path}/${id}_back.jpg';
      await File(_backPhoto!.path).copy(backPath);
    }

    final entry = ProgressPhotoEntry(
      id: id,
      date: _selectedDate,
      frontPath: frontPath,
      sidePath: sidePath,
      backPath: backPath,
      weight: _weightController.text.isNotEmpty
          ? double.tryParse(_weightController.text)
          : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    widget.onSave(entry);
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                  'Add Progress Photos',
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

                const SizedBox(height: AppDimensions.spacingLg),

                // Photo pickers
                Text(
                  'Photos',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Row(
                  children: [
                    Expanded(
                      child: _PhotoPickerTile(
                        photo: _frontPhoto,
                        label: 'Front *',
                        onTap: () => _pickPhoto('front'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PhotoPickerTile(
                        photo: _sidePhoto,
                        label: 'Side',
                        onTap: () => _pickPhoto('side'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PhotoPickerTile(
                        photo: _backPhoto,
                        label: 'Back',
                        onTap: () => _pickPhoto('back'),
                      ),
                    ),
                  ],
                ),
                Text(
                  '* Front photo required',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey500,
                      ),
                ),

                const SizedBox(height: AppDimensions.spacingLg),

                // Weight input
                TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Weight (optional)',
                    suffixText: 'lbs',
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
                    hintText: 'e.g., End of bulk phase',
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
                  label: const Text('Save Photos'),
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

/// Photo picker tile
class _PhotoPickerTile extends StatelessWidget {
  final XFile? photo;
  final String label;
  final VoidCallback onTap;

  const _PhotoPickerTile({
    required this.photo,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: photo != null ? AppColors.primary : AppColors.grey300,
              width: photo != null ? 2 : 1,
            ),
          ),
          child: photo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd - 1),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(photo!.path),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 32,
                      color: AppColors.grey400,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Photo comparison sheet
class PhotoCompareSheet extends StatefulWidget {
  final List<ProgressPhotoEntry> entries;

  const PhotoCompareSheet({super.key, required this.entries});

  @override
  State<PhotoCompareSheet> createState() => _PhotoCompareSheetState();
}

class _PhotoCompareSheetState extends State<PhotoCompareSheet> {
  late ProgressPhotoEntry _leftEntry;
  late ProgressPhotoEntry _rightEntry;

  @override
  void initState() {
    super.initState();
    _leftEntry = widget.entries.last; // Oldest
    _rightEntry = widget.entries.first; // Newest
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
                  'Compare Progress',
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

          // Date selectors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
            child: Row(
              children: [
                Expanded(
                  child: _DateSelector(
                    label: 'Before',
                    entry: _leftEntry,
                    entries: widget.entries,
                    onChanged: (entry) => setState(() => _leftEntry = entry),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DateSelector(
                    label: 'After',
                    entry: _rightEntry,
                    entries: widget.entries,
                    onChanged: (entry) => setState(() => _rightEntry = entry),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Comparison view
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.file(
                    File(_leftEntry.frontPath),
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: 2,
                  color: AppColors.grey300,
                ),
                Expanded(
                  child: Image.file(
                    File(_rightEntry.frontPath),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Stats comparison
          if (_leftEntry.weight != null && _rightEntry.weight != null)
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('${_leftEntry.weight!.toStringAsFixed(1)} lbs'),
                        Text('Before', style: TextStyle(color: AppColors.grey500, fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${(_rightEntry.weight! - _leftEntry.weight!) > 0 ? '+' : ''}${(_rightEntry.weight! - _leftEntry.weight!).toStringAsFixed(1)} lbs',
                          style: TextStyle(
                            color: (_rightEntry.weight! - _leftEntry.weight!) > 0
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Change', style: TextStyle(color: AppColors.grey500, fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('${_rightEntry.weight!.toStringAsFixed(1)} lbs'),
                        Text('After', style: TextStyle(color: AppColors.grey500, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Date selector dropdown
class _DateSelector extends StatelessWidget {
  final String label;
  final ProgressPhotoEntry entry;
  final List<ProgressPhotoEntry> entries;
  final Function(ProgressPhotoEntry) onChanged;

  const _DateSelector({
    required this.label,
    required this.entry,
    required this.entries,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.grey500, fontSize: 12)),
        const SizedBox(height: 4),
        DropdownButtonFormField<ProgressPhotoEntry>(
          value: entry,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
          ),
          items: entries.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text('${months[e.date.month - 1]} ${e.date.day}, ${e.date.year}'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ],
    );
  }
}
