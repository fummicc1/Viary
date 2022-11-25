
import 'package:intl/intl.dart';

extension DateTimeDescription on DateTime {
  String format() {
    final now = DateTime.now();
    final sameDay = now.day == day && now.month == month && now.year == year;
    if (!sameDay) {
      final DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return dateFormat.format(this);
    }
    final diff = now.difference(this);
    final hour = diff.inHours;
    final minute = diff.inMinutes;
    return "$hour時間$minute分前";
  }
}