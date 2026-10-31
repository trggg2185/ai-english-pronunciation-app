import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _ymdFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _dayMonthFormat = DateFormat('dd/MM');

  static String toYmd(DateTime date) => _ymdFormat.format(date);

  static DateTime fromYmd(String ymd) => _ymdFormat.parse(ymd);

  static String toDisplay(DateTime date) => _displayFormat.format(date);

  static String toDayMonth(DateTime date) => _dayMonthFormat.format(date);

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
