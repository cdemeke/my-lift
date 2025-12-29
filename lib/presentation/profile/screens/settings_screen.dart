import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/settings_service.dart';

/// Settings screen for app preferences.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _workoutReminders = true;
  bool _coachCheckIns = true;
  String _weightUnit = 'lbs';
  String _restTimerSound = 'default';
  int _defaultRestTime = 90;
  String? _geminiApiKey;
  bool _isLoadingApiKey = true;

  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = ref.read(settingsServiceProvider);
    final apiKey = await settings.getGeminiApiKey();
    final weightUnit = await settings.getWeightUnit();
    final restTime = await settings.getDefaultRestTime();
    final notifications = await settings.getNotificationsEnabled();
    final reminders = await settings.getWorkoutReminders();

    setState(() {
      _geminiApiKey = apiKey;
      _apiKeyController.text = apiKey ?? '';
      _weightUnit = weightUnit;
      _defaultRestTime = restTime;
      _notificationsEnabled = notifications;
      _workoutReminders = reminders;
      _isLoadingApiKey = false;
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          // AI Coach section
          _buildSectionHeader('AI Coach'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: const Text('Gemini API Key'),
                  subtitle: Text(
                    _isLoadingApiKey
                        ? 'Loading...'
                        : _geminiApiKey != null && _geminiApiKey!.isNotEmpty
                            ? 'Configured'
                            : 'Not configured',
                    style: TextStyle(
                      color: _geminiApiKey != null && _geminiApiKey!.isNotEmpty
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showApiKeyDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.primary),
                  title: const Text('Get API Key'),
                  subtitle: const Text('Free from Google AI Studio'),
                  onTap: () async {
                    final uri = Uri.parse('https://aistudio.google.com/apikey');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Appearance section
          _buildSectionHeader('Appearance'),
          Card(
            child: SwitchListTile(
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primary,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(isDarkMode ? 'Dark theme enabled' : 'Light theme enabled'),
              value: isDarkMode,
              onChanged: (value) {
                ref.read(darkModeProvider.notifier).setDarkMode(value);
              },
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Notifications section
          _buildSectionHeader('Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive push notifications'),
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    setState(() => _notificationsEnabled = value);
                    await ref.read(settingsServiceProvider).setNotificationsEnabled(value);
                  },
                ),
                if (_notificationsEnabled) ...[
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.alarm, color: AppColors.primary),
                    title: const Text('Workout Reminders'),
                    subtitle: const Text('Daily reminders for scheduled workouts'),
                    value: _workoutReminders,
                    onChanged: (value) async {
                      setState(() => _workoutReminders = value);
                      await ref.read(settingsServiceProvider).setWorkoutReminders(value);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                    title: const Text('Coach Check-ins'),
                    subtitle: const Text('Messages when you miss a workout'),
                    value: _coachCheckIns,
                    onChanged: (value) {
                      setState(() => _coachCheckIns = value);
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Units section
          _buildSectionHeader('Units'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.straighten, color: AppColors.primary),
              title: const Text('Weight Unit'),
              subtitle: Text(_weightUnit == 'lbs' ? 'Pounds (lbs)' : 'Kilograms (kg)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showUnitPicker,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Workout section
          _buildSectionHeader('Workout'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.music_note, color: AppColors.primary),
                  title: const Text('Rest Timer Sound'),
                  subtitle: Text(_restTimerSound == 'default' ? 'Default' : _restTimerSound),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showSoundPicker,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.timer, color: AppColors.primary),
                  title: const Text('Default Rest Time'),
                  subtitle: Text('$_defaultRestTime seconds'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showRestTimePicker,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Data section
          _buildSectionHeader('Data'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download_outlined, color: AppColors.primary),
                  title: const Text('Export Data'),
                  subtitle: const Text('Download your workout history'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export feature coming soon!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync_outlined, color: AppColors.primary),
                  title: const Text('Sync Status'),
                  subtitle: const Text('All data synced'),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // About section
          _buildSectionHeader('About'),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outlined, color: AppColors.primary),
                  title: Text('App Version'),
                  subtitle: Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: const Text('Terms of Service'),
                  onTap: () {
                    // TODO: Open terms
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    // TODO: Open privacy policy
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Danger zone
          _buildSectionHeader('Danger Zone'),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.delete_forever_outlined,
                color: AppColors.error,
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: _showDeleteAccountDialog,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.paddingXs,
        bottom: AppDimensions.spacingSm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Gemini API Key'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your Gemini API key to enable AI-powered coaching features.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'API Key',
                hintText: 'AIza...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.key),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse('https://aistudio.google.com/apikey');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Get free API key from Google AI Studio'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (_geminiApiKey != null && _geminiApiKey!.isNotEmpty)
            TextButton(
              onPressed: () async {
                await ref.read(settingsServiceProvider).clearGeminiApiKey();
                setState(() {
                  _geminiApiKey = null;
                  _apiKeyController.clear();
                });
                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API key removed')),
                );
              },
              child: const Text('Remove', style: TextStyle(color: AppColors.error)),
            ),
          ElevatedButton(
            onPressed: () async {
              final key = _apiKeyController.text.trim();
              if (key.isNotEmpty) {
                await ref.read(settingsServiceProvider).setGeminiApiKey(key);
                setState(() => _geminiApiKey = key);
                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('API key saved! AI Coach is now enabled.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showUnitPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weight Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Pounds (lbs)'),
              value: 'lbs',
              groupValue: _weightUnit,
              onChanged: (value) async {
                setState(() => _weightUnit = value!);
                await ref.read(settingsServiceProvider).setWeightUnit(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Kilograms (kg)'),
              value: 'kg',
              groupValue: _weightUnit,
              onChanged: (value) async {
                setState(() => _weightUnit = value!);
                await ref.read(settingsServiceProvider).setWeightUnit(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSoundPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rest Timer Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Default'),
              value: 'default',
              groupValue: _restTimerSound,
              onChanged: (value) {
                setState(() => _restTimerSound = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Bell'),
              value: 'bell',
              groupValue: _restTimerSound,
              onChanged: (value) {
                setState(() => _restTimerSound = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Chime'),
              value: 'chime',
              groupValue: _restTimerSound,
              onChanged: (value) {
                setState(() => _restTimerSound = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('None'),
              value: 'none',
              groupValue: _restTimerSound,
              onChanged: (value) {
                setState(() => _restTimerSound = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRestTimePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Rest Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final seconds in [30, 45, 60, 90, 120, 180])
              RadioListTile<int>(
                title: Text('$seconds seconds'),
                value: seconds,
                groupValue: _defaultRestTime,
                onChanged: (value) async {
                  setState(() => _defaultRestTime = value!);
                  await ref.read(settingsServiceProvider).setDefaultRestTime(value!);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete account
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
}
