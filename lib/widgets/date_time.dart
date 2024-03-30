import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMMM d').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
