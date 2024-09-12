import 'package:intl/intl.dart';

String formatDateTime(dynamic dateTime) {
  if (dateTime == null || dateTime.toString().isEmpty) return '';
  try {
    final parsedDate = DateTime.parse(dateTime.toString());
    final formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분');
    return formatter.format(parsedDate);
  } catch (e) {
    return dateTime.toString();
  }
}

String formatValue(dynamic value) {
  return value?.toString() ?? '';
}
