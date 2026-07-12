import 'package:intl/intl.dart';

int extractTimestamp(int id) {
  const epoch = 1772841600;
  const timeshift = 22;
  return (id >> timeshift) + epoch;
}

String getLongDate(int id) {
  final timestamp = extractTimestamp(id);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat.yMd().add_jm().format(dateTime);
}
