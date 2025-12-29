import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/gym_profile_model.dart';

/// Screen for managing gym profiles.
class GymProfilesScreen extends ConsumerStatefulWidget {
  const GymProfilesScreen({super.key});

  @override
  ConsumerState<GymProfilesScreen> createState() => _GymProfilesScreenState();
}

class _GymProfilesScreenState extends ConsumerState<GymProfilesScreen> {
  // Mock gym profiles
  final List<Map<String, dynamic>> _profiles = [
    {
      'id': '1',
      'name': 'Home Gym',
      'type': GymProfileType.home,
      'equipment': ['Dumbbells', 'Barbell', 'Bench', 'Pull-up Bar'],
      'isDefault': true,
    },
    {
      'id': '2',
      'name': 'LA Fitness',
      'type': GymProfileType.commercial,
      'equipment': ['Full Equipment'],
      'isDefault': false,
    },
  ];

  String _activeProfileId = '1';

  void _setActiveProfile(String id) {
    setState(() {
      _activeProfileId = id;
    });
    // TODO: Save to database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Active gym profile updated')),
    );
  }

  void _showAddProfileDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddProfileSheet(
        onAdd: (name, type) {
          setState(() {
            _profiles.add({
              'id': DateTime.now().toString(),
              'name': name,
              'type': type,
              'equipment': [],
              'isDefault': false,
            });
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteProfile(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content:
            const Text('Are you sure you want to delete this gym profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _profiles.removeWhere((p) => p['id'] == id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.gymProfiles),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          final profile = _profiles[index];
          final isActive = profile['id'] == _activeProfileId;

          return Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              side: isActive
                  ? const BorderSide(color: AppColors.primary, width: 2)
                  : BorderSide.none,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isActive
                    ? AppColors.primary
                    : AppColors.grey200,
                child: Icon(
                  _getIconForType(profile['type'] as String),
                  color: isActive ? Colors.white : AppColors.grey600,
                ),
              ),
              title: Row(
                children: [
                  Text(profile['name'] as String),
                  if (isActive) ...[
                    const SizedBox(width: AppDimensions.spacingXs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      child: Text(
                        'Active',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Text(
                '${(profile['equipment'] as List).length} equipment items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey500,
                    ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  if (!isActive)
                    const PopupMenuItem(
                      value: 'activate',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline),
                          SizedBox(width: 8),
                          Text('Set as Active'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  if (_profiles.length > 1)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Delete',
                              style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'activate':
                      _setActiveProfile(profile['id'] as String);
                      break;
                    case 'edit':
                      // TODO: Navigate to edit screen
                      break;
                    case 'delete':
                      _deleteProfile(profile['id'] as String);
                      break;
                  }
                },
              ),
              onTap: () {
                if (!isActive) {
                  _setActiveProfile(profile['id'] as String);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProfileDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Profile'),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case GymProfileType.home:
        return Icons.home;
      case GymProfileType.commercial:
        return Icons.fitness_center;
      case GymProfileType.travel:
        return Icons.luggage;
      case GymProfileType.outdoor:
        return Icons.park;
      case GymProfileType.bodyweight:
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center;
    }
  }
}

/// Bottom sheet for adding a new gym profile.
class _AddProfileSheet extends StatefulWidget {
  final void Function(String name, String type) onAdd;

  const _AddProfileSheet({required this.onAdd});

  @override
  State<_AddProfileSheet> createState() => _AddProfileSheetState();
}

class _AddProfileSheetState extends State<_AddProfileSheet> {
  final _nameController = TextEditingController();
  String _selectedType = GymProfileType.home;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingLg,
        right: AppDimensions.paddingLg,
        top: AppDimensions.paddingLg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.paddingLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Gym Profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Profile Name',
              hintText: 'e.g., Home Gym, Planet Fitness',
            ),
            autofocus: true,
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          Text(
            'Profile Type',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: GymProfileType.all.map((type) {
              final isSelected = _selectedType == type;
              return ChoiceChip(
                label: Text(GymProfileType.getDisplayName(type)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedType = type);
                    if (_nameController.text.isEmpty) {
                      _nameController.text = GymProfileType.getDisplayName(type);
                    }
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                widget.onAdd(name, _selectedType);
              }
            },
            child: const Text('Add Profile'),
          ),
        ],
      ),
    );
  }
}
