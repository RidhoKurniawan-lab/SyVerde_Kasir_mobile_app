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
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  /// Format → 19:37
  static String formatTime(String isoString) {
    final dt = parse(isoString);
    return DateFormat('HH:mm').format(dt);
  }

  /// Format → 13/01/2026 19:37
  static String formatDateTime(String isoString) {
    final dt = parse(isoString);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }
}
