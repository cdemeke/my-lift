import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the Settings service
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

/// Provider for Gemini API key
final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  final settings = ref.watch(settingsServiceProvider);
  return settings.getGeminiApiKey();
});

/// Provider for dark mode setting
final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref.watch(settingsServiceProvider));
});

class DarkModeNotifier extends StateNotifier<bool> {
  final SettingsService _settings;

  DarkModeNotifier(this._settings) : super(false) {
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    state = await _settings.getDarkMode();
  }

  Future<void> toggle() async {
    state = !state;
    await _settings.setDarkMode(state);
  }

  Future<void> setDarkMode(bool value) async {
    state = value;
    await _settings.setDarkMode(value);
  }
}

/// Service for managing app settings with SharedPreferences
class SettingsService {
  static const String _geminiApiKeyKey = 'gemini_api_key';
  static const String _darkModeKey = 'dark_mode';
  static const String _weightUnitKey = 'weight_unit';
  static const String _defaultRestTimeKey = 'default_rest_time';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _workoutRemindersKey = 'workout_reminders';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Gemini API Key
  Future<String?> getGeminiApiKey() async {
    final prefs = await _prefs;
    return prefs.getString(_geminiApiKeyKey);
  }

  Future<void> setGeminiApiKey(String apiKey) async {
    final prefs = await _prefs;
    await prefs.setString(_geminiApiKeyKey, apiKey);
  }

  Future<void> clearGeminiApiKey() async {
    final prefs = await _prefs;
    await prefs.remove(_geminiApiKeyKey);
  }

  // Dark Mode
  Future<bool> getDarkMode() async {
    final prefs = await _prefs;
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_darkModeKey, enabled);
  }

  // Weight Unit
  Future<String> getWeightUnit() async {
    final prefs = await _prefs;
    return prefs.getString(_weightUnitKey) ?? 'lbs';
  }

  Future<void> setWeightUnit(String unit) async {
    final prefs = await _prefs;
    await prefs.setString(_weightUnitKey, unit);
  }

  // Default Rest Time (in seconds)
  Future<int> getDefaultRestTime() async {
    final prefs = await _prefs;
    return prefs.getInt(_defaultRestTimeKey) ?? 90;
  }

  Future<void> setDefaultRestTime(int seconds) async {
    final prefs = await _prefs;
    await prefs.setInt(_defaultRestTimeKey, seconds);
  }

  // Notifications
  Future<bool> getNotificationsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  // Workout Reminders
  Future<bool> getWorkoutReminders() async {
    final prefs = await _prefs;
    return prefs.getBool(_workoutRemindersKey) ?? true;
  }

  Future<void> setWorkoutReminders(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_workoutRemindersKey, enabled);
  }
}
