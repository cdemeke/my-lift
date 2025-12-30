import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for managing workout reminders
class WorkoutReminderService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const _reminderKey = 'workout_reminders';

  /// Initialize the notification service
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  static void _onNotificationResponse(NotificationResponse response) {
    // Handle notification tap - could navigate to workout screen
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.requestNotificationsPermission();
    }
    if (ios != null) {
      await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return true;
  }

  /// Schedule a workout reminder
  static Future<void> scheduleReminder(WorkoutReminder reminder) async {
    final prefs = await SharedPreferences.getInstance();
    final reminders = await getReminders();
    reminders.add(reminder);

    await prefs.setString(
      _reminderKey,
      jsonEncode(reminders.map((r) => r.toJson()).toList()),
    );

    // Schedule the notification
    await _scheduleNotification(reminder);
  }

  /// Cancel a reminder
  static Future<void> cancelReminder(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final reminders = await getReminders();
    reminders.removeWhere((r) => r.id == id);

    await prefs.setString(
      _reminderKey,
      jsonEncode(reminders.map((r) => r.toJson()).toList()),
    );

    // Cancel the notification
    await _notifications.cancel(id.hashCode);
  }

  /// Get all scheduled reminders
  static Future<List<WorkoutReminder>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_reminderKey);

    if (json == null) return [];

    try {
      final list = jsonDecode(json) as List;
      return list.map((item) => WorkoutReminder.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Update a reminder
  static Future<void> updateReminder(WorkoutReminder reminder) async {
    await cancelReminder(reminder.id);
    await scheduleReminder(reminder);
  }

  /// Schedule notification for a reminder
  static Future<void> _scheduleNotification(WorkoutReminder reminder) async {
    if (!reminder.enabled) return;

    final androidDetails = AndroidNotificationDetails(
      'workout_reminders',
      'Workout Reminders',
      channelDescription: 'Reminders for your scheduled workouts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // For each day of week, schedule the notification
    for (final day in reminder.daysOfWeek) {
      final nextOccurrence = _getNextOccurrence(day, reminder.time);

      await _notifications.zonedSchedule(
        '${reminder.id}_$day'.hashCode,
        reminder.title,
        reminder.body,
        nextOccurrence,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: reminder.workoutId,
      );
    }
  }

  static TZDateTime _getNextOccurrence(int dayOfWeek, TimeOfDay time) {
    final now = TZDateTime.now(local);
    var scheduled = TZDateTime(
      local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Find the next occurrence of this day
    while (scheduled.weekday != dayOfWeek || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Send an immediate motivational notification
  static Future<void> sendMotivationalNotification() async {
    const messages = [
      ("Time to lift! 💪", "Your muscles are waiting. Let's go!"),
      ("No excuses today!", "Even a short workout counts."),
      ("Consistency beats perfection", "Show up and do your best."),
      ("Remember why you started", "Every rep brings you closer to your goals."),
      ("Your future self will thank you", "Get moving!"),
    ];

    final message = messages[DateTime.now().millisecond % messages.length];

    const androidDetails = AndroidNotificationDetails(
      'motivation',
      'Motivation',
      channelDescription: 'Motivational workout reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      DateTime.now().millisecond,
      message.$1,
      message.$2,
      details,
    );
  }
}

// Timezone placeholder (would use timezone package in production)
final local = LocalLocation();

class LocalLocation {
  const LocalLocation();
}

class TZDateTime extends DateTime {
  final LocalLocation location;

  TZDateTime(this.location, int year, [int month = 1, int day = 1, int hour = 0, int minute = 0])
      : super(year, month, day, hour, minute);

  static TZDateTime now(LocalLocation loc) {
    final now = DateTime.now();
    return TZDateTime(loc, now.year, now.month, now.day, now.hour, now.minute);
  }
}

/// Workout reminder model
class WorkoutReminder {
  final String id;
  final String title;
  final String body;
  final TimeOfDay time;
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final bool enabled;
  final String? workoutId; // Optional linked workout

  const WorkoutReminder({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.daysOfWeek,
    this.enabled = true,
    this.workoutId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timeHour': time.hour,
        'timeMinute': time.minute,
        'daysOfWeek': daysOfWeek,
        'enabled': enabled,
        'workoutId': workoutId,
      };

  factory WorkoutReminder.fromJson(Map<String, dynamic> json) {
    return WorkoutReminder(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      time: TimeOfDay(hour: json['timeHour'], minute: json['timeMinute']),
      daysOfWeek: List<int>.from(json['daysOfWeek']),
      enabled: json['enabled'] ?? true,
      workoutId: json['workoutId'],
    );
  }

  WorkoutReminder copyWith({
    String? id,
    String? title,
    String? body,
    TimeOfDay? time,
    List<int>? daysOfWeek,
    bool? enabled,
    String? workoutId,
  }) {
    return WorkoutReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      enabled: enabled ?? this.enabled,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  String get daysText {
    if (daysOfWeek.length == 7) return 'Every day';
    if (daysOfWeek.length == 5 &&
        daysOfWeek.contains(1) &&
        daysOfWeek.contains(2) &&
        daysOfWeek.contains(3) &&
        daysOfWeek.contains(4) &&
        daysOfWeek.contains(5)) {
      return 'Weekdays';
    }
    if (daysOfWeek.length == 2 &&
        daysOfWeek.contains(6) &&
        daysOfWeek.contains(7)) {
      return 'Weekends';
    }

    const dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek.map((d) => dayNames[d]).join(', ');
  }
}
