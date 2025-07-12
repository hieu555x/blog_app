import 'package:intl/intl.dart';

String formatDateByDDMMYYYY(DateTime date) {
  return DateFormat('dd MMM, yyyy').format(date);
}

String formatTimeHHMMSS(DateTime time) {
  return DateFormat('hh:mm:ss').format(time);
}
