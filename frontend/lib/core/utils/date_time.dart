import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._(); // prevent instantiate

  /// Parse ISO string from API → DateTime (local)
  static DateTime parse(String isoString) {
    return DateTime.parse(isoString).toLocal();
  }

  /// Format → 13/01/2026
  static String formatDate(String isoString) {
    final dt = parse(isoString);
    return DateFormat('dd/MM/yyyy', 'en_US').format(dt);
  }

  /// Format → 19:37
  static String formatTime(String isoString) {
    final dt = parse(isoString);
    return DateFormat('HH:mm', 'en_US').format(dt);
  }

  /// Format → 13/01/2026 19:37
  static String formatDateTime(String isoString) {
    final dt = parse(isoString);
    return DateFormat('dd/MM/yyyy HH:mm', 'en_US').format(dt);
  }

  /// Format → Senin, Selasa, dst
  static String formatDay(DateTime date) {
    return DateFormat('EEEE', 'en_US').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM', 'en_US').format(date);
  }

  static String formatPeriod(DateTime start, DateTime end) {
    final sameMonth = start.month == end.month && start.year == end.year;
    final sameYear = start.year == end.year;

    if (sameMonth) {
      return '${DateFormat('d', 'en_US').format(start)}–'
          '${DateFormat('d MMMM yyyy', 'en_US').format(end)}';
    }

    if (sameYear) {
      return '${DateFormat('d MMMM', 'en_US').format(start)}–'
          '${DateFormat('d MMMM yyyy', 'en_US').format(end)}';
    }

    return '${DateFormat('d MMMM yyyy', 'en_US').format(start)}–'
        '${DateFormat('d MMMM yyyy', 'en_US').format(end)}';
  }
}
