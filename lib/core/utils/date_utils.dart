import 'package:intl/intl.dart';

/// Date formatting and manipulation utilities.
class AppDateUtils {
  AppDateUtils._();

  /// Format date as "Mon, Jan 1"
  static String formatShortDate(DateTime date) {
    return DateFormat('E, MMM d').format(date);
  }

  /// Format date as "Monday, January 1"
  static String formatLongDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  /// Format date as "January 1, 2024"
  static String formatFullDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  /// Format date as "01/01/2024"
  static String formatNumericDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  /// Format time as "9:30 AM"
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format duration as "45 min" or "1h 15min"
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${remainingMinutes}min';
  }

  /// Format seconds as "1:30" (mm:ss)
  static String formatSecondsAsTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Get start of week (Monday) for a given date
  static DateTime getStartOfWeek(DateTime date) {
    final dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday
    return DateTime(date.year, date.month, date.day - (dayOfWeek - 1));
  }

  /// Get end of week (Sunday) for a given date
  static DateTime getEndOfWeek(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return startOfWeek.add(const Duration(days: 6));
  }

  /// Get start of day (00:00:00)
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day (23:59:59)
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Check if date is in the past (before today)
  static bool isPast(DateTime date) {
    final today = getStartOfDay(DateTime.now());
    return date.isBefore(today);
  }

  /// Check if date is in the future (after today)
  static bool isFuture(DateTime date) {
    final today = getEndOfDay(DateTime.now());
    return date.isAfter(today);
  }

  /// Get relative time string ("2 hours ago", "in 3 days", etc.)
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      // Future
      final futureDiff = date.difference(now);
      if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} day${futureDiff.inDays > 1 ? 's' : ''}';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} hour${futureDiff.inHours > 1 ? 's' : ''}';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} minute${futureDiff.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'now';
      }
    } else {
      // Past
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'just now';
      }
    }
  }

  /// Get list of dates for the week containing the given date
  static List<DateTime> getWeekDates(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
  }

  /// Get day of week as string (1 = "Monday", etc.)
  static String getDayName(int dayOfWeek) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dayOfWeek - 1];
  }

  /// Get short day of week as string (1 = "Mon", etc.)
  static String getDayNameShort(int dayOfWeek) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dayOfWeek - 1];
  }
}
