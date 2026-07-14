import 'package:intl/intl.dart';

int extractTimestamp(int id) {
  const epoch = 1772841600;
  const timeshift = 22;
  return (id >> timeshift) + epoch;
}

String getDate(int id) {
  final timestamp = extractTimestamp(id);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final diff = today.difference(day).inDays;

  if (diff == 0) {
    return 'Today at ${DateFormat.jm().format(dateTime)}';
  } else if (diff == 1) {
    return 'Yesterday at ${DateFormat.jm().format(dateTime)}';
  } else {
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}

String getShortDate(int id) {
  final timestamp = extractTimestamp(id);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  return DateFormat.Hm().format(dateTime);
}

bool isSameDay(int currentId, int nextId) {
  final c = DateTime.fromMillisecondsSinceEpoch(extractTimestamp(currentId));
  final n = DateTime.fromMillisecondsSinceEpoch(extractTimestamp(nextId));
  return (c.year == n.year && c.month == n.month && c.day == n.day);
}

bool isOlderThanFiveMins(int currentId, int nextId) {
  final c = extractTimestamp(currentId);
  final n = extractTimestamp(nextId);

  final difference = n - c;

  return difference > 300_000; // 5 mins in ms
}
