import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Model for workout and set notes
class WorkoutNote {
  final String id;
  final String content;
  final DateTime timestamp;
  final NoteType type;
  final String? exerciseId;
  final int? setNumber;

  WorkoutNote({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.type,
    this.exerciseId,
    this.setNumber,
  });

  WorkoutNote copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    NoteType? type,
    String? exerciseId,
    int? setNumber,
  }) {
    return WorkoutNote(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'exerciseId': exerciseId,
        'setNumber': setNumber,
      };

  factory WorkoutNote.fromJson(Map<String, dynamic> json) {
    return WorkoutNote(
      id: json['id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NoteType.values.firstWhere((e) => e.name == json['type']),
      exerciseId: json['exerciseId'],
      setNumber: json['setNumber'],
    );
  }
}

enum NoteType {
  workout, // General workout note
  exercise, // Note for specific exercise
  set, // Note for specific set
}

/// Compact note indicator that can be shown on sets/exercises
class NoteIndicator extends StatelessWidget {
  final bool hasNote;
  final VoidCallback onTap;

  const NoteIndicator({
    super.key,
    required this.hasNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: hasNote
              ? AppColors.warning.withOpacity(0.1)
              : AppColors.grey100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          hasNote ? Icons.sticky_note_2 : Icons.sticky_note_2_outlined,
          size: 14,
          color: hasNote ? AppColors.warning : AppColors.grey400,
        ),
      ),
    );
  }
}

/// Quick note input for inline use
class QuickNoteInput extends StatefulWidget {
  final String? initialNote;
  final String placeholder;
  final Function(String) onNoteChanged;
  final VoidCallback? onNoteDeleted;

  const QuickNoteInput({
    super.key,
    this.initialNote,
    this.placeholder = 'Add a note...',
    required this.onNoteChanged,
    this.onNoteDeleted,
  });

  @override
  State<QuickNoteInput> createState() => _QuickNoteInputState();
}

class _QuickNoteInputState extends State<QuickNoteInput> {
  late TextEditingController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
    _isExpanded = widget.initialNote?.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded && (widget.initialNote?.isEmpty ?? true)) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _isExpanded = true);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.grey300,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_comment_outlined,
                size: 16,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 6),
              Text(
                widget.placeholder,
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Icon(
                Icons.sticky_note_2,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Text(
                'Note',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warning,
                ),
              ),
              const Spacer(),
              if (widget.onNoteDeleted != null)
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _controller.clear();
                    widget.onNoteDeleted?.call();
                    setState(() => _isExpanded = false);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.grey500,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 1,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: AppColors.grey400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onNoteChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full workout notes panel
class WorkoutNotesPanel extends StatefulWidget {
  final List<WorkoutNote> notes;
  final Function(WorkoutNote) onNoteAdded;
  final Function(String) onNoteDeleted;
  final Function(WorkoutNote) onNoteUpdated;

  const WorkoutNotesPanel({
    super.key,
    required this.notes,
    required this.onNoteAdded,
    required this.onNoteDeleted,
    required this.onNoteUpdated,
  });

  @override
  State<WorkoutNotesPanel> createState() => _WorkoutNotesPanelState();
}

class _WorkoutNotesPanelState extends State<WorkoutNotesPanel> {
  final TextEditingController _newNoteController = TextEditingController();

  @override
  void dispose() {
    _newNoteController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_newNoteController.text.trim().isEmpty) return;

    final note = WorkoutNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _newNoteController.text.trim(),
      timestamp: DateTime.now(),
      type: NoteType.workout,
    );

    widget.onNoteAdded(note);
    _newNoteController.clear();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.sticky_note_2,
                  color: AppColors.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Workout Notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '${widget.notes.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // New note input
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _newNoteController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Add a workout note...',
                    filled: true,
                    fillColor: AppColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addNote,
                icon: const Icon(Icons.send),
                color: AppColors.primary,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes list
          if (widget.notes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 48,
                      color: AppColors.grey300,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No notes yet',
                      style: TextStyle(
                        color: AppColors.grey500,
                      ),
                    ),
                    Text(
                      'Add notes to track form cues, energy levels, or anything else',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...widget.notes.map((note) => _NoteCard(
                  note: note,
                  onDelete: () => widget.onNoteDeleted(note.id),
                  onUpdate: (content) {
                    widget.onNoteUpdated(note.copyWith(content: content));
                  },
                )),
        ],
      ),
    );
  }
}

class _NoteCard extends StatefulWidget {
  final WorkoutNote note;
  final VoidCallback onDelete;
  final Function(String) onUpdate;

  const _NoteCard({
    required this.note,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<_NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<_NoteCard> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${timestamp.month}/${timestamp.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getNoteIcon(widget.note.type),
                size: 14,
                color: AppColors.warning,
              ),
              const SizedBox(width: 6),
              Text(
                _formatTimestamp(widget.note.timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey500,
                ),
              ),
              if (widget.note.exerciseId != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.note.setNumber != null
                        ? 'Set ${widget.note.setNumber}'
                        : 'Exercise',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _isEditing = !_isEditing);
                  if (!_isEditing) {
                    widget.onUpdate(_controller.text);
                  }
                },
                child: Icon(
                  _isEditing ? Icons.check : Icons.edit_outlined,
                  size: 16,
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onDelete();
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isEditing)
            TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 1,
              autofocus: true,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            )
          else
            Text(
              widget.note.content,
              style: const TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }

  IconData _getNoteIcon(NoteType type) {
    switch (type) {
      case NoteType.workout:
        return Icons.fitness_center;
      case NoteType.exercise:
        return Icons.sports_gymnastics;
      case NoteType.set:
        return Icons.repeat;
    }
  }
}

/// Quick note button for the active workout screen
class QuickNoteButton extends StatelessWidget {
  final int noteCount;
  final VoidCallback onTap;

  const QuickNoteButton({
    super.key,
    required this.noteCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: noteCount > 0
              ? AppColors.warning.withOpacity(0.1)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: noteCount > 0 ? AppColors.warning : AppColors.grey300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              noteCount > 0 ? Icons.sticky_note_2 : Icons.sticky_note_2_outlined,
              size: 16,
              color: noteCount > 0 ? AppColors.warning : AppColors.grey500,
            ),
            const SizedBox(width: 6),
            Text(
              noteCount > 0 ? '$noteCount Notes' : 'Add Note',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: noteCount > 0 ? AppColors.warning : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Set note inline widget
class SetNoteWidget extends StatelessWidget {
  final String? note;
  final Function(String?) onNoteChanged;

  const SetNoteWidget({
    super.key,
    this.note,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNoteEditor(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: note != null
              ? AppColors.warning.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              note != null ? Icons.sticky_note_2 : Icons.add_comment_outlined,
              size: 14,
              color: note != null ? AppColors.warning : AppColors.grey400,
            ),
            if (note != null) ...[
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  note!,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showNoteEditor(BuildContext context) {
    final controller = TextEditingController(text: note);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Note'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Add a note for this set...',
            filled: true,
            fillColor: AppColors.grey100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          if (note != null)
            TextButton(
              onPressed: () {
                onNoteChanged(null);
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newNote = controller.text.trim();
              onNoteChanged(newNote.isEmpty ? null : newNote);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
